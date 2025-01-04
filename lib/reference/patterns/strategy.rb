# frozen_string_literal: true

# Strategy パターンは、アルゴリズムを動的に切り替えることを目的としたデザインパターンです。
#
# この例では、料金計算のアルゴリズムを切り替える実装を示しています。
# - 標準料金
# - 割引料金
# - プレミアム料金
#
# 使用例:
#   calculator = Reference::Patterns::PriceCalculator.new(Reference::Patterns::StandardStrategy.new)
#   puts calculator.calculate(100) # => 100
#   calculator.set_strategy(Reference::Patterns::DiscountStrategy.new)
#   puts calculator.calculate(100) # => 80
module Reference
  module Patterns
    # 戦略のインターフェース
    #
    # 各料金計算アルゴリズムはこのインターフェースを実装します。
    class PricingStrategy
      # 商品の価格を計算する
      #
      # @param base_price [Numeric] 元の価格
      # @return [Numeric] 計算後の価格
      def calculate(base_price)
        raise NotImplementedError, 'サブクラスで calculate メソッドを実装してください'
      end
    end

    # 標準料金の計算アルゴリズム
    class StandardStrategy < PricingStrategy
      # 商品の価格をそのまま返します。
      #
      # @param base_price [Numeric] 元の価格
      # @return [Numeric] 計算後の価格
      def calculate(base_price)
        base_price
      end
    end

    # 割引料金の計算アルゴリズム
    class DiscountStrategy < PricingStrategy
      # 商品の価格を 20% 割引します。
      #
      # @param base_price [Numeric] 元の価格
      # @return [Numeric] 計算後の価格
      def calculate(base_price)
        base_price * 0.8
      end
    end

    # プレミアム料金の計算アルゴリズム
    class PremiumStrategy < PricingStrategy
      # 商品の価格を 50% 増加します。
      #
      # @param base_price [Numeric] 元の価格
      # @return [Numeric] 計算後の価格
      def calculate(base_price)
        base_price * 1.5
      end
    end

    # 戦略を動的に切り替えるためのクラス
    class PriceCalculator
      # 初期化
      #
      # @param strategy [PricingStrategy] 初期の計算戦略
      def initialize(strategy)
        @strategy = strategy
      end

      # 計算戦略を設定します。
      #
      # @param strategy [PricingStrategy] 新しい計算戦略
      def set_strategy(strategy) # rubocop:disable Naming/AccessorMethodName
        @strategy = strategy
      end

      # 商品の価格を計算します。
      #
      # @param base_price [Numeric] 元の価格
      # @return [Numeric] 計算後の価格
      def calculate(base_price)
        @strategy.calculate(base_price)
      end
    end
  end
end
