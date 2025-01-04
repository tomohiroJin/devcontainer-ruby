# frozen_string_literal: true

# Factory パターンは、オブジェクト生成のロジックをカプセル化するデザインパターンです。
#
# この例では、異なる種類の通知オブジェクトを動的に生成する仕組みを示しています。
# - EmailNotification: メール通知
# - SMSNotification: SMS 通知
#
# 使用例:
#   factory = Reference::Patterns::NotificationFactory.new
#   email = factory.create_notification(:email, "Hello via Email")
#   puts email.deliver
#   # => Delivering Email: Hello via Email
#
#   sms = factory.create_notification(:sms, "Hello via SMS")
#   puts sms.deliver
#   # => Delivering SMS: Hello via SMS
module Reference
  module Patterns
    # Notification インターフェース
    #
    # すべての通知クラスが実装するべきメソッドを定義します。
    class Notification
      # 通知を配信します。
      #
      # @return [String] 配信結果
      def deliver
        raise NotImplementedError, 'サブクラスで deliver メソッドを実装してください'
      end
    end

    # EmailNotification クラスはメール通知を表します。
    class EmailNotification < Notification
      def initialize(message) # rubocop:disable Lint/MissingSuper
        @message = message
      end

      # メールを配信します。
      #
      # @return [String] 配信結果
      def deliver
        "Delivering Email: #{@message}"
      end
    end

    # SMSNotification クラスは SMS 通知を表します。
    class SMSNotification < Notification
      def initialize(message) # rubocop:disable Lint/MissingSuper
        @message = message
      end

      # SMS を配信します。
      #
      # @return [String] 配信結果
      def deliver
        "Delivering SMS: #{@message}"
      end
    end

    # NotificationFactory クラスは通知オブジェクトを生成する工場クラスです。
    class NotificationFactory
      # 指定された種類の通知オブジェクトを生成します。
      #
      # @param type [Symbol] 通知の種類 (:email, :sms)
      # @param message [String] 通知メッセージ
      # @return [Notification] 生成された通知オブジェクト
      # @raise [ArgumentError] 無効な種類が指定された場合
      def create_notification(type, message)
        case type
        when :email
          EmailNotification.new(message)
        when :sms
          SMSNotification.new(message)
        else
          raise ArgumentError, "Unknown notification type: #{type}"
        end
      end
    end
  end
end
