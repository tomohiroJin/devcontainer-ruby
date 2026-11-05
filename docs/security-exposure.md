# 未修正パッケージの露出評価

評価日: 2026-11-06 JST（監査実行日 2026-11-05 UTC）。対象は [監査記録](container-audit.json) と [厳密な baseline](../security/container-baseline.json) にある導入版のみ。全指摘の Debian 修正版は当該 Trivy DB で未提供。これは無影響の証拠ではない。CVE 別の公式情報は [残件一覧](security-follow-up.md) の advisory と [Debian security tracker](https://security-tracker.debian.org/tracker/) を照合する。新しい版・深刻度・CVE は別途評価する。

以下は Dockerfile の導入パッケージ、[Debian のパッケージ内容](https://packages.debian.org/trixie/)、開発コンテナの起動方法に基づくパッケージ単位の評価。各 baseline entry の `reason` にもパッケージ別の内容を記録した。全 CVE の悪用可否を動的検証したという意味ではない。

| パッケージ群 | 使用・証拠 | 露出と制約 |
| --- | --- | --- |
| linux-libc-dev | [UAPI ヘッダ一覧](https://packages.debian.org/trixie/amd64/linux-libc-dev/filelist)。build-essential 経由のビルド依存 | イメージ内で稼働するカーネルではなくビルド用ヘッダ。実行時カーネルはホストが管理する。ただしヘッダ定義を取り込んだ生成プログラムへの影響は別途評価が必要。カーネル由来 CVE を一律に無影響とはしない |
| sudo | [sudo 内容](https://packages.debian.org/trixie/amd64/sudo/filelist)、Dockerfile の NOPASSWD 設定 | 開発操作のためコンテナ内 root を意図的に許す。vscode/root の間を防御境界として扱えない。未知の Repository やスクリプトを実行しない。ホストへの影響まで防止できるとは断定しない |
| bsdutils、login、mount、util-linux、libblkid1、liblastlog2-2、libmount1、libsmartcols1、libuuid1 | [util-linux 内容](https://packages.debian.org/trixie/amd64/util-linux/filelist)、[mount](https://packages.debian.org/trixie/amd64/mount/filelist)。ファイルシステム・ユーザーセッションの基盤 | 開発ツールから実行/呼び出し可能。ワークスペースのファイルやメタデータ、マウント操作が入力になる。追加の capability、privileged mode、不明なデバイス/マウントを与えない。到達不能とは扱わない |
| libcurl3t64-gnutls | [内容](https://packages.debian.org/trixie/amd64/libcurl3t64-gnutls/filelist)。Git の HTTPS クライアント依存 | 不正な remote 応答がライブラリへ到達し得る。信頼するリポジトリ/remote に限定する。TLS 検証を無効化しないことだけで全 CVE を回避できるとは言わない |
| libexpat1 | [XML パーサの共有ライブラリ](https://packages.debian.org/trixie/amd64/libexpat1/filelist) | 外部 XML を解析する native consumer が使う可能性がある。XML サービスを公開していないことだけでは不使用を証明しない。未知の XML を処理しない |
| zlib1g | [圧縮ライブラリ](https://packages.debian.org/trixie/amd64/zlib1g/filelist) | Ruby や native tool による圧縮データの展開が入力経路。gem/アーカイブの取得元を限定する。信頼する取得元でも脆弱な実装自体のリスクは残る |
| libsqlite3-0 | [SQLite ライブラリ](https://packages.debian.org/trixie/amd64/libsqlite3-0/filelist) | DB サーバを起動していないが、native consumer は DB ファイルを開ける。未知の DB ファイルを扱わず、ライブラリが到達不能とは断定しない |
| libacl1 | [ACL ライブラリ](https://packages.debian.org/trixie/amd64/libacl1/filelist) | ファイル操作ツールから権限メタデータを処理し得る。不明なファイルシステム/権限設定の取り込みを避ける |
| libsystemd0、libudev1 | [systemd client](https://packages.debian.org/trixie/amd64/libsystemd0/filelist)、[udev client](https://packages.debian.org/trixie/amd64/libudev1/filelist) | コンテナは systemd/udev daemon ではなく開発プロセスを起動するが、共有ライブラリ API は利用可能。追加デバイス公開や privileged mode を避ける。daemon 不在をライブラリ無影響の根拠にしない |
| libtinfo6、ncurses-base、ncurses-bin | [ncurses](https://packages.debian.org/trixie/amd64/ncurses-bin/filelist) の端末機能 | 対話操作の端末制御や terminfo が入力になる。未知の端末定義を読み込まない。対話用途に限定しても影響がゼロとはしない |
| libperl5.40、perl、perl-base、perl-modules-5.40 | [Perl 内容](https://packages.debian.org/trixie/amd64/perl/filelist)。開発ツールや hooks から使用可能 | スクリプト/Repository hooks を実行すると interpreter に到達する。信頼しない hooks を実行しない。未使用の保証はしない |

担当・追跡 Issue・2026-11-12 の期限は [残件一覧](security-follow-up.md) を保持する。期限はゲートで UTC 00:00（JST 09:00）から有効。正式な更新は [CI 方針](ci-security-policy.md) の人による再評価を必須とし、週次の自動延長は行わない。

実物確認: `ruby-issue10-lean` 内の `dpkg-query -W` で Git が libcurl3t64-gnutls/libexpat1/zlib1g/perl に依存し、build-essential → libc6-dev → linux-libc-dev の依存関係を確認した。`dpkg -L linux-libc-dev` の内容は `/usr/include/` 配下のヘッダであり、プロセスの UID は1000だった。これは各 CVE の悪用実験を行ったという意味ではない。
