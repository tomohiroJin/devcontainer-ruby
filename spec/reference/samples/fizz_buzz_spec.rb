# frozen_string_literal: true

require 'reference/samples/fizz_buzz'

RSpec.describe Reference::Samples::FizzBuzz do
  describe 'FizzBuzz' do
    let(:fizz_buzz) { Reference::Samples::FizzBuzz.new }
    it '1を渡すと文字列の1が返ること' do
      expect(fizz_buzz.fizz_buzz(1)).to eq('1')
    end

    it '3を渡すと文字列のFizzが返ること' do
      expect(fizz_buzz.fizz_buzz(3)).to eq('Fizz')
    end

    it '5を渡すと文字列のBuzzが返ること' do
      expect(fizz_buzz.fizz_buzz(5)).to eq('Buzz')
    end

    it '15を渡すと文字列のFizzBuzzが返ること' do
      expect(fizz_buzz.fizz_buzz(15)).to eq('FizzBuzz')
    end
  end
end
