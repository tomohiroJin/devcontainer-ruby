source 'https://rubygems.org'

# 開発環境専用の gem
group :development do
  # Solargraph: Ruby Language Server
  gem 'ruby-lsp'
  gem 'solargraph', '~> 0.50.0'
end

# テスト環境専用の gem
group :test do
  gem 'rspec', '~> 3.13.0', require: false # テストフレームワーク
end

# 共通で使用する gem
gem 'byebug'                            # デバッグツール
gem 'rake', '~> 13.0'                   # ビルドツール
gem 'rdoc'                              # ドキュメント生成
gem 'rubocop', '~> 1.0', require: false # コード品質チェック
gem 'rubocop-performance', require: false # パフォーマンスチェック
