# 未解消のコンテナ監査指摘

検査日 2026-11-05 / Trivy 0.76.2 / Debian 13.7。対象イメージ ID と全 75 件のパッケージ別指摘は [container-audit.json](container-audit.json) に保存。Critical **0 件**、High **75 件（37 CVE）**。修正バージョンが DB に掲載されている指摘は **0 件**。元の MCR イメージの 451 件から削減し、修正可能だった JSON の Critical を解消した。

追跡: [Issue #10](https://github.com/tomohiroJin/devcontainer-ruby/issues/10)。担当: Repository メンテナー。次回確認期限: **2026-11-12**。週次 CI で継続検査し、Debian 修正版の公開時に再ビルドする。修正完了まで Issue の完了条件は未充足として扱う。CIは全75検出をartifactに残す。[期限付き監査方針](ci-security-policy.md)で既知・修正版未提供のパッケージ/版/CVEだけを2026-11-12まで追跡対象とし、新規検出・修正版の提供・期限切れは失敗させる。

開発コンテナとして使い、外部へサービスを公開しない。未知の Repository や入力を実行しない。これは全 CVE の回避を保証する措置ではない。パッケージ単位の入力経路と制約は [露出評価](security-exposure.md) に記録した。CVE 別の修正状況と追加の影響評価は次回確認時に再評価する。Git/sudo/build-essential は開発機能に必要なため保持した。

| CVE | パッケージ | 修正版 / 対応 |
| --- | --- | --- |
| [CVE-2013-7445](https://avd.aquasec.com/nvd/cve-2013-7445) | linux-libc-dev | 未提供。Debian 更新を追跡し再ビルド |
| [CVE-2019-19449](https://avd.aquasec.com/nvd/cve-2019-19449) | linux-libc-dev | 未提供。Debian 更新を追跡し再ビルド |
| [CVE-2019-19814](https://avd.aquasec.com/nvd/cve-2019-19814) | linux-libc-dev | 未提供。Debian 更新を追跡し再ビルド |
| [CVE-2021-3847](https://avd.aquasec.com/nvd/cve-2021-3847) | linux-libc-dev | 未提供。Debian 更新を追跡し再ビルド |
| [CVE-2021-3864](https://avd.aquasec.com/nvd/cve-2021-3864) | linux-libc-dev | 未提供。Debian 更新を追跡し再ビルド |
| [CVE-2024-21803](https://avd.aquasec.com/nvd/cve-2024-21803) | linux-libc-dev | 未提供。Debian 更新を追跡し再ビルド |
| [CVE-2024-58015](https://avd.aquasec.com/nvd/cve-2024-58015) | linux-libc-dev | 未提供。Debian 更新を追跡し再ビルド |
| [CVE-2025-40025](https://avd.aquasec.com/nvd/cve-2025-40025) | linux-libc-dev | 未提供。Debian 更新を追跡し再ビルド |
| [CVE-2025-69720](https://avd.aquasec.com/nvd/cve-2025-69720) | libtinfo6, ncurses-base, ncurses-bin | 未提供。Debian 更新を追跡し再ビルド |
| [CVE-2026-113351](https://avd.aquasec.com/nvd/cve-2026-113351) | libexpat1 | 未提供。Debian 更新を追跡し再ビルド |
| [CVE-2026-117610](https://avd.aquasec.com/nvd/cve-2026-117610) | libexpat1 | 未提供。Debian 更新を追跡し再ビルド |
| [CVE-2026-118370](https://avd.aquasec.com/nvd/cve-2026-118370) | libexpat1 | 未提供。Debian 更新を追跡し再ビルド |
| [CVE-2026-119373](https://avd.aquasec.com/nvd/cve-2026-119373) | libsqlite3-0 | 未提供。Debian 更新を追跡し再ビルド |
| [CVE-2026-12064](https://avd.aquasec.com/nvd/cve-2026-12064) | libcurl3t64-gnutls | 未提供。Debian 更新を追跡し再ビルド |
| [CVE-2026-16742](https://avd.aquasec.com/nvd/cve-2026-16742) | libsystemd0, libudev1 | 未提供。Debian 更新を追跡し再ビルド |
| [CVE-2026-23102](https://avd.aquasec.com/nvd/cve-2026-23102) | linux-libc-dev | 未提供。Debian 更新を追跡し再ビルド |
| [CVE-2026-31568](https://avd.aquasec.com/nvd/cve-2026-31568) | linux-libc-dev | 未提供。Debian 更新を追跡し再ビルド |
| [CVE-2026-46279](https://avd.aquasec.com/nvd/cve-2026-46279) | linux-libc-dev | 未提供。Debian 更新を追跡し再ビルド |
| [CVE-2026-54369](https://avd.aquasec.com/nvd/cve-2026-54369) | libacl1 | 未提供。Debian 更新を追跡し再ビルド |
| [CVE-2026-72042](https://avd.aquasec.com/nvd/cve-2026-72042) | linux-libc-dev | 未提供。Debian 更新を追跡し再ビルド |
| [CVE-2026-76642](https://avd.aquasec.com/nvd/cve-2026-76642) | bsdutils, libblkid1, liblastlog2-2, libmount1, libsmartcols1, libuuid1, login, mount, util-linux | 未提供。Debian 更新を追跡し再ビルド |
| [CVE-2026-76844](https://avd.aquasec.com/nvd/cve-2026-76844) | zlib1g | 未提供。Debian 更新を追跡し再ビルド |
| [CVE-2026-78408](https://avd.aquasec.com/nvd/cve-2026-78408) | bsdutils, libblkid1, liblastlog2-2, libmount1, libsmartcols1, libuuid1, login, mount, util-linux | 未提供。Debian 更新を追跡し再ビルド |
| [CVE-2026-78409](https://avd.aquasec.com/nvd/cve-2026-78409) | bsdutils, libblkid1, liblastlog2-2, libmount1, libsmartcols1, libuuid1, login, mount, util-linux | 未提供。Debian 更新を追跡し再ビルド |
| [CVE-2026-78410](https://avd.aquasec.com/nvd/cve-2026-78410) | bsdutils, libblkid1, liblastlog2-2, libmount1, libsmartcols1, libuuid1, login, mount, util-linux | 未提供。Debian 更新を追跡し再ビルド |
| [CVE-2026-8458](https://avd.aquasec.com/nvd/cve-2026-8458) | libcurl3t64-gnutls | 未提供。Debian 更新を追跡し再ビルド |
| [CVE-2026-89675](https://avd.aquasec.com/nvd/cve-2026-89675) | linux-libc-dev | 未提供。Debian 更新を追跡し再ビルド |
| [CVE-2026-90315](https://avd.aquasec.com/nvd/cve-2026-90315) | linux-libc-dev | 未提供。Debian 更新を追跡し再ビルド |
| [CVE-2026-9538](https://avd.aquasec.com/nvd/cve-2026-9538) | libperl5.40, perl, perl-base, perl-modules-5.40 | 未提供。Debian 更新を追跡し再ビルド |
| [CVE-2026-96512](https://avd.aquasec.com/nvd/cve-2026-96512) | sudo | 未提供。Debian 更新を追跡し再ビルド |
| [CVE-2026-98118](https://avd.aquasec.com/nvd/cve-2026-98118) | linux-libc-dev | 未提供。Debian 更新を追跡し再ビルド |
| [CVE-2026-98364](https://avd.aquasec.com/nvd/cve-2026-98364) | linux-libc-dev | 未提供。Debian 更新を追跡し再ビルド |
| [CVE-2026-98466](https://avd.aquasec.com/nvd/cve-2026-98466) | linux-libc-dev | 未提供。Debian 更新を追跡し再ビルド |
| [CVE-2026-98715](https://avd.aquasec.com/nvd/cve-2026-98715) | linux-libc-dev | 未提供。Debian 更新を追跡し再ビルド |
| [CVE-2026-98853](https://avd.aquasec.com/nvd/cve-2026-98853) | linux-libc-dev | 未提供。Debian 更新を追跡し再ビルド |
| [CVE-2026-98999](https://avd.aquasec.com/nvd/cve-2026-98999) | linux-libc-dev | 未提供。Debian 更新を追跡し再ビルド |
| [CVE-2026-99109](https://avd.aquasec.com/nvd/cve-2026-99109) | linux-libc-dev | 未提供。Debian 更新を追跡し再ビルド |
