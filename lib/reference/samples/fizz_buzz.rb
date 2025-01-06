# frozen_string_literal: true

# Reference::Samples::FizzBuzz クラスは、FizzBuzz のロジックを提供するクラスです。
module Reference
  # サンプルのクラスを格納するモジュール
  module Samples
    # FizzBuzz のロジックを提供するクラス
    class FizzBuzz
      # FizzBuzz のロジックを実行します。
      def fizz_buzz(num)
        return 'FizzBuzz' if (num % 15).zero?
        return 'Fizz' if (num % 3).zero?
        return 'Buzz' if (num % 5).zero?

        num.to_s
      end
    end
  end
end
