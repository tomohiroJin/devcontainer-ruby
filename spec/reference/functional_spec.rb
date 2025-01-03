# frozen_string_literal: true

require 'reference/functional'

RSpec.describe Reference::Functional do
  let(:functional) { Reference::Functional.new }

  describe '#apply_function' do
    it '高階関数を適用する' do
      func = ->(x) { x * x }
      expect(functional.apply_function([1, 2, 3], func)).to eq([1, 4, 9])
    end
  end

  describe '#double_lambda' do
    it '要素を 2 倍にするラムダを生成する' do
      double = functional.double_lambda
      expect([1, 2, 3].map(&double)).to eq([2, 4, 6])
    end
  end

  describe '#immutable_array' do
    it 'イミュータブルな配列を生成する' do
      array = [1, 2, 3]
      result = functional.immutable_array(array)
      expect(result).to eq([2, 3, 4])
      expect { array[0] = 10 }.to raise_error(FrozenError)
    end
  end

  describe '#sum_array' do
    it '配列の合計を計算する' do
      expect(functional.sum_array([1, 2, 3, 4])).to eq(10)
    end
  end

  describe '#pure_addition' do
    it '副作用なしに加算を行う' do
      expect(functional.pure_addition(3, 4)).to eq(7)
    end

    it '異なる引数で異なる結果を返す' do
      expect(functional.pure_addition(5, 10)).to eq(15)
    end
  end
end
