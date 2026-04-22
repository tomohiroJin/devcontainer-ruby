# frozen_string_literal: true

require 'reference/patterns/strategy'

RSpec.describe Reference::Patterns::PriceCalculator do
  let(:standard_strategy) { Reference::Patterns::StandardStrategy.new }
  let(:discount_strategy) { Reference::Patterns::DiscountStrategy.new }
  let(:premium_strategy)  { Reference::Patterns::PremiumStrategy.new }

  describe '#calculate' do
    it '標準料金を計算する' do
      calculator = described_class.new(standard_strategy)
      expect(calculator.calculate(100)).to eq(100)
    end

    it '割引料金を計算する' do
      calculator = described_class.new(discount_strategy)
      expect(calculator.calculate(100)).to eq(80)
    end

    it 'プレミアム料金を計算する' do
      calculator = described_class.new(premium_strategy)
      expect(calculator.calculate(100)).to eq(150)
    end
  end

  describe '#set_strategy' do
    let(:calculator) { described_class.new(standard_strategy) }

    it '割引戦略に切り替えると割引料金で計算する' do
      calculator.set_strategy(discount_strategy)
      expect(calculator.calculate(100)).to eq(80)
    end

    it 'プレミアム戦略に切り替えるとプレミアム料金で計算する' do
      calculator.set_strategy(premium_strategy)
      expect(calculator.calculate(100)).to eq(150)
    end
  end
end
