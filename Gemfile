# frozen_string_literal: true

source 'https://rubygems.org'

ruby file: '.ruby-version'

# 開発環境専用の gem
group :development do
  # Ruby LSP: Shopify が提供する Ruby 用 Language Server
  gem 'ruby-lsp', '~> 0.26', require: false
end

# テスト環境専用の gem
group :test do
  gem 'rspec', '~> 3.13', require: false # テストフレームワーク
end

# 共通で使用する gem
gem 'debug', '~> 1.11', require: false # 標準のデバッガ (Ruby 3.1+ 同梱後継)
gem 'rake', '~> 13.4' # ビルドツール
gem 'rdoc', '~> 8.1' # ドキュメント生成
gem 'rubocop', '~> 1.92', require: false # コード品質チェック
gem 'rubocop-performance', '~> 1.27', require: false # パフォーマンス系ルール
gem 'rubocop-rspec', '~> 3.10', require: false # RSpec 用ルール

# 既知の公開脆弱性を CI とローカルで検査
gem 'bundler-audit', '~> 0.9', require: false
