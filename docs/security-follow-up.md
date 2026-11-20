# 未解消のコンテナ監査指摘

## 2026-11-20 の再評価（現行）

対象: PR の CI run [44761714650](https://github.com/tomohiroJin/devcontainer-ruby/actions/runs/44761714650)（`ruby:4.0.10-slim-trixie` ベース、Trivy 0.76.2、Debian 13）。Critical **0 件**、High **137 件（54 CVE）**。修正バージョンが DB に掲載されている指摘は **0 件**（ゲート出力に `fixed-in=` なし）。全件の識別子は [baseline](../security/container-baseline.json) に、生の Trivy JSON は同 run の `ruby-container-audit` artifact にある（この作業環境からは artifact ストレージに到達できず、ゲートのログに出力された Class/Type/CVE/パッケージ/導入版/深刻度から baseline を作成した）。

- 解消（7 CVE）: linux-libc-dev の CVE-2025-40025、CVE-2026-98466、CVE-2026-98715、CVE-2026-98853、CVE-2026-98999、CVE-2026-99109（6.12.115-2 → 6.12.117-1 で消滅）、zlib1g の CVE-2026-76844。
- 新規（24 CVE）: git/git-man 3 件、Kerberos ライブラリ（libgssapi-krb5-2、libk5crypto3、libkrb5-3、libkrb5support0）14 件、libexpat1 1 件、libsqlite3-0 2 件、linux-libc-dev 4 件。いずれも修正版未提供。
- 継続（30 CVE）: 11-05 と同じパッケージ・導入版・深刻度。linux-libc-dev は導入版が変わったため entry を作り直した。

追跡: [Issue #10](https://github.com/tomohiroJin/devcontainer-ruby/issues/10)。担当: Repository メンテナー。次回確認期限: **2026-12-04**（2 週間。12-05 の手動見直しの前日）。期限の再設定はメンテナーが PR レビューで承認するまで確定しない。修正完了まで Issue の完了条件は未充足として扱う。新規パッケージの露出評価は [露出評価](security-exposure.md) に追記した。

開発コンテナとして使い、外部へサービスを公開しない。未知の Repository や入力を実行しない。これは全 CVE の回避を保証する措置ではない。Git/sudo/build-essential は開発機能に必要なため保持した。

| CVE | パッケージ | 状態 | 修正版 / 対応 |
| --- | --- | --- | --- |
| [CVE-2013-7445](https://security-tracker.debian.org/tracker/CVE-2013-7445) | linux-libc-dev | 継続 | 未提供。Debian 更新を追跡し再ビルド |
| [CVE-2019-19449](https://security-tracker.debian.org/tracker/CVE-2019-19449) | linux-libc-dev | 継続 | 未提供。Debian 更新を追跡し再ビルド |
| [CVE-2019-19814](https://security-tracker.debian.org/tracker/CVE-2019-19814) | linux-libc-dev | 継続 | 未提供。Debian 更新を追跡し再ビルド |
| [CVE-2021-3847](https://security-tracker.debian.org/tracker/CVE-2021-3847) | linux-libc-dev | 継続 | 未提供。Debian 更新を追跡し再ビルド |
| [CVE-2021-3864](https://security-tracker.debian.org/tracker/CVE-2021-3864) | linux-libc-dev | 継続 | 未提供。Debian 更新を追跡し再ビルド |
| [CVE-2024-21803](https://security-tracker.debian.org/tracker/CVE-2024-21803) | linux-libc-dev | 継続 | 未提供。Debian 更新を追跡し再ビルド |
| [CVE-2024-21963](https://security-tracker.debian.org/tracker/CVE-2024-21963) | linux-libc-dev | 11-20 新規 | 未提供。Debian 更新を追跡し再ビルド |
| [CVE-2024-58015](https://security-tracker.debian.org/tracker/CVE-2024-58015) | linux-libc-dev | 継続 | 未提供。Debian 更新を追跡し再ビルド |
| [CVE-2025-69720](https://security-tracker.debian.org/tracker/CVE-2025-69720) | libtinfo6, ncurses-base, ncurses-bin | 継続 | 未提供。Debian 更新を追跡し再ビルド |
| [CVE-2026-0004](https://security-tracker.debian.org/tracker/CVE-2026-0004) | linux-libc-dev | 11-20 新規 | 未提供。Debian 更新を追跡し再ビルド |
| [CVE-2026-8458](https://security-tracker.debian.org/tracker/CVE-2026-8458) | libcurl3t64-gnutls | 継続 | 未提供。Debian 更新を追跡し再ビルド |
| [CVE-2026-9538](https://security-tracker.debian.org/tracker/CVE-2026-9538) | libperl5.40, perl, perl-base, perl-modules-5.40 | 継続 | 未提供。Debian 更新を追跡し再ビルド |
| [CVE-2026-12064](https://security-tracker.debian.org/tracker/CVE-2026-12064) | libcurl3t64-gnutls | 継続 | 未提供。Debian 更新を追跡し再ビルド |
| [CVE-2026-16742](https://security-tracker.debian.org/tracker/CVE-2026-16742) | libsystemd0, libudev1 | 継続 | 未提供。Debian 更新を追跡し再ビルド |
| [CVE-2026-23102](https://security-tracker.debian.org/tracker/CVE-2026-23102) | linux-libc-dev | 継続 | 未提供。Debian 更新を追跡し再ビルド |
| [CVE-2026-31568](https://security-tracker.debian.org/tracker/CVE-2026-31568) | linux-libc-dev | 継続 | 未提供。Debian 更新を追跡し再ビルド |
| [CVE-2026-46279](https://security-tracker.debian.org/tracker/CVE-2026-46279) | linux-libc-dev | 継続 | 未提供。Debian 更新を追跡し再ビルド |
| [CVE-2026-54369](https://security-tracker.debian.org/tracker/CVE-2026-54369) | libacl1 | 継続 | 未提供。Debian 更新を追跡し再ビルド |
| [CVE-2026-71199](https://security-tracker.debian.org/tracker/CVE-2026-71199) | libgssapi-krb5-2, libk5crypto3, libkrb5-3, libkrb5support0 | 11-20 新規 | 未提供。Debian 更新を追跡し再ビルド |
| [CVE-2026-71200](https://security-tracker.debian.org/tracker/CVE-2026-71200) | libgssapi-krb5-2, libk5crypto3, libkrb5-3, libkrb5support0 | 11-20 新規 | 未提供。Debian 更新を追跡し再ビルド |
| [CVE-2026-72042](https://security-tracker.debian.org/tracker/CVE-2026-72042) | linux-libc-dev | 継続 | 未提供。Debian 更新を追跡し再ビルド |
| [CVE-2026-76642](https://security-tracker.debian.org/tracker/CVE-2026-76642) | bsdutils, libblkid1, liblastlog2-2, libmount1, libsmartcols1, libuuid1, login, mount, util-linux | 継続 | 未提供。Debian 更新を追跡し再ビルド |
| [CVE-2026-78408](https://security-tracker.debian.org/tracker/CVE-2026-78408) | bsdutils, libblkid1, liblastlog2-2, libmount1, libsmartcols1, libuuid1, login, mount, util-linux | 継続 | 未提供。Debian 更新を追跡し再ビルド |
| [CVE-2026-78409](https://security-tracker.debian.org/tracker/CVE-2026-78409) | bsdutils, libblkid1, liblastlog2-2, libmount1, libsmartcols1, libuuid1, login, mount, util-linux | 継続 | 未提供。Debian 更新を追跡し再ビルド |
| [CVE-2026-78410](https://security-tracker.debian.org/tracker/CVE-2026-78410) | bsdutils, libblkid1, liblastlog2-2, libmount1, libsmartcols1, libuuid1, login, mount, util-linux | 継続 | 未提供。Debian 更新を追跡し再ビルド |
| [CVE-2026-89675](https://security-tracker.debian.org/tracker/CVE-2026-89675) | linux-libc-dev | 継続 | 未提供。Debian 更新を追跡し再ビルド |
| [CVE-2026-90315](https://security-tracker.debian.org/tracker/CVE-2026-90315) | linux-libc-dev | 継続 | 未提供。Debian 更新を追跡し再ビルド |
| [CVE-2026-96512](https://security-tracker.debian.org/tracker/CVE-2026-96512) | sudo | 継続 | 未提供。Debian 更新を追跡し再ビルド |
| [CVE-2026-98118](https://security-tracker.debian.org/tracker/CVE-2026-98118) | linux-libc-dev | 継続 | 未提供。Debian 更新を追跡し再ビルド |
| [CVE-2026-98364](https://security-tracker.debian.org/tracker/CVE-2026-98364) | linux-libc-dev | 継続 | 未提供。Debian 更新を追跡し再ビルド |
| [CVE-2026-99272](https://security-tracker.debian.org/tracker/CVE-2026-99272) | linux-libc-dev | 11-20 新規 | 未提供。Debian 更新を追跡し再ビルド |
| [CVE-2026-99387](https://security-tracker.debian.org/tracker/CVE-2026-99387) | linux-libc-dev | 11-20 新規 | 未提供。Debian 更新を追跡し再ビルド |
| [CVE-2026-105437](https://security-tracker.debian.org/tracker/CVE-2026-105437) | git, git-man | 11-20 新規 | 未提供。Debian 更新を追跡し再ビルド |
| [CVE-2026-107364](https://security-tracker.debian.org/tracker/CVE-2026-107364) | libgssapi-krb5-2, libk5crypto3, libkrb5-3, libkrb5support0 | 11-20 新規 | 未提供。Debian 更新を追跡し再ビルド |
| [CVE-2026-111760](https://security-tracker.debian.org/tracker/CVE-2026-111760) | git, git-man | 11-20 新規 | 未提供。Debian 更新を追跡し再ビルド |
| [CVE-2026-112315](https://security-tracker.debian.org/tracker/CVE-2026-112315) | libgssapi-krb5-2, libk5crypto3, libkrb5-3, libkrb5support0 | 11-20 新規 | 未提供。Debian 更新を追跡し再ビルド |
| [CVE-2026-112316](https://security-tracker.debian.org/tracker/CVE-2026-112316) | libgssapi-krb5-2, libk5crypto3, libkrb5-3, libkrb5support0 | 11-20 新規 | 未提供。Debian 更新を追跡し再ビルド |
| [CVE-2026-112317](https://security-tracker.debian.org/tracker/CVE-2026-112317) | libgssapi-krb5-2, libk5crypto3, libkrb5-3, libkrb5support0 | 11-20 新規 | 未提供。Debian 更新を追跡し再ビルド |
| [CVE-2026-112318](https://security-tracker.debian.org/tracker/CVE-2026-112318) | libgssapi-krb5-2, libk5crypto3, libkrb5-3, libkrb5support0 | 11-20 新規 | 未提供。Debian 更新を追跡し再ビルド |
| [CVE-2026-112319](https://security-tracker.debian.org/tracker/CVE-2026-112319) | libgssapi-krb5-2, libk5crypto3, libkrb5-3, libkrb5support0 | 11-20 新規 | 未提供。Debian 更新を追跡し再ビルド |
| [CVE-2026-112320](https://security-tracker.debian.org/tracker/CVE-2026-112320) | libgssapi-krb5-2, libk5crypto3, libkrb5-3, libkrb5support0 | 11-20 新規 | 未提供。Debian 更新を追跡し再ビルド |
| [CVE-2026-112321](https://security-tracker.debian.org/tracker/CVE-2026-112321) | libgssapi-krb5-2, libk5crypto3, libkrb5-3, libkrb5support0 | 11-20 新規 | 未提供。Debian 更新を追跡し再ビルド |
| [CVE-2026-112322](https://security-tracker.debian.org/tracker/CVE-2026-112322) | libgssapi-krb5-2, libk5crypto3, libkrb5-3, libkrb5support0 | 11-20 新規 | 未提供。Debian 更新を追跡し再ビルド |
| [CVE-2026-112323](https://security-tracker.debian.org/tracker/CVE-2026-112323) | libgssapi-krb5-2, libk5crypto3, libkrb5-3, libkrb5support0 | 11-20 新規 | 未提供。Debian 更新を追跡し再ビルド |
| [CVE-2026-113351](https://security-tracker.debian.org/tracker/CVE-2026-113351) | libexpat1 | 継続 | 未提供。Debian 更新を追跡し再ビルド |
| [CVE-2026-114466](https://security-tracker.debian.org/tracker/CVE-2026-114466) | git, git-man | 11-20 新規 | 未提供。Debian 更新を追跡し再ビルド |
| [CVE-2026-115506](https://security-tracker.debian.org/tracker/CVE-2026-115506) | libexpat1 | 11-20 新規 | 未提供。Debian 更新を追跡し再ビルド |
| [CVE-2026-117610](https://security-tracker.debian.org/tracker/CVE-2026-117610) | libexpat1 | 継続 | 未提供。Debian 更新を追跡し再ビルド |
| [CVE-2026-118370](https://security-tracker.debian.org/tracker/CVE-2026-118370) | libexpat1 | 継続 | 未提供。Debian 更新を追跡し再ビルド |
| [CVE-2026-118380](https://security-tracker.debian.org/tracker/CVE-2026-118380) | libgssapi-krb5-2, libk5crypto3, libkrb5-3, libkrb5support0 | 11-20 新規 | 未提供。Debian 更新を追跡し再ビルド |
| [CVE-2026-119079](https://security-tracker.debian.org/tracker/CVE-2026-119079) | libgssapi-krb5-2, libk5crypto3, libkrb5-3, libkrb5support0 | 11-20 新規 | 未提供。Debian 更新を追跡し再ビルド |
| [CVE-2026-119373](https://security-tracker.debian.org/tracker/CVE-2026-119373) | libsqlite3-0 | 継続 | 未提供。Debian 更新を追跡し再ビルド |
| [CVE-2026-119374](https://security-tracker.debian.org/tracker/CVE-2026-119374) | libsqlite3-0 | 11-20 新規 | 未提供。Debian 更新を追跡し再ビルド |
| [CVE-2026-119379](https://security-tracker.debian.org/tracker/CVE-2026-119379) | libsqlite3-0 | 11-20 新規 | 未提供。Debian 更新を追跡し再ビルド |

## 2026-11-05 の記録（履歴）

検査日 2026-11-05 / Trivy 0.76.2 / Debian 13.7 / `ruby:4.0.9-slim-trixie`。Critical 0 件、High 75 件（37 CVE）、修正版の提供 0 件。生の結果は [container-audit.json](container-audit.json)。元の MCR イメージの 451 件から削減し、修正可能だった JSON の Critical を解消した。期限 2026-11-12 に失効し、上記の再評価で置き換えた。
