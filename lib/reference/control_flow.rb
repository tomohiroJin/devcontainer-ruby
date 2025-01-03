# frozen_string_literal: true

# Reference::ControlFlow クラスは、Ruby の制御構文を学ぶためのクラスです。
# このクラスには以下の機能があります:
# - if-else の例
# - case 文の例
# - 三項演算子の例
#
# 使用例:
#  control_flow = Reference::ControlFlow.new
#  puts control_flow.check_number(10)
#
module Reference
  class ControlFlow
    # if-else の例: 数値を受け取り、その符号を判定する
    # - number > 0: 正の数 ("positive")
    # - number < 0: 負の数 ("negative")
    # - number == 0: ゼロ ("zero")
    def check_number(number)
      if number.positive?
        'positive'
      elsif number.negative?
        'negative'
      else
        'zero'
      end
    end

    # case 文の例: 曜日に応じたメッセージを返す
    # - Monday: "Start of the work week"
    # - Saturday, Sunday: "Weekend"
    # - その他: "Midweek"
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

    # 三項演算子の例: 偶数か奇数かを判定
    # - 偶数: "Even"
    # - 奇数: "Odd"
    # 三項演算子 (condition ? true_value : false_value) を利用
    def is_even(number) # rubocop:disable Naming/PredicateName
      number.even? ? 'Even' : 'Odd'
    end
  end
end
