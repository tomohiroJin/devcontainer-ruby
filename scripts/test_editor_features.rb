# frozen_string_literal: true

# Headless smoke test for the editor features the Dev Container promises:
# Ruby LSP completion, go-to-definition, RuboCop diagnostics and formatting
# (using the same formatter/linter as .vscode/settings.json), and rdbg breakpoints.
# It does not replace a check in the VS Code GUI; it proves the servers behind it work.
#
#   bundle exec ruby scripts/test_editor_features.rb

require 'bundler'
require 'json'
require 'open3'
require 'tmpdir'
require 'timeout'
require 'uri'

ROOT = File.expand_path('..', __dir__)
SETTINGS = JSON.parse(File.read(File.join(ROOT, '.vscode', 'settings.json')))

# Real project files: the spec refers to the class defined in lib/.
SPEC_PATH = File.join(ROOT, 'spec', 'reference', 'samples', 'fizz_buzz_spec.rb')
LIB_PATH = File.join(ROOT, 'lib', 'reference', 'samples', 'fizz_buzz.rb')
# Unsaved buffers (never written to disk), as when typing in a new editor tab.
COMPLETION_PATH = File.join(ROOT, 'lib', 'editor_smoke_unsaved.rb')
UNFORMATTED_PATH = File.join(ROOT, 'lib', 'editor_smoke_unformatted.rb')
COMPLETION_TEXT = "# frozen_string_literal: true\n\nReference::Samples::Fi\n"
UNFORMATTED = <<~RUBY
  # frozen_string_literal: true

  values = [1,2 , 3]
  puts "\#{values.sum}"
RUBY

# Minimal JSON-RPC client over stdio with LSP Content-Length framing.
class LspClient
  def initialize(command, chdir:)
    @stdin, @stdout, @wait = Open3.popen2(*command, chdir: chdir)
    @next_id = 0
  end

  def request(method, params)
    id = (@next_id += 1)
    write(id: id, method: method, params: params)
    loop do
      message = read
      return message.fetch('result') { raise "#{method} failed: #{message['error']}" } if message['id'] == id

      if message.key?('method') && message.key?('id')
        write(id: message['id'], result: nil) # server-to-client request, e.g. workDoneProgress/create
      end
    end
  end

  # Ruby LSP indexes the workspace in the background and reports it via $/progress.
  def wait_for_indexing
    loop do
      message = read
      write(id: message['id'], result: nil) if message.key?('method') && message.key?('id')
      return if message['method'] == '$/progress' && message.dig('params', 'value', 'kind') == 'end'
    end
  end

  def notify(method, params)
    write(method: method, params: params)
  end

  def shutdown
    request('shutdown', nil)
    notify('exit', nil)
    @stdin.close
    @wait.value
  end

  private

  def write(payload)
    body = JSON.generate({ jsonrpc: '2.0' }.merge(payload))
    @stdin.write("Content-Length: #{body.bytesize}\r\n\r\n#{body}")
    @stdin.flush
  end

  def read
    length = nil
    while (line = @stdout.gets("\r\n"))
      break if line == "\r\n"

      length = Integer(line.split(':', 2).last.strip) if line.start_with?('Content-Length')
    end
    raise 'language server closed the connection' unless length

    JSON.parse(@stdout.read(length))
  end
end

def check(description)
  ok = yield
  puts "#{ok ? 'ok' : 'FAIL'} - #{description}"
  ok
end

def open_document(client, path, text)
  uri = URI::File.build(path: path).to_s
  client.notify('textDocument/didOpen',
                textDocument: { uri: uri, languageId: 'ruby', version: 1, text: text })
  uri
end

# Cursor position just after the first occurrence of +token+ in +text+.
def position_after(text, token)
  line = text.lines.index { |l| l.include?(token) }
  { line: line, character: text.lines[line].index(token) + token.size }
end

INITIALIZE_PARAMS = {
  processId: Process.pid,
  rootUri: URI::File.build(path: ROOT).to_s,
  capabilities: {
    general: { positionEncodings: ['utf-16'] },
    window: { workDoneProgress: true },
    textDocument: { diagnostic: {} }
  },
  # Mirrors the workspace settings VS Code passes to Ruby LSP.
  initializationOptions: {
    formatter: SETTINGS.fetch('rubyLsp.formatter'),
    linters: SETTINGS.fetch('rubyLsp.linters'),
    enabledFeatures: { completion: true, definition: true, formatting: true, diagnostics: true }
  }
}.freeze

def lsp_results
  client = LspClient.new(%w[bundle exec ruby-lsp], chdir: ROOT)
  Timeout.timeout(180) do
    client.request('initialize', INITIALIZE_PARAMS)
    client.notify('initialized', {})
    client.wait_for_indexing
    results = [definition_check(client), completion_check(client)] + rubocop_checks(client)
    client.shutdown
    results
  end
