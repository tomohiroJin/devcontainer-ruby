# frozen_string_literal: true

require_relative '../../../lib/reference/patterns/template_method'

RSpec.describe Reference::Patterns::DataProcessor do
  let(:data) { ['Name, Age', 'Alice, 30', 'Bob, 25'] }

  describe 'CSVProcessor' do
    it 'CSV 形式でデータを処理する' do
      processor = Reference::Patterns::CSVProcessor.new
      expect { processor.process(data) }.to output(/CSV processing completed/).to_stdout
    end
  end

  describe 'JSONProcessor' do
    it 'JSON 形式でデータを処理する' do
      processor = Reference::Patterns::JSONProcessor.new
      expect { processor.process(data) }.to output(/JSON processing completed/).to_stdout
    end
  end

  describe 'テンプレートメソッドの動作' do
    it '抽象クラスは直接使用できない' do
      processor = Reference::Patterns::DataProcessor.new
      expect { processor.process(data) }.to raise_error(NotImplementedError)
    end
  end
end
