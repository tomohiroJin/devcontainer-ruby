# frozen_string_literal: true

require_relative '../../../lib/reference/patterns/factory'

RSpec.describe Reference::Patterns::NotificationFactory do
  let(:factory) { described_class.new }

  describe '#create_notification' do
    context 'when type is :email' do
      let(:notification) { factory.create_notification(:email, 'Hello via Email') }

      it 'EmailNotification のインスタンスを返す' do
        expect(notification).to be_a(Reference::Patterns::EmailNotification)
      end

      it 'メールメッセージを配信する' do
        expect(notification.deliver).to eq('Delivering Email: Hello via Email')
      end
    end

    context 'when type is :sms' do
      let(:notification) { factory.create_notification(:sms, 'Hello via SMS') }

      it 'SMSNotification のインスタンスを返す' do
        expect(notification).to be_a(Reference::Patterns::SMSNotification)
      end

      it 'SMS メッセージを配信する' do
        expect(notification.deliver).to eq('Delivering SMS: Hello via SMS')
      end
    end

    context 'when type is unknown' do
      it 'ArgumentError を発生させる' do
        expect { factory.create_notification(:unknown, 'Unknown message') }
          .to raise_error(ArgumentError, 'Unknown notification type: unknown')
      end
    end
  end
end
