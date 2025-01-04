# frozen_string_literal: true

require 'reference/basic/control_flow'

RSpec.describe Reference::ControlFlow do
  let(:control_flow) { Reference::ControlFlow.new }

  # if-else 文のテスト
  describe '#check_number' do
    it '正の数を判定する' do
      expect(control_flow.check_number(10)).to eq('positive') # 正の数のケース
    end

    it '負の数を判定する' do
      expect(control_flow.check_number(-5)).to eq('negative') # 負の数のケース
    end

    it 'ゼロを判定する' do
      expect(control_flow.check_number(0)).to eq('zero') # ゼロのケース
    end
  end

  # case 文のテスト
  describe '#day_of_week' do
    it '月曜日を判定する' do
      expect(control_flow.day_of_week('Monday')).to eq('Start of the work week') # 月曜日のケース
    end

    it '週末を判定する（土曜日）' do
      expect(control_flow.day_of_week('Saturday')).to eq('Weekend') # 土曜日のケース
    end

    it '週末を判定する（日曜日）' do
      expect(control_flow.day_of_week('Sunday')).to eq('Weekend') # 日曜日のケース
    end

    it '平日を判定する（火曜日）' do
      expect(control_flow.day_of_week('Tuesday')).to eq('Midweek') # 平日のケース
    end
  end

  # 三項演算子のテスト
  describe '#is_even?' do
    it '偶数を判定する' do
      expect(control_flow.is_even(4)).to eq('Even') # 偶数のケース
    end

    it '奇数を判定する' do
      expect(control_flow.is_even(7)).to eq('Odd') # 奇数のケース
    end
  end
end
