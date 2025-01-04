# frozen_string_literal: true

require_relative '../../../lib/reference/patterns/factory'

RSpec.describe Reference::Patterns::NotificationFactory do
  let(:factory) { Reference::Patterns::NotificationFactory.new }

  describe '#create_notification' do
    it 'メール通知を生成する' do
      notification = factory.create_notification(:email, 'Hello via Email')
      expect(notification).to be_a(Reference::Patterns::EmailNotification)
      expect(notification.deliver).to eq('Delivering Email: Hello via Email')
    end

    it 'SMS 通知を生成する' do
      notification = factory.create_notification(:sms, 'Hello via SMS')
      expect(notification).to be_a(Reference::Patterns::SMSNotification)
      expect(notification.deliver).to eq('Delivering SMS: Hello via SMS')
    end

    it '無効な通知タイプを処理する' do
      expect do
        factory.create_notification(:unknown,
                                    'Unknown message')
      end.to raise_error(ArgumentError, 'Unknown notification type: unknown')
    end
  end
end
