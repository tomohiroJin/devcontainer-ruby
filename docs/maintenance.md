# 開発環境の保守記録

調査日: 2026-11-05。対象: Issue #10、基点 `8979c3440d972d16772d93227e4aadb38aea39b2`。

## 採用方針と一次情報

| 項目 | 従来 | 採用・理由 | 根拠 |
| --- | --- | --- | --- |
| Ruby | 4.0.3 | 4.0.9。最新安定パッチ。4.1 preview は対象外 | [公式配布](https://www.ruby-lang.org/en/downloads/) |
| Ruby サポート | 未記載 | 4.0 は normal maintenance、終了日は公式に TBD | [公式保守期間](https://www.ruby-lang.org/en/downloads/branches/) |
| OS | Bookworm | Debian 13 Trixie。不要なパッケージの削減と新しいセキュリティ更新基盤のため移行。LTS 終了予定 2030-06-30 | [Debian リリース](https://www.debian.org/releases/) |
| Dev Container | MCR Ruby 4 Bookworm、common-utils/github-cli Features | 公式 ruby:4.0.9-slim-trixie に build-essential/git/sudo/CA と非 root ユーザーのみ追加。不要なグローバル gem/Node/DB ツールを減らす | [公式 Ruby イメージ](https://hub.docker.com/_/ruby) |
| ruby-lsp | 未固定 | 0.26.11 | [RubyGems API](https://rubygems.org/api/v1/gems/ruby-lsp.json) |
| debug | 未固定 | 1.11.1 | [RubyGems](https://rubygems.org/gems/debug) |
| rake | ~>13.0 | 13.4.2 | [RubyGems](https://rubygems.org/gems/rake) |
| rdoc | 未固定 | 8.1.0 | [RubyGems](https://rubygems.org/gems/rdoc) |
| rspec | ~>3.13 | 3.13.2 | [RubyGems](https://rubygems.org/gems/rspec) |
| rubocop | ~>1.86 | 1.92.2 | [RubyGems](https://rubygems.org/gems/rubocop) |
| rubocop-performance | 未固定 | 1.27.0 | [RubyGems](https://rubygems.org/gems/rubocop-performance) |
| rubocop-rspec | 未固定 | 3.10.2 | [RubyGems](https://rubygems.org/gems/rubocop-rspec) |
| bundler-audit | なし | 0.9.3、Ruby Advisory Database で全依存を検査 | [RubyGems](https://rubygems.org/gems/bundler-audit) |
| CI Actions | checkout v4、setup-ruby v1 | checkout v7.0.1、setup-ruby v1、devcontainers/ci v0.3、trivy-action v0.36.0 をコミット SHA 固定 | 各公式 GitHub リポジトリの tag/commit API |

Gemfile の許容範囲とは別に、直接・推移的依存と Bundler はコミットした `Gemfile.lock` で固定する。通常の起動は frozen install、更新担当は `bundle update` 後にテスト・監査・lockfile をまとめてレビューする。Ruby のパッチ更新は `.ruby-version`、Dockerfile のタグ/digest、CI を同時に確認する。週次 Dependabot と CI で追跡し、次回手動見直しは 2026-12-05。

## VS Code 拡張

「デファクトスタンダード」は公式規格ではなく、保守されている提供元と機能の重複を避ける方針として扱う。Marketplace の登録と提供元を調査日に確認した。

- [Shopify Ruby LSP](https://marketplace.visualstudio.com/items?itemName=Shopify.ruby-lsp): 補完・定義ジャンプ・RuboCop の lint/format を統一。Gemfile の RuboCop とプラグインを使う。Solargraph や別の RuboCop 拡張は重ねない。
- [Ruby rdbg Debugger](https://marketplace.visualstudio.com/items?itemName=KoichiSasada.vscode-rdbg): debug gem の開発者による拡張。`.vscode/launch.json` から現在の Ruby/RSpec ファイルをデバッグする。
- [EditorConfig](https://marketplace.visualstudio.com/items?itemName=EditorConfig.EditorConfig): 既存 `.editorconfig` を反映。

Git UI、Live Share、テーマ、日本語表示、Markdown、Excel viewer、Live Server 等は任意の個人設定として扱い、自動インストールから外した。`.vscode/extensions.json` と Dev Container の必須拡張を一致させた。LSP の実行・フォーマットはコンテナ内で動作する。

## 再現と監査

```sh
bash scripts/setup.sh
bundle exec rspec
bundle exec rubocop
bundle exec bundle-audit check --update
```

CI は push/PR/週次/手動で同じ検証を実行する。別ジョブで Dockerfile から最小イメージをビルドし、コンテナ内で依存を frozen install してテスト・gem 監査し、Trivy 0.76.2 で OS/同梱パッケージを検査する。postCreateCommand で作られるワークスペース内の gem はイメージ層に含まれないため、Gemfile.lock 全体の bundler-audit で別途検査する。

Critical/High は未修正版も含め CI を失敗させる。残件は CVE/GHSA・影響・回避策・担当・期限を記録して追跡する。根拠なしの ignore や一律の ignore-unfixed は使わない。

## 実行結果

GUI の補完・定義ジャンプ・ブレークポイント・保存時整形は VS Code での確認が必要であり、CLI テストで成功を代用しない。

### 検証済みの変更

- 旧 MCR/Bookworm イメージの Trivy 結果は OS HIGH/CRITICAL 450 件、同梱 JSON 2.18.0 の Critical 1 件。不要なグローバルツールとパッケージを避けるため、公式 Ruby slim/Trixie に移行した。
- `CVE-2026-33210` は同梱 JSON 2.18.0 が対象。JSON 3.1.0 をインストールし、読み込み元が patched gem 配下であることを確認した後に、旧 default JSON の Ruby ファイル・ネイティブ実装・gemspec を除去した。別プロセスで日本語を含む JSON の parse/generate と版を検査する。監査除外は追加していない。
- `scripts/setup.sh` をクリーンな Trixie コンテナ内の非 root ユーザーから実行し、38 gems の frozen install、RSpec **67 examples / 0 failures**、RuboCop **26 files / no offenses** が成功した。
- bundler-audit **0.9.3**、ruby-advisory-db **516ea4757d5eec778c49af8371c23309c4b70f42**（更新 2026-11-04）で、直接・推移的依存の公開脆弱性は **0 件**。[JSON 結果](gem-audit.json)。
- Dev Container CLI **0.90.0** で構成の読み取りを確認した。実イメージのビルドは Docker **29.9.2** で実施した。管理環境の TLS proxy CA は build secret / read-only mount で渡し、証明書検証を有効にしたまま検証した。

- 最終イメージの Trivy 0.76.2: **Critical 0 / High 75**（37 CVE、修正版の提供なし）。[全指摘とイメージ ID](container-audit.json)、[担当・期限・追跡](security-follow-up.md)。脆弱性対応を完了と判断できる状態ではない。CI は指摘を無視せず失敗させる。
