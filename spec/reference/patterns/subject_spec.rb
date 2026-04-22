# frozen_string_literal: true

require 'reference/patterns/observer'

RSpec.describe Reference::Patterns::Subject do
  subject(:publisher) { described_class.new }

  let(:first_observer)  { Reference::Patterns::ConcreteObserver.new('Observer 1') }
  let(:second_observer) { Reference::Patterns::ConcreteObserver.new('Observer 2') }

  describe '観察者の登録と通知' do
    before do
      publisher.add_observer(first_observer)
      publisher.add_observer(second_observer)
    end

    it '登録済みのすべての観察者に状態変更を通知する' do
      expect { publisher.state = 'Test State' }.to output(
        "Observer 1: State has been updated to 'Test State'\n" \
        "Observer 2: State has been updated to 'Test State'\n"
      ).to_stdout
    end
  end

  describe '観察者の削除' do
    before do
      publisher.add_observer(first_observer)
      publisher.add_observer(second_observer)
      publisher.remove_observer(first_observer)
    end

    it '削除された観察者には通知されない' do
      expect { publisher.state = 'Another State' }
        .to output("Observer 2: State has been updated to 'Another State'\n").to_stdout
    end
  end
end
