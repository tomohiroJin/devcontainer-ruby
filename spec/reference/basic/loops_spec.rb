# frozen_string_literal: true

require 'reference/basic/loops'

RSpec.describe Reference::Basic::Loops do
  let(:loops) { Reference::Basic::Loops.new }

  describe '#while_loop' do
    it '指定した数からカウントダウンする' do
      expect(loops.while_loop(5)).to eq([5, 4, 3, 2, 1])
    end

    it '0 から始まる場合は空の配列を返す' do
      expect(loops.while_loop(0)).to eq([])
    end
  end

  describe '#until_loop' do
    it '指定した数までカウントアップする' do
      expect(loops.until_loop(5)).to eq([1, 2, 3, 4, 5])
    end

    it '0 の場合は空の配列を返す' do
      expect(loops.until_loop(0)).to eq([])
    end
  end

  describe '#each_loop' do
    it '配列の各要素を 2 倍にする' do
      expect(loops.each_loop([1, 2, 3])).to eq([2, 4, 6])
    end

    it '空の配列の場合は空の配列を返す' do
      expect(loops.each_loop([])).to eq([])
    end
  end

  describe '#times_loop' do
    it '指定回数のメッセージを生成する' do
      expect(loops.times_loop(3)).to eq(['Message 1', 'Message 2', 'Message 3'])
    end

    it '0 回の場合は空の配列を返す' do
      expect(loops.times_loop(0)).to eq([])
    end
  end
end
