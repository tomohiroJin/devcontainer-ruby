# frozen_string_literal: true

require 'reference/patterns/observer'

RSpec.describe Reference::Patterns::Subject do
  let(:subject) { Reference::Patterns::Subject.new }
  let(:observer1) { Reference::Patterns::ConcreteObserver.new('Observer 1') }
  let(:observer2) { Reference::Patterns::ConcreteObserver.new('Observer 2') }

  describe '観察者の登録と通知' do
    it '観察者を登録して通知を送る' do
      expect { subject.add_observer(observer1) }.not_to raise_error
      expect { subject.add_observer(observer2) }.not_to raise_error

      expect do
        subject.state = 'Test State'
      end.to output("Observer 1: State has been updated to 'Test State'\n" \
                    "Observer 2: State has been updated to 'Test State'\n").to_stdout
    end

    it '観察者を削除して通知を送らない' do
      subject.add_observer(observer1)
      subject.add_observer(observer2)
      subject.remove_observer(observer1)

      expect do
        subject.state = 'Another State'
      end.to output("Observer 2: State has been updated to 'Another State'\n").to_stdout
    end
  end
end
