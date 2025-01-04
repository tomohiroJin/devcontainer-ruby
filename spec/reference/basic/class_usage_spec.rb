# frozen_string_literal: true

require 'reference/basic/class_usage'

RSpec.describe Reference::Shape do
  describe '抽象クラスの動作' do
    it 'Shape クラスのインスタンス化はできない' do
      expect { Reference::Shape.new('Shape') }.to raise_error(NotImplementedError)
    end

    it 'area メソッドはサブクラスで定義する必要がある' do
      expect { Reference::Shape.new('Shape').area }.to raise_error(NotImplementedError)
    end
  end

  describe Reference::Circle do
    let(:circle) { Reference::Circle.new(10) }

    it 'Circle の面積を計算する' do
      expect(circle.area).to be_within(0.01).of(314.16) # 面積 πr^2
    end

    it 'description メソッドをオーバライドする' do
      expect(circle.description).to eq('Circle with radius 10')
    end
  end

  describe Reference::Rectangle do
    let(:rectangle) { Reference::Rectangle.new(5, 10) }

    it 'Rectangle の面積を計算する' do
      expect(rectangle.area).to eq(50) # 面積 幅×高さ
    end

    it 'description メソッドは親クラスのものを使用する' do
      expect(rectangle.description).to eq('Shape: Rectangle')
    end
  end

  describe Reference::OverloadDemo do
    let(:overload_demo) { Reference::OverloadDemo.new }

    it '1 つの引数で正方形の面積を計算する' do
      expect(overload_demo.calculate(4)).to eq('Square area: 16')
    end

    it '2 つの引数で長方形の面積を計算する' do
      expect(overload_demo.calculate(5, 10)).to eq('Rectangle area: 50')
    end

    it '無効な引数の場合はエラーメッセージを返す' do
      expect(overload_demo.calculate(1, 2, 3)).to eq('Invalid arguments')
    end
  end
end
