# frozen_string_literal: true

source 'https://rubygems.org'

# 開発環境専用の gem
group :development do
  # Ruby LSP: Shopify が提供する Ruby 用 Language Server
  gem 'ruby-lsp', require: false
end

# テスト環境専用の gem
group :test do
  gem 'rspec', '~> 3.13', require: false # テストフレームワーク
end

# 共通で使用する gem
gem 'debug', require: false                  # 標準のデバッガ (Ruby 3.1+ 同梱後継)
gem 'rake', '~> 13.0'                        # ビルドツール
gem 'rdoc'                                   # ドキュメント生成
gem 'rubocop', '~> 1.86', require: false     # コード品質チェック
gem 'rubocop-performance', require: false    # パフォーマンス系ルール
gem 'rubocop-rspec', require: false          # RSpec 用ルール
