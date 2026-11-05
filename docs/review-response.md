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
