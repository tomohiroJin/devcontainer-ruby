# frozen_string_literal: true

# Reference::Shape は抽象クラスとして機能します。
# インターフェースとして、`area` メソッドを定義しています。
module Reference
  # 抽象クラス的な役割 (Ruby は正式な抽象クラスをサポートしていない)
  class Shape
    def initialize(name)
      raise NotImplementedError, 'Shape クラスは直接インスタンス化できません' if instance_of?(Shape)

      @name = name
    end

    # 抽象メソッド (サブクラスで必ず定義する必要がある)
    def area
      raise NotImplementedError, 'サブクラスで area を定義してください'
    end

    # オーバライドの例 (サブクラスで再定義可能)
    def description
      "Shape: #{@name}"
    end
  end

  # Circle クラスは Shape を継承します
  class Circle < Shape
    def initialize(radius)
      super('Circle')
      @radius = radius
    end

    # area メソッドをオーバライド
    def area
      Math::PI * @radius**2
    end

    # description メソッドをオーバライド
    def description
      "Circle with radius #{@radius}"
    end
  end

  # Rectangle クラスは Shape を継承します
  class Rectangle < Shape
    def initialize(width, height)
      super('Rectangle')
      @width = width
      @height = height
    end

    # area メソッドをオーバライド
    def area
      @width * @height
    end
  end

  # OverloadDemo クラスはオーバーロードを模倣します
  class OverloadDemo
    # オーバーロードを模倣するメソッド (引数の数で処理を分岐)
    def calculate(*args)
      case args.size
      when 1
        "Square area: #{args[0]**2}"
      when 2
        "Rectangle area: #{args[0] * args[1]}"
      else
        'Invalid arguments'
      end
    end
  end
end
