source "https://rubygems.org"

# 開発環境専用の gem
group :development do
  # Solargraph: Ruby Language Server
  gem 'solargraph', '~> 0.50.0'
  gem 'ruby-lsp'
end

# テスト環境専用の gem
group :test do
  gem 'rspec', '~> 3.13.0', require: false # テストフレームワーク
end

# 共通で使用する gem
gem "rubocop", "~> 1.0", require: false # コード品質チェック
gem 'rubocop-performance', require: false
gem "rake", "~> 13.0"                   # ビルドツール
gem "byebug"                            # デバッグツール
