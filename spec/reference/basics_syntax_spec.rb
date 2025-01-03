# frozen_string_literal: true

require 'reference/basics_syntax'

RSpec.describe Reference::BasicsSyntax do
  let(:basics) { Reference::BasicsSyntax.new }

  describe '::GREETING' do
    it '定数が正しく定義されていること' do
      expect(Reference::BasicsSyntax::GREETING).to eq('こんにちは、Ruby!')
    end
  end

  describe '#define_variables' do
    it '基本的なデータ型の変数が正しく定義されていること' do
      integer, float, string, symbol, array, hash, boolean = basics.define_variables

      # 整数型のテスト
      expect(integer).to be_a(Integer)
      expect(integer).to eq(42)

      # 浮動小数点型のテスト
      expect(float).to be_a(Float)
      expect(float).to eq(3.14)

      # 文字列型のテスト
      expect(string).to be_a(String)
      expect(string).to eq('Rubyの文字列')

      # シンボル型のテスト
      expect(symbol).to be_a(Symbol)
      expect(symbol).to eq(:ruby_symbol)

      # 配列型のテスト
      expect(array).to be_a(Array)
      expect(array).to eq([1, 2, 3])

      # ハッシュ型のテスト
      expect(hash).to be_a(Hash)
      expect(hash).to eq({ name: 'Ruby', version: 3.0 })

      # 真偽値型のテスト
      expect(boolean).to be_truthy
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
