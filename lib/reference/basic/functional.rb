# frozen_string_literal: true

# Reference:Basic:Functional クラスは、Ruby の関数型プログラミング要素を学ぶためのクラスです。
#
# 主な内容:
# - 高階関数
# - ラムダと Proc
# - イミュータブルなデータ操作
# - Enumerable の活用
# - ピュア関数
#
# 使用例:
#   functional = Reference::Functional.new
#   result = functional.pure_addition(1, 2)
#   puts result # => 3
#
module Reference
  # Ruby の基本構文を学ぶためのモジュール
  module Basic
    # 関数型プログラミング要素を学ぶためのクラス
    class Functional
      # 高階関数: 関数を引数として受け取る
      #
      # @param array [Array] 処理対象の配列
      # @param func [Proc] 各要素に適用する関数
      # @return [Array] 処理後の配列
      #
      # 使用例:
      #   func = ->(x) { x * x }
      #   functional.apply_function([1, 2, 3], func)
      #   # => [1, 4, 9]
      def apply_function(array, func)
        array.map { |element| func.call(element) }
      end

      # ラムダの例: 要素を 2 倍にするラムダを作成
      #
      # @return [Proc] 要素を 2 倍にするラムダ
      #
      # 使用例:
      #   double = functional.double_lambda
      #   double.call(3) # => 6
      def double_lambda
        ->(x) { x * 2 }
      end

      # イミュータブルなデータ操作: 元のデータを変更せずに操作
      #
      # @param array [Array] 処理対象の配列
      # @return [Array] 1 を加えた新しい配列
      #
      # 使用例:
      #   functional.immutable_array([1, 2, 3])
      #   # => [2, 3, 4]
      def immutable_array(array)
        array.freeze.map { |x| x + 1 }
      end

      # Enumerable を利用した高階関数の活用
      #
      # @param array [Array] 数値の配列
      # @return [Integer] 配列内の数値の合計
      #
      # 使用例:
      #   functional.sum_array([1, 2, 3])
      #   # => 6
      def sum_array(array)
        array.sum
      end

      # ピュア関数の例: 副作用がない単純な関数
      #
      # @param first_number [Integer] 足される数
      # @param second_number [Integer] 足す数
      # @return [Integer] 加算結果
      #
      # 使用例:
      #   functional.pure_addition(3, 4)
      #   # => 7
      def pure_addition(first_number, second_number)
        first_number + second_number
      end
    end
  end
end
