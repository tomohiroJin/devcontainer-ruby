# frozen_string_literal: true

require 'reference/patterns/strategy'

RSpec.describe Reference::Patterns::PriceCalculator do
  let(:standard_strategy) { Reference::Patterns::StandardStrategy.new }
  let(:discount_strategy) { Reference::Patterns::DiscountStrategy.new }
  let(:premium_strategy) { Reference::Patterns::PremiumStrategy.new }

  describe '計算戦略の動的切り替え' do
    it '標準料金を計算する' do
      calculator = Reference::Patterns::PriceCalculator.new(standard_strategy)
      expect(calculator.calculate(100)).to eq(100)
    end

    it '割引料金を計算する' do
      calculator = Reference::Patterns::PriceCalculator.new(discount_strategy)
      expect(calculator.calculate(100)).to eq(80)
    end

    it 'プレミアム料金を計算する' do
      calculator = Reference::Patterns::PriceCalculator.new(premium_strategy)
      expect(calculator.calculate(100)).to eq(150)
    end

    it '動的に戦略を切り替える' do
      calculator = Reference::Patterns::PriceCalculator.new(standard_strategy)
      expect(calculator.calculate(100)).to eq(100)

      calculator.set_strategy(discount_strategy)
      expect(calculator.calculate(100)).to eq(80)

      calculator.set_strategy(premium_strategy)
      expect(calculator.calculate(100)).to eq(150)
    end
  end
end
