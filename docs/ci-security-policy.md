# コンテナ監査の CI 判定

監査基準日: **2026-11-05 UTC / 2026-11-06 JST**。既存の保守記録・監査 JSON は UTC の実行日を用いる。

Trivy 0.76.2 で High/Critical を除外なしで JSON に保存し、`scripts/check_container_audit.py` で判定する。スキャナーの正常終了は収集の成功を意味し、脆弱性がないことを意味しない。通信・解析エラーや欠損した OS 監査は失敗させる。ログには元の High/Critical 件数と reviewed/blocking 件数を別に出す。

[期限付きの既知残件](../security/container-baseline.json) は、CVE・パッケージ・導入版・深刻度・エコシステムの組で限定する。担当、追跡 Issue、再確認期限 **2026-11-12 00:00 UTC（同日09:00 JST）** を保持する。今回の変更で期限や識別子の条件を緩めていない。

- 新規 CVE、導入版・深刻度の変化、修正版の提供は失敗させる。
- 期限当日以降、既知残件が残る場合は失敗させる。正しく完了したスキャンで残件がゼロになった場合は、期限後も成功する。未知の検出や修正版がある検出は、期限に関係なく失敗する。
- 期限内の既知残件も全検出を artifact に保持する。監査の成功と脆弱性対応の完了を区別する。
- 想定していない baseline kind は拒否する。Ruby 環境では `unfixed` のみ扱う。

Trivy DB は更新され、Debian のパッケージ版も `apt-get upgrade` によって変化する。イメージの digest 固定はベースの識別を保証し、apt リポジトリの将来状態を固定するものではない。新しい版や評価変更によるレビュー負荷は意図したもの。セキュリティ修正を取り込む一方、未評価のパッケージ版・深刻度を自動承認しない。Dependabot の変更が修正版なしの版更新でも、人による artifact 比較が必要になる。

## 再評価と更新の手順

CI はベースラインや期限を自動更新しない。例外期限を延長する定期処理も設けない。PR・週次・手動実行で同じゲートを使い、PR だけ警告へ弱めない。

1. 対象コミットで手動 CI を実行し、`ruby-container-audit` artifact の `container-audit.json` と `container-image.json` を取得する。ログのスキャナー版・DB 更新日時、対象コミット・イメージ ID、収集が正常終了したことを確認する。失敗した/一部欠損した監査を候補生成に使わない。
2. artifact と現在の baseline を比較する。修正版のある指摘は依存/イメージの更新で修正し、消えた指摘を削除する。新版の CVE・導入版・深刻度は再評価する。単なる index digest 更新なら、各 platform manifest が同一か確認して根拠を記録する。
3. 必要に応じ、以下のように **候補だけ** を別ファイルへ生成する。`review_due` は元の期限を保持し、`reason` は未評価の印を付ける。これは承認済み baseline ではなく、CI で自動適用しない。

   ```sh
   gh run download RUN_ID --name ruby-container-audit --dir /tmp/ruby-audit-review
   python3 - <<'PY'
   import json
   from pathlib import Path
   report = json.loads(Path('/tmp/ruby-audit-review/container-audit.json').read_text())
   baseline = json.loads(Path('security/container-baseline.json').read_text())
   candidate = dict(baseline, findings=[])
   for result in report['Results']:
       for finding in result.get('Vulnerabilities') or []:
           if finding['Severity'] not in ('HIGH', 'CRITICAL'):
               continue
           if finding.get('FixedVersion'):
               raise SystemExit('Fix available: remediate before considering acceptance')
           entry = {key: finding[key] for key in
                    ('VulnerabilityID', 'PkgName', 'InstalledVersion', 'Severity')}
           entry.update(Class=result['Class'], Type=result['Type'], kind='unfixed',
                        reason='REQUIRES HUMAN REVIEW: not approved')
           candidate['findings'].append(entry)
   Path('/tmp/ruby-baseline-candidate.json').write_text(json.dumps(candidate, indent=2) + '\n')
   PY
   ```

4. Repository メンテナーが Debian security tracker、CVE/上流 advisory、パッケージ内容と実際の使用方法を照合する。修正版の有無だけでなく、入力経路・権限・実行時/ビルド時の露出・回避策の限界を [露出評価](security-exposure.md) に記録し、理由を各 entry に反映する。証拠 URL と調査日を残す。
5. 残件を受け入れる根拠が揃った場合に限り、メンテナーが担当・追跡 Issue・具体的な次回期限を決め、変更理由とともに PR でレビューする。期限だけ延ばす変更や `InstalledVersion`/`Severity` の識別子除外は行わない。承認前に候補を正式 baseline に置き換えない。
6. 判定テストと実 artifact のゲートを実行し、修正された指摘・残存指摘・次回期限を確認する。

```sh
python3 -m unittest discover -s scripts -p test_audit_gate.py
python3 scripts/check_container_audit.py REPORT.json security/container-baseline.json
```

Dependabot の Bundler 4 / `ruby file:` 対応は、実際の初回更新ジョブログと PR の lockfile 差分で確認する。現時点で動作確認済みとは扱わない。失敗時はログを保存し、同じ Bundler 版で手動更新する代替 PR を作成し、更新が止まった状態を放置しない。
