# frozen_string_literal: true

require 'reference/patterns/decorator'

RSpec.describe Reference::Patterns::Decorator do
  describe 'メッセージのデコレーション' do
    let(:simple_message) { Reference::Patterns::SimpleMessage.new('Hello, World!') }

    it 'シンプルなメッセージを返す' do
      expect(simple_message.content).to eq('Hello, World!')
    end

    it 'プレフィックスを追加する' do
      decorated_message = Reference::Patterns::PrefixDecorator.new(simple_message, '>>> ')
      expect(decorated_message.content).to eq('>>> Hello, World!')
    end

    it 'サフィックスを追加する' do
      decorated_message = Reference::Patterns::SuffixDecorator.new(simple_message, ' <<<')
      expect(decorated_message.content).to eq('Hello, World! <<<')
    end

    it 'プレフィックスとサフィックスを両方追加する' do
      decorated_message = Reference::Patterns::PrefixDecorator.new(simple_message, '>>> ')
      decorated_message = Reference::Patterns::SuffixDecorator.new(decorated_message, ' <<<')
      expect(decorated_message.content).to eq('>>> Hello, World! <<<')
    end
  end
end
