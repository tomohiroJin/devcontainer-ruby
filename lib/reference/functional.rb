# frozen_string_literal: true

# Reference::Functional クラスは、Ruby の関数型プログラミング要素を学ぶためのクラスです。
# 主な内容:
# - 高階関数
# - ラムダと Proc
# - イミュータブルなデータ操作
# - Enumerable の活用
# - ピュア関数
module Reference
  class Functional
    # 高階関数: 関数を引数として受け取る
    def apply_function(array, func)
      array.map { |element| func.call(element) }
    end

    # ラムダの例: 要素を 2 倍にするラムダを作成
    def double_lambda
      ->(x) { x * 2 }
    end

    # イミュータブルなデータ操作: 元のデータを変更せずに操作
    def immutable_array(array)
      array.freeze.map { |x| x + 1 }
    end

    # Enumerable を利用した高階関数の活用
    def sum_array(array)
      array.reduce(0) { |sum, x| sum + x }
    end

    # ピュア関数の例: 副作用がない単純な関数
    def pure_addition(a, b)
      a + b
    end
  end
end