end

def definition_check(client)
  spec_text = File.read(SPEC_PATH)
  locations = client.request('textDocument/definition',
                             textDocument: { uri: open_document(client, SPEC_PATH, spec_text) },
                             position: position_after(spec_text, 'Reference::Samples::Fizz'))
  class_line = File.readlines(LIB_PATH).index { |l| l.include?('class FizzBuzz') }
  lib_uri = URI::File.build(path: LIB_PATH).to_s
  check('go to definition jumps from the spec to the class in lib/') do
    Array(locations).any? do |loc|
      (loc['uri'] || loc['targetUri']) == lib_uri &&
        (loc['range'] || loc['targetRange']).dig('start', 'line') == class_line
    end
  end
end

def completion_check(client)
  completion = client.request('textDocument/completion',
                              textDocument: { uri: open_document(client, COMPLETION_PATH, COMPLETION_TEXT) },
                              position: position_after(COMPLETION_TEXT, 'Reference::Samples::Fi'))
  items = completion.is_a?(Hash) ? completion.fetch('items') : Array(completion)
  check('completion offers Reference::Samples::FizzBuzz') do
    items.any? { |item| item['label'].end_with?('FizzBuzz') }
  end
end

def rubocop_checks(client)
  uri = open_document(client, UNFORMATTED_PATH, UNFORMATTED)
  edits = client.request('textDocument/formatting',
                         textDocument: { uri: uri }, options: { tabSize: 2, insertSpaces: true })
  report = client.request('textDocument/diagnostic', textDocument: { uri: uri })
  [
    check('format on save applies RuboCop layout fixes') do
      Array(edits).any? { |edit| edit['newText'].include?('values = [1, 2, 3]') }
    end,
    check('RuboCop diagnostics are published') do
      Array(report&.fetch('items', nil)).any? { |item| item['source'].to_s.casecmp?('rubocop') }
    end
  ]
end

DEBUG_ENV = { 'RUBY_DEBUG_NO_COLOR' => '1', 'RUBY_DEBUG_NO_RELINE' => '1' }.freeze
LAUNCH = JSON.parse(File.read(File.join(ROOT, '.vscode', 'launch.json'))).fetch('configurations')

def debugger_result
  Dir.mktmpdir do |dir|
    script = File.join(dir, 'debug_target.rb')
    File.write(script, "value = 6 * 7\nputs value\n")
    output, = Open3.capture2e(DEBUG_ENV, File.join(ROOT, 'bin', 'rdbg'), '-e', "break #{script}:2 ;; continue",
                              script, chdir: ROOT, stdin_data: "p value\ncontinue\n")
    check('rdbg stops at a breakpoint and evaluates a local') do
      output.include?("Stop by #0  BP - Line  #{script}:2") && output.include?('=> 42')
    end || warn(output)
  end
end

# Builds the command line vscode-rdbg uses for a launch configuration
# (ruby/vscode-rdbg src/extension.ts getExecCommands/getUnixRdbgArgs), except
# --nonstop instead of --stop-at-load because no DAP client attaches here.
def launch_command(config, file, sock_path)
  expand = ->(value) { value.gsub('${workspaceFolder}', ROOT).gsub('${file}', file) }
  # Without `command`, vscode-rdbg runs `bundle exec ruby` (rdbg.useBundler defaults to true and a Gemfile exists).
  ruby = config.fetch('useBundler', true) ? 'bundle exec ruby' : 'ruby'
  exec_command = [config.fetch('command', ruby), expand.call(config.fetch('script')), *config.fetch('args', [])]
  [expand.call(config.fetch('rdbgPath', 'rdbg')), '--command', '--open', '--nonstop', "--sock-path=#{sock_path}",
   '--', *exec_command.join(' ').split]
end

def launch_results
  attached = /DEBUGGER: Debugger can attach via UNIX domain socket/
  targets = { 'Debug current Ruby file' => [File.join(ROOT, 'lib', 'my_project.rb'), attached],
              'Debug RSpec current file' => [SPEC_PATH, /#{attached.source}.* 0 failures/m] }
  targets.map do |name, (file, expected)|
    config = LAUNCH.find { |c| c['name'] == name } or abort "launch.json has no #{name.inspect}"
    Dir.mktmpdir do |dir|
      # VS Code starts the debuggee outside `bundle exec`; drop this script's Bundler env.
      output, status = Bundler.with_unbundled_env do
        Open3.capture2e(DEBUG_ENV, *launch_command(config, file, File.join(dir, 'rdbg.sock')), chdir: ROOT)
      end
      check("launch.json #{name.inspect} starts and runs to completion") do
        status.success? && output.match?(expected) && !output.include?('LoadError')
      end || warn(output)
    end
  end
end

results = lsp_results + [debugger_result] + launch_results
exit(results.all? ? 0 : 1)
