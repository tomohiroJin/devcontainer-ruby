# 開発環境の保守記録

調査日: 2026-11-05（初回）、2026-11-20（再確認・Ruby セキュリティ更新）。対象: Issue #10、基点 `8979c3440d972d16772d93227e4aadb38aea39b2`。

## 採用方針と一次情報

| 項目 | 従来 | 採用・理由 | 根拠 |
| --- | --- | --- | --- |
| Ruby | 4.0.3 | 4.0.10（11-05 時点は 4.0.9）。2026-11-18 公開の Regexp/String 脆弱性 7 件（一部 RCE の PoC あり）の修正版。4.1 は preview のため対象外 | [4.0.10 リリース](https://www.ruby-lang.org/en/news/2026/11/18/ruby-4-0-10-released/)、[セキュリティ告知](https://www.ruby-lang.org/en/news/2026/11/18/multiple-vulnerabilities-in-regexp-and-string/) |
| Ruby サポート | 未記載 | 4.0 は normal maintenance、終了日は公式に TBD | [公式保守期間](https://www.ruby-lang.org/en/downloads/branches/) |
| OS | Bookworm | Debian 13 Trixie。不要なパッケージの削減と新しいセキュリティ更新基盤のため移行。LTS 終了予定 2030-06-30 | [Debian リリース](https://www.debian.org/releases/) |
| Dev Container | MCR Ruby 4 Bookworm、common-utils/github-cli Features | 公式 ruby:4.0.10-slim-trixie（index digest `sha256:a4b3e62b…`）に build-essential/git/sudo/CA と非 root ユーザーのみ追加。不要なグローバル gem/Node/DB ツールを減らす | [公式 Ruby イメージ](https://hub.docker.com/_/ruby) |
| ruby-lsp | 未固定 | 0.26.11 | [RubyGems API](https://rubygems.org/api/v1/gems/ruby-lsp.json) |
| debug | 未固定 | 1.11.1 | [RubyGems](https://rubygems.org/gems/debug) |
| rake | ~>13.0 | 13.4.2 | [RubyGems](https://rubygems.org/gems/rake) |
| rdoc | 未固定 | 8.1.0 | [RubyGems](https://rubygems.org/gems/rdoc) |
| rspec | ~>3.13 | 3.13.2（rspec-core 3.13.7 等） | [RubyGems](https://rubygems.org/gems/rspec) |
| rubocop | ~>1.86 | 1.92.3 | [RubyGems](https://rubygems.org/gems/rubocop) |
| rubocop-performance | 未固定 | 1.27.0 | [RubyGems](https://rubygems.org/gems/rubocop-performance) |
| rubocop-rspec | 未固定 | 3.10.2 | [RubyGems](https://rubygems.org/gems/rubocop-rspec) |
| Bundler | 4.0.x（イメージ同梱 4.0.20） | 4.1.0（2026-11-16 安定版、Ruby >= 3.2 対応）。Dockerfile と `BUNDLED WITH` を一致させる | [RubyGems](https://rubygems.org/gems/bundler/versions/4.1.0) |
| bundler-audit | なし | 0.9.3、Ruby Advisory Database で全依存を検査 | [RubyGems](https://rubygems.org/gems/bundler-audit) |
| CI Actions | checkout v4、setup-ruby v1 | checkout v7.0.1、setup-ruby v1.343.0（Ruby 4.0.10 対応版）、setup-go v7.1.0（actionlint 用 Go 1.25.x）、upload-artifact v7.0.2、devcontainers/ci v0.3、trivy-action v0.36.0 をコミット SHA 固定 | 各公式 GitHub リポジトリの tag/commit API |

Gemfile の許容範囲とは別に、直接・推移的依存と Bundler はコミットした `Gemfile.lock` で固定する。通常の起動は frozen install、更新担当は `bundle update` 後にテスト・監査・lockfile をまとめてレビューする。Ruby のパッチ更新は `.ruby-version`、Dockerfile のタグ/digest、CI を同時に確認する。週次 Dependabot と CI で追跡し、次回手動見直しは 2026-12-05。

2026-11-20 時点で更新しなかった推移的依存: `diff-lcs` 2.0.0（rspec-expectations/mocks 3.13 系が `< 2.0` を要求）、`prism` 2.x（ruby-lsp 0.26.11 が `< 2.0` を要求）。上流の制約が外れた時点で Dependabot により更新する。

**Ruby のパッチ更新は手動で同期する。** Dependabot（docker）は Dockerfile の `FROM` のタグ/digest だけを上げ、`.ruby-version` と `Gemfile.lock` の `RUBY VERSION` は追随しない。そのため Ruby のパッチ版が変わる Dependabot PR は、`scripts/setup.sh` の版照合で必ず CI が失敗する（意図した停止）。その PR の上で次の作業を同時に行い、CI と監査ゲートを通してからマージする。

1. `.ruby-version` を新しい版に更新する。
2. 新しい Ruby のコンテナで `bundle config set --local frozen false` を実行してから `bundle update --ruby` を実行し、`Gemfile.lock` の `RUBY VERSION` を更新する。終わったら `bundle config set --local frozen true` で frozen に戻す（`bundle lock --update --ruby` は Bundler 4.1.0 では `Unknown switches` になる）。
3. setup-ruby の固定 SHA が新しい版に対応しているか確認する。
4. 同梱 JSON の版と、置き換えの要否を確認する。

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
bundle exec ruby scripts/test_editor_features.rb
bundle exec bundle-audit check --update
```

`scripts/test_editor_features.rb` は次の 8 項目を検証する。GUI 操作そのものの代替ではない（VS Code 拡張が使う composed bundle `.ruby-lsp/` の経路も通らない）。

- VS Code が使う Ruby LSP を stdio で起動し、`.vscode/settings.json` と同じ formatter/linter 設定で、spec から lib のクラスへの定義ジャンプ、定数補完、RuboCop による整形（保存時整形の実体）と診断を確認する。
- rdbg のブレークポイント停止と変数評価を確認する。
- Ruby LSP 拡張が起動時に行うグローバル gem のインストール（`gem install ruby-lsp --env-shebang`、1 日 1 回の `gem update`）のため、remote user が `GEM_HOME` に書き込めることを確認する。
- `.vscode/launch.json` の 2 構成を、vscode-rdbg と同じコマンドラインで Bundler 環境の外から起動する。

Dockerfile は `GEM_HOME`（`/usr/local/bundle`）を固定 GID 2000 の `rubygems` グループに渡し、remote user をこのグループに加える。root による `gem install` で配下が root 所有になると、Ruby LSP 拡張の `gem install ruby-lsp` が `Gem::FilePermissionError` で失敗するため（2026-11-21 に WSL 上で発生）。VS Code は remote user の UID/GID をホストのユーザーに合わせて書き換える（`updateRemoteUserUID`）。補助グループはそのまま残るので、UID 指定の chown ではなくグループで権限を与えている。UID を 1001 に変えた状態で `gem install`/`gem update` が成功することを確認した。

デバッグ構成は Bundler の binstub `bin/rdbg` を `rdbgPath` に指定する。PATH 上の `rdbg`（イメージ同梱の debug gem）で `bundle exec rspec` を起動すると、default gem と lockfile の版が衝突して起動に失敗するため。

CI は push/PR/週次/手動で同じ検証を実行する。`workflow-lint` ジョブは actionlint 1.7.12 でワークフローを検査する。concurrency グループはイベント種別ごとに分かれ、push・週次・手動の実行が種別をまたいでキャンセルし合うことはない。`cancel-in-progress` は PR のみ有効。同じグループで待機中の run は、新しい run に置き換えられる（GitHub Actions の仕様。main への連続 push では中間の run が実行されないことがある）。別ジョブで Dockerfile から最小イメージをビルドし、コンテナ内で依存を frozen install してテスト・gem 監査し、Trivy 0.76.2 で OS/同梱パッケージを検査する。postCreateCommand で作られるワークスペース内の gem はイメージ層に含まれないため、Gemfile.lock 全体の bundler-audit で別途検査する。

Critical/Highは全検出を保存し、[期限付き監査方針](ci-security-policy.md)に従って新規・修正可能・期限切れの項目を失敗させる。残件は CVE/GHSA・影響・回避策・担当・期限を記録して追跡する。根拠なしの ignore や一律の ignore-unfixed は使わない。

## 実行結果

GUI の補完・定義ジャンプ・ブレークポイント・保存時整形は VS Code での確認が必要であり、CLI テストで成功を代用しない。

### 検証済みの変更

- 旧 MCR/Bookworm イメージの Trivy 結果は OS HIGH/CRITICAL 450 件、同梱 JSON 2.18.0 の Critical 1 件。不要なグローバルツールとパッケージを避けるため、公式 Ruby slim/Trixie に移行した。
- `CVE-2026-33210` は同梱 JSON 2.18.0 が対象。JSON 3.1.0 をインストールし、読み込み元が patched gem 配下であることを確認した後に、旧 default JSON の Ruby ファイル・ネイティブ実装・gemspec を除去した。別プロセスで日本語を含む JSON の parse/generate と版を検査する。監査除外は追加していない。
- `scripts/setup.sh` をクリーンな Trixie コンテナ内の非 root ユーザーから実行し、38 gems の frozen install、RSpec **67 examples / 0 failures**、RuboCop **26 files / no offenses** が成功した。
- bundler-audit **0.9.3**、ruby-advisory-db **516ea4757d5eec778c49af8371c23309c4b70f42**（更新 2026-11-04）で、直接・推移的依存の公開脆弱性は **0 件**。[JSON 結果](gem-audit.json)。
- Dev Container CLI **0.90.0** で構成の読み取りを確認した。実イメージのビルドは Docker **29.9.2** で実施した。管理環境の TLS proxy CA は build secret / read-only mount で渡し、証明書検証を有効にしたまま検証した。

- （11-05）最終イメージの Trivy 0.76.2: **Critical 0 / High 75**（37 CVE、修正版の提供なし）。[全指摘とイメージ ID](container-audit.json)、[担当・期限・追跡](security-follow-up.md)。脆弱性対応を完了と判断できる状態ではない。CIは全指摘を保存し、期限付き監査方針に従って判定する。

### 2026-11-20 の再確認

- Ruby 4.0.10（セキュリティリリース）・Bundler 4.1.0・gem の互換範囲内の更新を適用。`ruby:4.0.10-trixie` 上の非 root ユーザーで `scripts/setup.sh`（38 gems の frozen install）、RSpec **67 examples / 0 failures**、RuboCop **27 files / no offenses**、bundler-audit **0 件**（ruby-advisory-db `49bb1fbb`、2026-11-19）、`scripts/test_editor_features.rb` の全項目成功。CI の Dev Container ジョブでも同じものを実行する。
- 同梱 JSON は 4.0.10 で 2.18.3 になったが、CVE-2026-33210（≥ 2.19.2 で修正）と CVE-2026-54696（≥ 2.19.9 で修正）の対象のため、JSON 3.1.0 への置き換えを継続。置き換え手順を 4.0.10 で実行し、読み込み元が json-3.1.0 であることを確認した。
- Trivy 0.76.2（CI run [44761714650](https://github.com/tomohiroJin/devcontainer-ruby/actions/runs/44761714650)）: **Critical 0 / High 137（54 CVE）**、修正版の提供 0 件。期限 2026-11-12 の失効によりゲートは設計どおり失敗した。差分（解消 7 CVE、DB 追加 24 CVE）と再評価、Trivy DB による CVE 別の再照合は [残件一覧](security-follow-up.md)。脆弱性対応を完了と判断できる状態ではない。
- この作業環境は deb.debian.org に到達できないため、Dev Container イメージ（apt 段を含む）のビルドとスキャンは CI で行った。
