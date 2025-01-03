# frozen_string_literal: true

# Reference::BasicsSyntax クラスは、Ruby の基本構文を学ぶためのクラスです。
#
# 主な機能:
# - 変数の定義例
# - 配列操作の例
# - ハッシュ操作の例
#
# 使用例:
#   basics = Reference::BasicsSyntax.new
#   variables = basics.define_variables
#   puts variables.inspect
module Reference
  # Ruby の基本構文を学ぶためのクラス
  class BasicsSyntax
    # 定数の定義
    #
    # この定数はサンプルとして利用されます。
    GREETING = 'こんにちは、Ruby!'

    # 変数の定義
    #
    # @return [Array] 基本的なデータ型を含む配列
    #
    # 使用例:
    #   basics = Reference::BasicsSyntax.new
    #   variables = basics.define_variables
    #   puts variables.inspect
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
    #
    # @param array [Array<Integer>] 操作対象の配列
    # @return [Array<Integer>] 各要素が 2 倍になった配列
    #
    # 使用例:
    #   basics = Reference::BasicsSyntax.new
    #   result = basics.manipulate_array([1, 2, 3])
    #   puts result.inspect
    def manipulate_array(array)
      array.map { |i| i * 2 }
    end

    # ハッシュ操作
    #
    # @param hash [Hash<Symbol, String>] 操作対象のハッシュ
    # @return [Hash<String, String>] キーを大文字に変換し、値を文字列化した新しいハッシュ
    #
    # 使用例:
    #   basics = Reference::BasicsSyntax.new
    #   result = basics.manipulate_hash({ name: 'Ruby', version: 3.0 })
    #   puts result.inspect
    def manipulate_hash(hash)
      hash.transform_keys { |key| key.to_s.upcase }.transform_values(&:to_s)
    end
  end
end
