# frozen_string_literal: true

# Reference:Basic:ControlFlow クラスは、Ruby の制御構文を学ぶためのクラスです。
#
# 主な内容:
# - if-else の例
# - case 文の例
# - 三項演算子の例
#
# 使用例:
#   control_flow = Reference::ControlFlow.new
#   puts control_flow.check_number(10) # => "positive"
#   puts control_flow.day_of_week("Monday") # => "Start of the work week"
#   puts control_flow.is_even(4) # => "Even"
module Reference
  # Ruby の基本構文を学ぶためのモジュール
  module Basic
    # Ruby の制御構文を学ぶためのクラス
    class ControlFlow
      # if-else の例: 数値を受け取り、その符号を判定します。
      #
      # @param number [Numeric] 判定対象の数値
      # @return [String] "positive" (正の数), "negative" (負の数), "zero" (ゼロ)
      #
      # 使用例:
      #   control_flow = Reference::ControlFlow.new
      #   puts control_flow.check_number(10) # => "positive"
      def check_number(number)
        if number.positive?
          'positive'
        elsif number.negative?
          'negative'
        else
          'zero'
        end
      end

      # case 文の例: 曜日に応じたメッセージを返します。
      #
      # @param day [String] 曜日を表す文字列 ("Monday", "Saturday", など)
      # @return [String] 曜日に応じたメッセージ
      #
      # 使用例:
      #   control_flow = Reference::ControlFlow.new
      #   puts control_flow.day_of_week("Monday") # => "Start of the work week"
      def day_of_week(day)
        case day
        when 'Monday'
          'Start of the work week'
        when 'Saturday', 'Sunday'
          'Weekend'
        else
          'Midweek'
        end
      end

      # 三項演算子の例: 偶数か奇数かを判定します。
      #
      # @param number [Integer] 判定対象の数値
      # @return [String] "Even" (偶数), "Odd" (奇数)
      #
      # 使用例:
      #   control_flow = Reference::ControlFlow.new
      #   puts control_flow.is_even(4) # => "Even"
      #   puts control_flow.is_even(3) # => "Odd"
      def is_even(number) # rubocop:disable Naming/PredicateName
        number.even? ? 'Even' : 'Odd'
      end
    end
  end
end
