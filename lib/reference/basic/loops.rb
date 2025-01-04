# frozen_string_literal: true

# Reference::Loops クラスは、Ruby のループ構文を学ぶためのクラスです。
#
# 主な内容:
# - while ループ
# - until ループ
# - each メソッド
# - times メソッド
#
# 使用例:
#   loops = Reference::Loops.new
#   puts loops.while_loop(5) # => [5, 4, 3, 2, 1]
#   puts loops.until_loop(3) # => [1, 2, 3]
#   puts loops.each_loop([1, 2, 3]) # => [2, 4, 6]
#   puts loops.times_loop(3) # => ["Message 1", "Message 2", "Message 3"]
module Reference
  # Ruby のループ構文を学ぶためのクラス
  class Loops
    # while ループ: 指定した数のカウントダウンを返します。
    #
    # @param count [Integer] カウントダウンを開始する数
    # @return [Array<Integer>] カウントダウン結果の配列
    #
    # 使用例:
    #   loops = Reference::Loops.new
    #   puts loops.while_loop(5) # => [5, 4, 3, 2, 1]
    def while_loop(count)
      result = []
      while count > 0
        result << count
        count -= 1
      end
      result
    end

    # until ループ: 指定した数までカウントアップします。
    #
    # @param limit [Integer] カウントアップの上限値
    # @return [Array<Integer>] カウントアップ結果の配列
    #
    # 使用例:
    #   loops = Reference::Loops.new
    #   puts loops.until_loop(3) # => [1, 2, 3]
    def until_loop(limit)
      count = 0
      result = []
      until count >= limit
        count += 1
        result << count
      end
      result
    end

    # each メソッド: 配列の各要素を 2 倍にします。
    #
    # @param array [Array<Integer>] 操作対象の配列
    # @return [Array<Integer>] 各要素を 2 倍にした新しい配列
    #
    # 使用例:
    #   loops = Reference::Loops.new
    #   puts loops.each_loop([1, 2, 3]) # => [2, 4, 6]
    def each_loop(array)
      result = []
      array.each do |item|
        result << item * 2
      end
      result
    end

    # times メソッド: 指定回数だけメッセージを生成します。
    #
    # @param times [Integer] 繰り返し回数
    # @return [Array<String>] 各回のメッセージを含む配列
    #
    # 使用例:
    #   loops = Reference::Loops.new
    #   puts loops.times_loop(3) # => ["Message 1", "Message 2", "Message 3"]
    def times_loop(times)
      result = []
      times.times do |i|
        result << "Message #{i + 1}"
      end
      result
    end
  end
end
