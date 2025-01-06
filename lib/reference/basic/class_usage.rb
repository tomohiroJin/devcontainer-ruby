# frozen_string_literal: true

# Reference:Basic:Shape モジュールは、図形に関連するクラス群を提供します。
#
# 主な内容:
# - Shape: 抽象クラス
# - Circle: 円クラス
# - Rectangle: 長方形クラス
# - OverloadDemo: オーバーロードを模倣するクラス
module Reference
  # Ruby の基本構文を学ぶためのモジュール
  module Basic
    # 抽象クラス的な役割を持つ Shape クラス
    #
    # このクラスは直接インスタンス化できません。継承して使用します。
    #
    # サブクラスでの実装が必要なメソッド:
    # - area
    #
    # 使用例:
    #   circle = Reference::Circle.new(10)
    #   puts circle.area
    #   puts circle.description
    class Shape
      # 初期化
      #
      # @param name [String] 図形の名前
      # @raise [NotImplementedError] 直接インスタンス化された場合に発生
      def initialize(name)
        raise NotImplementedError, 'Shape クラスは直接インスタンス化できません' if instance_of?(Shape)

        @name = name
      end

      # 抽象メソッド: 図形の面積を計算する
      #
      # サブクラスで必ずオーバーライドする必要があります。
      #
      # @raise [NotImplementedError] サブクラスで未実装の場合に発生
      def area
        raise NotImplementedError, 'サブクラスで area を定義してください'
      end

      # 図形の説明を返す
      #
      # サブクラスでオーバーライド可能です。
      #
      # @return [String] 図形の説明
      def description
        "Shape: #{@name}"
      end
    end

    # Circle クラスは Shape を継承した円を表すクラス
    #
    # 使用例:
    #   circle = Reference::Circle.new(5)
    #   puts circle.area # => 78.54 (おおよその値)
    #   puts circle.description # => "Circle with radius 5"
    class Circle < Shape
      # 初期化
      #
      # @param radius [Numeric] 半径
      def initialize(radius)
        super('Circle')
        @radius = radius
      end

      # 面積を計算する
      #
      # @return [Float] 円の面積
      def area
        Math::PI * (@radius**2)
      end

      # 図形の説明を返す (オーバーライド)
      #
      # @return [String] 図形の説明
      def description
        "Circle with radius #{@radius}"
      end
    end

    # Rectangle クラスは Shape を継承した長方形を表すクラス
    #
    # 使用例:
    #   rectangle = Reference::Rectangle.new(4, 5)
    #   puts rectangle.area # => 20
    #   puts rectangle.description # => "Shape: Rectangle"
    class Rectangle < Shape
      # 初期化
      #
      # @param width [Numeric] 幅
      # @param height [Numeric] 高さ
      def initialize(width, height)
        super('Rectangle')
        @width = width
        @height = height
      end

      # 面積を計算する
      #
      # @return [Numeric] 長方形の面積
      def area
        @width * @height
      end
    end

    # OverloadDemo クラスはオーバーロードの概念を模倣するクラス
    #
    # 使用例:
    #   demo = Reference::OverloadDemo.new
    #   puts demo.calculate(4) # => "Square area: 16"
    #   puts demo.calculate(3, 5) # => "Rectangle area: 15"
    class OverloadDemo
      # 引数に応じて異なる処理を実行する
      #
      # - 1 引数: 正方形の面積を計算
      # - 2 引数: 長方形の面積を計算
      # - それ以外: 無効な引数のエラーメッセージを返す
      #
      # @param args [Array<Numeric>] 1 または 2 の数値引数
      # @return [String] 計算結果またはエラーメッセージ
      #
      # 使用例:
      #   demo.calculate(4) # => "Square area: 16"
      #   demo.calculate(3, 5) # => "Rectangle area: 15"
      #   demo.calculate(1, 2, 3) # => "Invalid arguments"
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
end
