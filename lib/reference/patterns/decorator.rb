# frozen_string_literal: true

# Decorator パターンは、オブジェクトに動的に振る舞いを追加するデザインパターンです。
#
# この例では、メッセージを装飾する仕組みを示しています。
# - 元のメッセージにプレフィックスを追加する装飾
# - 元のメッセージにサフィックスを追加する装飾
#
# 使用例:
#   message = Reference::Patterns::SimpleMessage.new("Hello, World!")
#   decorated_message = Reference::Patterns::PrefixDecorator.new(message, ">>> ")
#   decorated_message = Reference::Patterns::SuffixDecorator.new(decorated_message, " <<<")
#   puts decorated_message.content
#   # => >>> Hello, World! <<<
module Reference
  module Patterns
    # メッセージのインターフェース
    #
    # すべてのメッセージクラスが実装するべきメソッドを定義します。
    class Message
      # メッセージの内容を取得します。
      #
      # @return [String] メッセージの内容
      def content
        raise NotImplementedError, 'サブクラスで content メソッドを実装してください'
      end
    end

    # シンプルなメッセージを表すクラス
    class SimpleMessage < Message
      def initialize(text) # rubocop:disable Lint/MissingSuper
        @text = text
      end

      # メッセージの内容を返します。
      #
      # @return [String] メッセージの内容
      def content
        @text
      end
    end

    # Decorator クラスはメッセージの振る舞いを拡張します。
    #
    # このクラス自体は抽象クラスとして機能します。
    class Decorator < Message
      def initialize(message) # rubocop:disable Lint/MissingSuper
        @message = message
      end

      # デコレートされたメッセージの内容を取得します。
      #
      # @return [String] メッセージの内容
      def content
        @message.content
      end
    end

    # プレフィックスを追加する装飾クラス
    class PrefixDecorator < Decorator
      def initialize(message, prefix)
        super(message)
        @prefix = prefix
      end

      # プレフィックスを付与したメッセージを返します。
      #
      # @return [String] プレフィックス付きのメッセージ
      def content
        "#{@prefix}#{@message.content}"
      end
    end

    # サフィックスを追加する装飾クラス
    class SuffixDecorator < Decorator
      def initialize(message, suffix)
        super(message)
        @suffix = suffix
      end

      # サフィックスを付与したメッセージを返します。
      #
      # @return [String] サフィックス付きのメッセージ
      def content
        "#{@message.content}#{@suffix}"
      end
    end
  end
end
