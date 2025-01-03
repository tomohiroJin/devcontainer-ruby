# frozen_string_literal: true

# Reference::BasicsSyntax クラスは、Ruby の基本構文を学ぶためのクラスです。
# このクラスには以下の機能があります:
# - 変数の定義例
# - 配列操作の例
# - ハッシュ操作の例
#
# 使用例:
#   basics = Reference::BasicsSyntax.new
#   puts basics.define_variables
#
module Reference
  # Ruby の基本構文を学ぶためのクラスです。
  class BasicsSyntax
    # 定数の定義
    GREETING = 'こんにちは、Ruby!'

    # 変数の定義
    def define_variables
      integer = 42
      float = 3.14
      string = 'Rubyの文字列'
      symbol = :ruby_symbol
      array = [1, 2, 3]
      hash = { name: 'Ruby', version: 3.0 }
      boolean = true
      [integer, float, string, symbol, array, hash, boolean]
    end

    # 配列操作
    def manipulate_array(array)
      array.map { |i| i * 2 }
    end

    # ハッシュ操作
    def manipulate_hash(hash)
      hash.transform_keys { |key| key.to_s.upcase }.transform_values(&:to_s)
    end
  end
end
