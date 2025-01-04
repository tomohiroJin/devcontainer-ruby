# frozen_string_literal: true

# Template Method パターンは、アルゴリズムの骨格を定義し、具体的な処理をサブクラスに委譲するデザインパターンです。
#
# この例では、データ処理のテンプレートを定義し、異なる形式で出力を実装しています。
#
# 使用例:
#   processor = Reference::Patterns::CSVProcessor.new
#   processor.process(["Name, Age", "Alice, 30", "Bob, 25"])
#   # => CSV processing completed
#
#   processor = Reference::Patterns::JSONProcessor.new
#   processor.process(["Name, Age", "Alice, 30", "Bob, 25"])
#   # => JSON processing completed
module Reference
  module Patterns
    # DataProcessor クラスはデータ処理のテンプレートを提供します。
    #
    # 具体的な処理の一部はサブクラスで実装します。
    class DataProcessor
      # データを処理するテンプレートメソッド
      #
      # @param data [Array<String>] 処理対象のデータ
      def process(data)
        read_data(data)
        transform_data
        write_data
      end

      private

      # データを読み取る
      #
      # @param data [Array<String>] 読み取るデータ
      def read_data(data)
        @raw_data = data
        puts "Reading data: #{@raw_data}"
      end

      # データを変換する (サブクラスで実装)
      def transform_data
        raise NotImplementedError, 'サブクラスで transform_data メソッドを実装してください'
      end

      # データを書き出す (サブクラスで実装)
      def write_data
        raise NotImplementedError, 'サブクラスで write_data メソッドを実装してください'
      end
    end

    # CSVProcessor クラスは CSV 形式でデータを処理します。
    class CSVProcessor < DataProcessor
      private

      def transform_data
        @processed_data = @raw_data.map { |line| line.split(',').map(&:strip) }
        puts "Transformed data into CSV format: #{@processed_data}"
      end

      def write_data
        puts 'CSV processing completed'
      end
    end

    # JSONProcessor クラスは JSON 形式でデータを処理します。
    class JSONProcessor < DataProcessor
      require 'json'

      private

      def transform_data
        headers, *rows = @raw_data.map { |line| line.split(',').map(&:strip) }
        @processed_data = rows.map { |row| headers.zip(row).to_h }
        puts "Transformed data into JSON format: #{@processed_data.to_json}"
      end

      def write_data
        puts 'JSON processing completed'
      end
    end
  end
end
