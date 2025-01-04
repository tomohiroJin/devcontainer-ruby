# frozen_string_literal: true

# Observer パターンは、オブジェクト間の依存関係を管理し、あるオブジェクトの状態変更を他のオブジェクトに通知します。
#
# この例では、`Subject` が状態を変更し、登録されたすべての `Observer` に通知を送る仕組みを示しています。
#
# 使用例:
#   subject = Reference::Patterns::Subject.new
#   observer1 = Reference::Patterns::ConcreteObserver.new('Observer 1')
#   observer2 = Reference::Patterns::ConcreteObserver.new('Observer 2')
#   subject.add_observer(observer1)
#   subject.add_observer(observer2)
#   subject.state = 'New State'
#   # => Observer 1: State has been updated to 'New State'
#   # => Observer 2: State has been updated to 'New State'
module Reference
  module Patterns
    # Observer インターフェース
    #
    # すべての観察者が実装するべきメソッドを定義します。
    class Observer
      # 状態が更新された際に呼び出されるメソッド
      #
      # @param subject [Subject] 状態を持つ Subject オブジェクト
      def update(subject)
        raise NotImplementedError, 'サブクラスで update メソッドを実装してください'
      end
    end

    # Subject クラスは、状態を持ち、それを観察するオブジェクトを管理します。
    class Subject
      attr_reader :state

      def initialize
        @observers = []
        @state = nil
      end

      # 状態を更新し、すべての観察者に通知します。
      #
      # @param new_state [String] 新しい状態
      def state=(new_state)
        @state = new_state
        notify_observers
      end

      # 観察者を登録します。
      #
      # @param observer [Observer] 登録する観察者
      def add_observer(observer)
        @observers << observer
      end

      # 観察者を削除します。
      #
      # @param observer [Observer] 削除する観察者
      def remove_observer(observer)
        @observers.delete(observer)
      end

      private

      # すべての観察者に通知を送ります。
      def notify_observers
        @observers.each { |observer| observer.update(self) }
      end
    end

    # ConcreteObserver は Observer インターフェースを実装した具体的な観察者クラスです。
    class ConcreteObserver < Observer
      def initialize(name) # rubocop:disable Lint/MissingSuper
        @name = name
      end

      # 状態が更新された際に呼び出されます。
      #
      # @param subject [Subject] 状態を持つ Subject オブジェクト
      def update(subject)
        puts "#{@name}: State has been updated to '#{subject.state}'"
      end
    end
  end
end
