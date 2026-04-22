# frozen_string_literal: true

require 'reference/basic/basics_syntax'

RSpec.describe Reference::Basic::BasicsSyntax do
  let(:basics) { described_class.new }

  describe '::GREETING' do
    it '定数が正しく定義されていること' do
      expect(described_class::GREETING).to eq('こんにちは、Ruby!')
    end
  end

  describe '#define_variables' do
    let(:variables) { basics.define_variables }

    it '整数型の変数が 42 で定義されていること' do
      expect(variables[0]).to eq(42)
    end

    it '浮動小数点型の変数が 3.14 で定義されていること' do
      expect(variables[1]).to eq(3.14)
    end

    it '文字列型の変数が "Rubyの文字列" で定義されていること' do
      expect(variables[2]).to eq('Rubyの文字列')
    end

    it 'シンボル型の変数が :ruby_symbol で定義されていること' do
      expect(variables[3]).to eq(:ruby_symbol)
    end

    it '配列型の変数が [1, 2, 3] で定義されていること' do
      expect(variables[4]).to eq([1, 2, 3])
    end

    it 'ハッシュ型の変数が { name: "Ruby", version: 3.0 } で定義されていること' do
      expect(variables[5]).to eq({ name: 'Ruby', version: 3.0 })
    end

    it '真偽値型の変数が truthy で定義されていること' do
      expect(variables[6]).to be_truthy
    end
  end

  describe '#manipulate_array' do
    it '配列内の各要素が2倍に変換されること' do
      result = basics.manipulate_array([1, 2, 3])
      expect(result).to eq([2, 4, 6])
    end
  end

  describe '#manipulate_hash' do
    it 'ハッシュのキーが大文字に変換され、値が文字列に変換されること' do
      input = { name: 'Ruby', version: 3.0 }
      result = basics.manipulate_hash(input)
      expect(result).to eq({ 'NAME' => 'Ruby', 'VERSION' => '3.0' })
    end
  end
end
