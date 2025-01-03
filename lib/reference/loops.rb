# frozen_string_literal: true

# Reference::Loops クラスは、Ruby のループ構文を学ぶためのクラスです。
# このクラスには以下のループ構文を含むメソッドが含まれています:
# - while ループ
# - until ループ
# - each メソッド
# - times メソッド
module Reference
  class Loops
    # while ループ: 指定した数のカウントダウンを返す
    def while_loop(count)
      result = []
      while count > 0
        result << count
        count -= 1
      end
      result
    end

    # until ループ: 指定した数までカウントアップする
    def until_loop(limit)
      count = 0
      result = []
      until count >= limit
        count += 1
        result << count
      end
      result
    end

    # each メソッド: 配列の各要素を 2 倍にする
    def each_loop(array)
      result = []
      array.each do |item|
        result << item * 2
      end
      result
    end

    # times メソッド: 指定回数だけメッセージを生成する
    def times_loop(times)
      result = []
      times.times do |i|
        result << "Message #{i + 1}"
      end
      result
    end
  end
end
