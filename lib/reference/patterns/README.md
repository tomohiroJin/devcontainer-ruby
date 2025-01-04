# デザインパターン

このプロジェクトでは、Ruby を使った 5 種類の基本的なデザインパターンの実装例を提供しています。各デザインパターンの概要、使用例、および詳細な RDoc ドキュメントへのリンクを以下に示します。

---

## **デザインパターン一覧**

| パターン名            | 概要                                                                 | 使用例                             |
|-----------------------|----------------------------------------------------------------------|------------------------------------|
| Strategy パターン     | アルゴリズムを動的に切り替えるデザインパターン。                          | 認証ロジック、支払い処理の切り替え     |
| Observer パターン     | オブジェクト間の依存関係を管理し、状態変更時に通知を送る。                  | イベント通知、リアルタイム監視         |
| Decorator パターン    | オブジェクトに動的に振る舞いを追加するデザインパターン。                    | メッセージの装飾、動的な属性の追加     |
| Factory パターン      | オブジェクト生成のロジックをカプセル化するデザインパターン。                 | API クライアント、通知オブジェクトの生成 |
| Template Method パターン | アルゴリズムの骨格を定義し、具体的な処理をサブクラスに委譲するデザインパターン。 | データ処理の共通化、バッチ処理         |

---

## **各パターンの概要と使用例**

### **1. Strategy パターン**

**概要:**  
アルゴリズムを動的に切り替えることで、柔軟性の高い設計を実現します。

**使用例:**  
料金計算アルゴリズムの切り替え (`Standard`, `Discount`, `Premium`)

```ruby
factory = Reference::Patterns::PriceCalculator.new(Reference::Patterns::StandardStrategy.new)
puts factory.calculate(100) # => 100
factory.set_strategy(Reference::Patterns::DiscountStrategy.new)
puts factory.calculate(100) # => 80
```

---

### **2. Observer パターン**

**概要:**  
オブジェクト間の依存関係を管理し、状態変更時に通知を送ります。

**使用例:**  
状態変更の通知 (`Subject`, `Observer`)

```ruby
subject = Reference::Patterns::Subject.new
observer = Reference::Patterns::ConcreteObserver.new('Observer 1')
subject.add_observer(observer)
subject.state = 'Updated State' # Observer 1: State has been updated to 'Updated State'
```

---

### **3. Decorator パターン**

**概要:**  
オブジェクトの振る舞いを動的に変更します。

**使用例:**  
メッセージのプレフィックスとサフィックスを追加

```ruby
message = Reference::Patterns::SimpleMessage.new('Hello, World!')
decorated_message = Reference::Patterns::PrefixDecorator.new(message, '>>> ')
decorated_message = Reference::Patterns::SuffixDecorator.new(decorated_message, ' <<<')
puts decorated_message.content # => >>> Hello, World! <<<
```

---

### **4. Factory パターン**

**概要:**  
オブジェクト生成のロジックをカプセル化します。

**使用例:**  
通知オブジェクト (`Email`, `SMS`) の生成

```ruby
factory = Reference::Patterns::NotificationFactory.new
email = factory.create_notification(:email, 'Hello via Email')
puts email.deliver # => Delivering Email: Hello via Email
```

---

### **5. Template Method パターン**

**概要:**  
アルゴリズムの骨格を定義し、具体的な処理をサブクラスに委譲します。

**使用例:**  
CSV および JSON のデータ処理

```ruby
processor = Reference::Patterns::CSVProcessor.new
processor.process(['Name, Age', 'Alice, 30', 'Bob, 25']) # CSV processing completed

processor = Reference::Patterns::JSONProcessor.new
processor.process(['Name, Age', 'Alice, 30', 'Bob, 25']) # JSON processing completed
```