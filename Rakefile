# frozen_string_literal: true

require 'rake'
require 'rspec/core/rake_task'

# RSpecタスクの設定
RSpec::Core::RakeTask.new(:spec) do |t|
  t.pattern = 'spec/**/*_spec.rb' # テストファイルのパス
end

# デフォルトタスク
task default: :spec
