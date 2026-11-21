# PR #11 レビュー指摘への対応

[レビュー](https://github.com/tomohiroJin/devcontainer-ruby/pull/11#issuecomment-6664650298) の番号に対応する。変更前の検証結果と今回の再検証を区別し、未検証事項を完了とは扱わない。

| 番号 | 対応・判断 | 確認 |
| --- | --- | --- |
| 1 | 検出ゼロでも期限後に失敗する欠陥を修正。既知残件がある場合のみ期限失効でブロックする。期限は **2026-11-12 00:00 UTC / 09:00 JST** のまま。30日への延長や PR だけの警告化は、未評価の受入期間を広げるため採用しない。artifact から候補を別ファイルに生成し、公式修正情報・影響の評価後に人が承認する手順を追記 | ゼロ件・期限後の残存・未知検出を含む判定テスト9件成功。[方針](ci-security-policy.md) |
| 2 | 導入版・深刻度を識別子から外す提案は採用しない。CVE・版・深刻度・エコシステムの厳密照合を維持。DB/apt 更新による再レビュー負荷と digest/apt 状態の区別を明文化 | 版/深刻度変更を拒否する既存テストを維持 |
| 3 | setup.sh は `BUNDLE_APP_CONFIG="$PWD/.bundle"` を export してから設定を書き込む。Dev Container にもワークスペース内 `.bundle` を設定し、後続の bundle コマンドから同じ設定を参照する | 同一 Ruby コンテナ内の2プロジェクトで setup を実行し、個別 `.bundle/config` と継承 config のハッシュ不変を実証。`scripts/test_setup_isolation.sh` を CI に追加 |
| 4 | index だけの更新は直ちに不具合とは扱わず、確認済み digest は保持。将来の Dependabot digest 更新では platform manifest の比較を手順に含める。現在のタグが同じ内容だという新たな断定はしない | 手動更新手順を記載。今回ベース digest の変更なし |
| 5 | Dependabot の Bundler 4 / `ruby file:` は実行ログ未確認のため、対応済みとは断定しない。初回更新ジョブ/生成 PR の lockfile 差分を確認し、失敗時はログ保存・手動更新 PR で代替する運用を明記 | 未検証として残す。通常の Bundler インストール・ロックの検証と混同しない |
| 6 | Ruby 環境に不要な `pip-sbom-only` 例外分岐を削除。許容 kind は `unfixed` のみ | 未対応 kind を入力すると fail closed になるテストへ置換 |
| 7 | 75 entry の定型理由をパッケージ/群別の露出評価に変更。UAPI ヘッダと実行時カーネルの区別、NOPASSWD 開発権限、Git のネットワーク/パーサ/圧縮/Perl 依存などを記録。無影響・到達不能とは断定しない | イメージ内 `dpkg-query`/`dpkg -L` と公式ファイル一覧を根拠に [露出評価](security-exposure.md) を追加。担当/追跡 Issue/期限は維持 |
| 8 | 下記の軽微指摘を修正。加えて push は main のみを維持し、PR 単位の concurrency と job timeout を追加 | actionlint 1.7.12、シェル構文、JSON 構文、差分空白検査成功 |

8(a) 利用されないルート `.dockerignore` を削除。現在の Dockerfile はソースを COPY しないため、代替の ignore を新設しない。

8(b) `USER $USERNAME` に統一。

8(c) setup-ruby の固定 SHA の注記を `v1.336.0` に具体化。

8(d) README の CI 行に gem/コンテナ監査を反映。

8(e) 削除済み拡張用の `cSpell.words` を除去。

8(f) CI 方針の基準日を UTC/JST 両方で表記。監査 JSON の実行日を書き換えず、タイムゾーン差を説明。

8(g) actionlint 1.7.12 をローカルで実行して成功を確認した。CI に固定版を `go run github.com/rhysd/actionlint/cmd/actionlint@v1.7.12` で実行する job も追加し、今後の実行をログで追跡可能にする。

今回のゲートテスト/分離テストは成功したが、VS Code GUI と Dependabot 初回ジョブは未確認。新たな Trivy DB による脆弱性件数の再評価は CI の実 artifact を参照し、以前の High 75 件を「今回新しく検査した件数」とは扱わない。

## 再検証（2 回目）の指摘への対応（2026-11-20）

[再検証コメント](https://github.com/tomohiroJin/devcontainer-ruby/pull/11#issuecomment-6673013023) の新たな指摘に対応する。

| 番号 | 対応・判断 | 確認 |
| --- | --- | --- |
| 1 | `scripts/test_setup_isolation.sh` のパス文字列比較（常に真）を削除。上流既定の `/usr/local/bundle/config` と、継承した `BUNDLE_APP_CONFIG` の config の両方を明示的に監視する。1 つ目のフィクスチャは `BUNDLE_APP_CONFIG=/usr/local/bundle` を与えて上流イメージの状態を CI でも再現する | Ruby 4.0.10 コンテナで成功。`setup.sh` から `export BUNDLE_APP_CONFIG` を削除すると失敗（rc=1）することを確認 |
| 2 | 監査ゲートが `REQUIRES HUMAN REVIEW` を含む reason の entry を `ValueError` で拒否する。候補ファイルをそのまま baseline に置いても通らない | 判定テスト `test_unreviewed_candidate_fails_closed` を追加 |
| 3 | containerEnv の `BUNDLE_APP_CONFIG` がコンテナ内の他ディレクトリにも適用されることを README に明記。コンテナはこのリポジトリ専用として扱う | 文書のみ |
| 4 | concurrency グループに `github.event_name` を含め、`cancel-in-progress` は PR のみに限定。main の push・週次・手動実行が互いにキャンセルされない | actionlint 1.7.12 成功 |
| 5 | `docs/maintenance.md` の Actions 版表記と `workflow-lint` の説明を更新。`workflow-lint` は `actions/setup-go`（v7.1.0、SHA 固定、Go 1.25.x）で Go を明示し、ランナー同梱の Go に依存しない | CI の `workflow-lint` 成功 |

### 同時に対応した変更

- **Ruby 4.0.10 へのセキュリティ更新**: 2026-11-18 に Regexp と String の大文字小文字変換の脆弱性 7 件（GHSA、一部は RCE の PoC あり）が公開された。`.ruby-version`、ベースイメージ（`ruby:4.0.10-slim-trixie`、digest 固定）、`Gemfile.lock` の `RUBY VERSION`、CI の setup-ruby（v1.343.0）を同時に更新した。4.0.10 の同梱 JSON は 2.18.3 で、CVE-2026-33210（修正版 2.19.2 以上）と CVE-2026-54696（修正版 2.19.9 以上）の対象のままなので、JSON 3.1.0 への置き換えは継続する。
- **Bundler 4.1.0 と gem の更新**: rubocop 1.92.3、rubocop-ast 1.53.0、rspec 系 3.13 の最新パッチなど。diff-lcs 2.x と prism 2.x は上流の制約のため据え置き（[保守記録](maintenance.md)）。
- **エディター機能のヘッドレス検証**: `scripts/test_editor_features.rb` を追加し CI の Dev Container 内で実行する。設定を壊すと失敗することを確認した（formatter/linter を `none` にすると整形・診断の 2 項目が FAIL）。
- **監査ゲートのログ**: ブロック時に Class/Type/CVE/パッケージ/導入版/深刻度/修正版を出力し、ログだけで再評価に着手できるようにした。
- **期限失効後の baseline 再評価**: 2026-11-12 の期限が失効し、CI は設計どおり失敗した。Ruby 4.0.10 イメージの CI スキャン結果（High 137 件、修正版 0 件）から baseline を作り直した。継続 53 件は、11-05 の露出評価をそのまま引き継いでいる。それに加えて、全 137 件に Trivy DB（Debian Security Tracker 由来、CI と同じ DB 版）から CVE ごとの Debian 側の状態を付記し、結果を各 reason と [recheck.json](audit-2026-11-20/recheck.json) に記録した。Debian の Web トラッカーと上流 advisory の個別閲覧はこの環境から到達できず、行っていない。CVE が追加された git/git-man と Kerberos ライブラリ（パッケージ自体は 11-05 から存在）は、依存経路と使用状況を確認して [露出評価](security-exposure.md) に追記した。期限は 2026-12-04。識別子の照合条件は緩めていない。**期限と残件の受け入れには、メンテナーによる PR レビューでの承認が必要（baseline の `approval` は PENDING）。CI の成功は受け入れの根拠ではない。**
- **RSpec デバッグ構成の起動失敗（検証で発見）**: vscode-rdbg は `command` 指定時に PATH 上の `rdbg`（イメージ同梱の debug gem）で起動する。そのため、Bundler 4.1.0 の下では default gem の prettyprint 0.2.0 と lockfile の 0.2.1 が衝突し、`Gem::LoadError` になっていた。Bundler の binstub `bin/rdbg` を追加し、`launch.json` の両構成に `"rdbgPath": "${workspaceFolder}/bin/rdbg"` を指定した。`scripts/test_editor_features.rb` は launch.json から拡張と同じコマンドライン（[vscode-rdbg](https://github.com/ruby/vscode-rdbg/blob/dd16d14/src/extension.ts) の `getExecCommands`/`getUnixRdbgArgs`。DAP クライアントがないため `--stop-at-load` の代わりに `--nonstop`）を組み立て、Bundler 環境を外して実行する。`rdbgPath` を外すと FAIL することを確認した。VS Code GUI での起動は未確認。

### 敵対的検証（再検証）の非ブロッキング指摘への対応

- Ruby パッチ更新手順のコマンドを `bundle update --ruby`（frozen の一時解除を含む）に修正した。`bundle lock --update --ruby` は Bundler 4.1.0 では実行できない。
- Trivy DB による状態の照合は、入力も DB も CI と同じで独立した証拠ではない。そのため「状態の付記」と表現を改めた。
- `approval: PENDING` はゲートでは判定しない。承認時に承認者と日付へ書き換える運用を、PR のチェックリストに加えた。
- artifact を取得できない場合の手順（ゲートのログと SBOM による照合）は、今回追加した方針変更である。メンテナーの判断事項として PR に明示した。
- エディターテストで「Debug current Ruby file」を起動する際、vscode-rdbg の `rdbg.useBundler` の既定値（true）に合わせて `bundle exec ruby` を使うようにした。

### 利用者の起動で見つかった問題（2026-11-21）

- **Ruby LSP 拡張の「Failed to setup the bundle」（`Gem::FilePermissionError`）**
  - 原因: 拡張は起動時に `gem list ruby-lsp language_server-protocol prism rbs` を確認し、不足があれば remote user で `gem install ruby-lsp --env-shebang` を実行する（[ruby-lsp vscode/src/workspace.ts](https://github.com/Shopify/ruby-lsp/blob/ad2996a/vscode/src/workspace.ts) の `installOrUpdateServer`）。Dockerfile では root で gem をインストールしていたため、`GEM_HOME` 配下が root 所有の 755 になり、書き込みに失敗していた。
  - 対応: `GEM_HOME` を固定 GID 2000 の `rubygems` グループに渡し、remote user をこのグループに加えた。VS Code が UID/GID を書き換えても、補助グループは残る。
  - 確認: UID を 1001 に変えた状態で `gem install`/`gem update` が成功することを確認した。エディターテストに書き込み可否の検査を追加し、修正を外すと FAIL することも確認した。
  - テストで見逃した理由: 従来のテストは `bundle exec ruby-lsp` を直接起動しており、拡張が行うグローバルインストールの手順を通っていなかった。
- **既存コンテナの `docker start` 失敗**: Docker Desktop の WSL 連携で、バインドマウントの中継パスが再起動後に無くなったため。リポジトリ側の問題ではなく、コンテナの作り直しで解消した。
