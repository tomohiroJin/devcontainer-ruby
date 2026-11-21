# 未解消のコンテナ監査指摘

## 2026-11-20 の再評価（現行）

対象: PR の CI run [44761714650](https://github.com/tomohiroJin/devcontainer-ruby/actions/runs/44761714650)（失敗、期限切れ）と [44762695742](https://github.com/tomohiroJin/devcontainer-ruby/actions/runs/44762695742)（baseline 更新後）。`ruby:4.0.10-slim-trixie` ベース、イメージ config digest `sha256:98aeab17de98e1562cdc2a918990dba7395e094cc37652864039826ff67928d4`、Debian 13.7、パッケージ 164、Trivy 0.76.2。Critical **0 件**、High **137 件（54 CVE）**。修正バージョンが DB に掲載されている指摘は **0 件**（ゲート出力に `fixed-in=` なし）。全件の識別子は [baseline](../security/container-baseline.json) に、生の Trivy JSON は両 run の `ruby-container-audit` artifact（GitHub の保持期間 90 日）にある。この作業環境からは artifact ストレージに到達できなかったため、ゲートのログに出力された Class/Type/CVE/パッケージ/導入版/深刻度から baseline を作成した。

**Trivy DB による CVE 別の状態の付記**: baseline のパッケージ/版 30 組から SBOM（[baseline-packages.cdx.json](audit-2026-11-20/baseline-packages.cdx.json)）を作り、Trivy 0.76.2 と DB（2026-11-20T13:11Z 更新、データソース: Debian Security Tracker）で照合した。結果は [recheck.json](audit-2026-11-20/recheck.json)。入力が baseline のパッケージ/版で、DB も CI と同じ Trivy 0.76.2・同日版のため、137 件の一致はほぼ自明であり独立した証拠ではない。新たに得た情報は CVE ごとの状態で、修正版は 0 件、Debian の状態は `affected` 133 件、`fix_deferred` 4 件（perl 系の CVE-2026-9538。Debian が修正を延期）。security-tracker.debian.org の Web ページはこの環境から到達できず、直接は閲覧していない。

- 解消（7 CVE）: linux-libc-dev の CVE-2025-40025、CVE-2026-98466、CVE-2026-98715、CVE-2026-98853、CVE-2026-98999、CVE-2026-99109（6.12.115-2 → 6.12.117-1 で消滅）、zlib1g の CVE-2026-76844。
- 11-20 に追加された CVE（24 件）: git/git-man 3 件、Kerberos ライブラリ（libgssapi-krb5-2、libk5crypto3、libkrb5-3、libkrb5support0）14 件、libexpat1 1 件、libsqlite3-0 2 件、linux-libc-dev 4 件。いずれも修正版未提供。**パッケージ自体は 11-05 のイメージにも同じ版で含まれており**（Trivy の `pkg_num=164` は両 run で同じ、Dockerfile の apt 行も不変）、Trivy DB の更新で新たに CVE が付いたもの。Ruby 4.0.10 への更新が原因ではない。
- 継続（30 CVE）: 11-05 と同じパッケージ・導入版・深刻度。linux-libc-dev は導入版が変わったため entry を作り直した。

追跡: [Issue #10](https://github.com/tomohiroJin/devcontainer-ruby/issues/10)。担当: Repository メンテナー。次回確認期限: **2026-12-04**（2 週間。12-05 の手動見直しの前日）。**この再評価と期限の再設定は、メンテナーが PR レビューで承認するまで確定しない。CI ゲートの成功は受け入れの根拠ではない**（baseline の `approval` は `PENDING`。ゲートはこの欄を判定しない）。修正完了まで Issue の完了条件は未充足として扱う。CVE が追加されたパッケージ（git/git-man、Kerberos ライブラリ）の露出評価は [露出評価](security-exposure.md) に追記した。

開発コンテナとして使い、外部へサービスを公開しない。未知の Repository や入力を実行しない。これは全 CVE の回避を保証する措置ではない。Git/sudo/build-essential は開発機能に必要なため保持した。

| CVE | パッケージ | 区分 | Debian の状態 | 概要（Trivy DB の title） |
| --- | --- | --- | --- | --- |
| [CVE-2013-7445](https://security-tracker.debian.org/tracker/CVE-2013-7445) | linux-libc-dev | 継続 | affected | kernel: memory exhaustion via crafted Graphics Execution Manager (GEM) objects |
| [CVE-2019-19449](https://security-tracker.debian.org/tracker/CVE-2019-19449) | linux-libc-dev | 継続 | affected | kernel: mounting a crafted f2fs filesystem image can lead to slab-out-of-bounds read access in f2fs_build_segment_manager in fs/f2fs/segment.c |
| [CVE-2019-19814](https://security-tracker.debian.org/tracker/CVE-2019-19814) | linux-libc-dev | 継続 | affected | kernel: out-of-bounds write in __remove_dirty_segment in fs/f2fs/segment.c |
| [CVE-2021-3847](https://security-tracker.debian.org/tracker/CVE-2021-3847) | linux-libc-dev | 継続 | affected | kernel: low-privileged user privileges escalation |
| [CVE-2021-3864](https://security-tracker.debian.org/tracker/CVE-2021-3864) | linux-libc-dev | 継続 | affected | kernel: descendant's dumpable setting with certain SUID binaries |
| [CVE-2024-21803](https://security-tracker.debian.org/tracker/CVE-2024-21803) | linux-libc-dev | 継続 | affected | kernel: bluetooth: use-after-free vulnerability in af_bluetooth.c |
| [CVE-2024-21963](https://security-tracker.debian.org/tracker/CVE-2024-21963) | linux-libc-dev | 11-20 に DB 追加 | affected | An out-of-bounds read vulnerability in the IOMMU could allow a malicio ... |
| [CVE-2024-58015](https://security-tracker.debian.org/tracker/CVE-2024-58015) | linux-libc-dev | 継続 | affected | kernel: wifi: ath12k: Fix for out-of bound access error |
| [CVE-2025-69720](https://security-tracker.debian.org/tracker/CVE-2025-69720) | libtinfo6, ncurses-base, ncurses-bin | 継続 | affected | ncurses: ncurses: Buffer overflow vulnerability may lead to arbitrary code execution. |
| [CVE-2026-0004](https://security-tracker.debian.org/tracker/CVE-2026-0004) | linux-libc-dev | 11-20 に DB 追加 | affected | A transient execution vulnerability in some AMD processors may allow a ... |
| [CVE-2026-8458](https://security-tracker.debian.org/tracker/CVE-2026-8458) | libcurl3t64-gnutls | 継続 | affected | curl: libcurl: Unauthorized connection reuse due to a logical error |
| [CVE-2026-9538](https://security-tracker.debian.org/tracker/CVE-2026-9538) | libperl5.40, perl, perl-base, perl-modules-5.40 | 継続 | fix_deferred | perl-Archive-Tar: perl-Archive-Tar: Denial of Service via crafted tar header with large entry size |
| [CVE-2026-12064](https://security-tracker.debian.org/tracker/CVE-2026-12064) | libcurl3t64-gnutls | 継続 | affected | curl: curl: SSH host verification bypass when using schemeless URLs with SFTP/SCP |
| [CVE-2026-16742](https://security-tracker.debian.org/tracker/CVE-2026-16742) | libsystemd0, libudev1 | 継続 | affected | systemd: systemd-homed: Local privilege escalation via missing home-record signature verification |
| [CVE-2026-23102](https://security-tracker.debian.org/tracker/CVE-2026-23102) | linux-libc-dev | 継続 | affected | kernel: Linux kernel: Denial of Service due to incorrect SVE context restoration |
| [CVE-2026-31568](https://security-tracker.debian.org/tracker/CVE-2026-31568) | linux-libc-dev | 継続 | affected | kernel: s390/mm: Add missing secure storage access fixups for donated memory |
| [CVE-2026-46279](https://security-tracker.debian.org/tracker/CVE-2026-46279) | linux-libc-dev | 継続 | affected | kernel: mm/alloc_tag: clear codetag for pages allocated before page_ext initialization |
| [CVE-2026-54369](https://security-tracker.debian.org/tracker/CVE-2026-54369) | libacl1 | 継続 | affected | acl: Symlink traversal privilege escalation via libacl functions |
| [CVE-2026-71199](https://security-tracker.debian.org/tracker/CVE-2026-71199) | libgssapi-krb5-2, libk5crypto3, libkrb5-3, libkrb5support0 | 11-20 に DB 追加 | affected | krb5: Alteration of authentication indicators in CAMMAC container |
| [CVE-2026-71200](https://security-tracker.debian.org/tracker/CVE-2026-71200) | libgssapi-krb5-2, libk5crypto3, libkrb5-3, libkrb5support0 | 11-20 に DB 追加 | affected | krb5: Unauthenticated KDC NULL pointer dereference KDC DoS via crafted PKINIT pre-auth request |
| [CVE-2026-72042](https://security-tracker.debian.org/tracker/CVE-2026-72042) | linux-libc-dev | 継続 | affected | kernel: ipmi: Fix user refcount underflow in event delivery |
| [CVE-2026-76642](https://security-tracker.debian.org/tracker/CVE-2026-76642) | bsdutils, libblkid1, liblastlog2-2, libmount1, libsmartcols1, libuuid1, login, mount, util-linux | 継続 | affected | util-linux: util-linux: failed external mount helper still runs privileged X-mount post-hooks |
| [CVE-2026-78408](https://security-tracker.debian.org/tracker/CVE-2026-78408) | bsdutils, libblkid1, liblastlog2-2, libmount1, libsmartcols1, libuuid1, login, mount, util-linux | 継続 | affected | util-linux: util-linux: nsenter --join-cgroup leaks root cgroup migration authority |
| [CVE-2026-78409](https://security-tracker.debian.org/tracker/CVE-2026-78409) | bsdutils, libblkid1, liblastlog2-2, libmount1, libsmartcols1, libuuid1, login, mount, util-linux | 継続 | affected | util-linux: util-linux: X-mount.subdir detached-tree resolution can escape via intermediate symlinks |
| [CVE-2026-78410](https://security-tracker.debian.org/tracker/CVE-2026-78410) | bsdutils, libblkid1, liblastlog2-2, libmount1, libsmartcols1, libuuid1, login, mount, util-linux | 継続 | affected | util-linux: util-linux: restricted bind mounts do not pin the source, allowing X-mount.owner/group/mode redirection |
| [CVE-2026-89675](https://security-tracker.debian.org/tracker/CVE-2026-89675) | linux-libc-dev | 継続 | affected | kernel: nfsd: fix UAF in async copy cancel and shutdown |
| [CVE-2026-90315](https://security-tracker.debian.org/tracker/CVE-2026-90315) | linux-libc-dev | 継続 | affected | kernel: PCI/sysfs: Add lockdown checks to legacy I/O and memory handlers |
| [CVE-2026-96512](https://security-tracker.debian.org/tracker/CVE-2026-96512) | sudo | 継続 | affected | sudo: sudo: TZ environment variable allows bypass of NOTBEFORE/NOTAFTER time-based authorization |
| [CVE-2026-98118](https://security-tracker.debian.org/tracker/CVE-2026-98118) | linux-libc-dev | 継続 | affected | kernel: netfs: Fix readahead synchronisation issues by loading all folios upfront |
| [CVE-2026-98364](https://security-tracker.debian.org/tracker/CVE-2026-98364) | linux-libc-dev | 継続 | affected | kernel: xfrm: hold net_device reference under RCU in bundle creation |
| [CVE-2026-99272](https://security-tracker.debian.org/tracker/CVE-2026-99272) | linux-libc-dev | 11-20 に DB 追加 | affected | kernel: kernel: out-of-bounds read in SMB client via crafted read response |
| [CVE-2026-99387](https://security-tracker.debian.org/tracker/CVE-2026-99387) | linux-libc-dev | 11-20 に DB 追加 | affected | kernel: kernel: Information disclosure via out-of-bounds read in SMB client |
| [CVE-2026-105437](https://security-tracker.debian.org/tracker/CVE-2026-105437) | git, git-man | 11-20 に DB 追加 | affected | git: git: Heap corruption via integer overflow in merge size calculations |
| [CVE-2026-107364](https://security-tracker.debian.org/tracker/CVE-2026-107364) | libgssapi-krb5-2, libk5crypto3, libkrb5-3, libkrb5support0 | 11-20 に DB 追加 | affected | krb5: Unauthenticated KDC DoS based on ASN.1 decoder read overrun |
| [CVE-2026-111760](https://security-tracker.debian.org/tracker/CVE-2026-111760) | git, git-man | 11-20 に DB 追加 | affected | git: Git: Arbitrary code execution via unsafe submodule metadata during recursive clones |
| [CVE-2026-112315](https://security-tracker.debian.org/tracker/CVE-2026-112315) | libgssapi-krb5-2, libk5crypto3, libkrb5-3, libkrb5support0 | 11-20 に DB 追加 | affected | krb5: MIT krb5 kadmind unauthenticated memory leak DoS in RPCSEC_GSS buffer decode failure |
| [CVE-2026-112316](https://security-tracker.debian.org/tracker/CVE-2026-112316) | libgssapi-krb5-2, libk5crypto3, libkrb5-3, libkrb5support0 | 11-20 に DB 追加 | affected | krb5: MIT krb5 kadmind authenticated memory leak DoS in xdr_krb5_tl_data() decode failure |
| [CVE-2026-112317](https://security-tracker.debian.org/tracker/CVE-2026-112317) | libgssapi-krb5-2, libk5crypto3, libkrb5-3, libkrb5support0 | 11-20 に DB 追加 | affected | krb5: MIT krb5 KDC unauthenticated memory leak DoS in KDB keytab key decryption error path |
| [CVE-2026-112318](https://security-tracker.debian.org/tracker/CVE-2026-112318) | libgssapi-krb5-2, libk5crypto3, libkrb5-3, libkrb5support0 | 11-20 に DB 追加 | affected | krb5: MIT krb5 kadmind authenticated DoS exploiting dereference of null policy name pointers |
| [CVE-2026-112319](https://security-tracker.debian.org/tracker/CVE-2026-112319) | libgssapi-krb5-2, libk5crypto3, libkrb5-3, libkrb5support0 | 11-20 に DB 追加 | affected | krb5: MIT krb5 kadmind authenticated memory exhaustion DoS via unbounded RPC XDR allocation |
| [CVE-2026-112320](https://security-tracker.debian.org/tracker/CVE-2026-112320) | libgssapi-krb5-2, libk5crypto3, libkrb5-3, libkrb5support0 | 11-20 に DB 追加 | affected | krb5: MIT krb5 kadmind unauthenticated memory leak DoS via GSS-RPC auth flavor switching |
| [CVE-2026-112321](https://security-tracker.debian.org/tracker/CVE-2026-112321) | libgssapi-krb5-2, libk5crypto3, libkrb5-3, libkrb5support0 | 11-20 に DB 追加 | affected | krb5: MIT krb5 kadmind unauthenticated memory leak DoS via AUTH_GSSAPI_INIT error paths |
| [CVE-2026-112322](https://security-tracker.debian.org/tracker/CVE-2026-112322) | libgssapi-krb5-2, libk5crypto3, libkrb5-3, libkrb5support0 | 11-20 に DB 追加 | affected | krb5: MIT krb5 kadmind unauthenticated CPU DoS via AUTH_GSSAPI client states cleanup |
| [CVE-2026-112323](https://security-tracker.debian.org/tracker/CVE-2026-112323) | libgssapi-krb5-2, libk5crypto3, libkrb5-3, libkrb5support0 | 11-20 に DB 追加 | affected | krb5: MIT krb5 kadmind unauthenticated memory exhaustion via failed AUTH_GSSAPI_INIT requests |
| [CVE-2026-113351](https://security-tracker.debian.org/tracker/CVE-2026-113351) | libexpat1 | 継続 | affected | expat: expat: Denial of Service via improper memory tracking in XML_ParserReset |
| [CVE-2026-114466](https://security-tracker.debian.org/tracker/CVE-2026-114466) | git, git-man | 11-20 に DB 追加 | affected | git: git: Arbitrary file system access via fast-import features |
| [CVE-2026-115506](https://security-tracker.debian.org/tracker/CVE-2026-115506) | libexpat1 | 11-20 に DB 追加 | affected | expat: expat: Denial of Service via delayed entity amplification detection |
| [CVE-2026-117610](https://security-tracker.debian.org/tracker/CVE-2026-117610) | libexpat1 | 継続 | affected | expat: expat: Denial of Service via NULL pointer dereference in external entity parsing |
| [CVE-2026-118370](https://security-tracker.debian.org/tracker/CVE-2026-118370) | libexpat1 | 継続 | affected | expat: expat: Denial of Service via integer overflow during XML attribute parsing |
| [CVE-2026-118380](https://security-tracker.debian.org/tracker/CVE-2026-118380) | libgssapi-krb5-2, libk5crypto3, libkrb5-3, libkrb5support0 | 11-20 に DB 追加 | affected | krb5: kadmind: request alteration and protected information disclosure |
| [CVE-2026-119079](https://security-tracker.debian.org/tracker/CVE-2026-119079) | libgssapi-krb5-2, libk5crypto3, libkrb5-3, libkrb5support0 | 11-20 に DB 追加 | affected | krb5: MIT krb5 KDC unauthenticated CPU DoS via quadratic ASN.1 SEQUENCE OF decoding |
| [CVE-2026-119373](https://security-tracker.debian.org/tracker/CVE-2026-119373) | libsqlite3-0 | 継続 | affected | sqlite: sqlite: Denial of service via heap-based buffer overflow in FTS5 |
| [CVE-2026-119374](https://security-tracker.debian.org/tracker/CVE-2026-119374) | libsqlite3-0 | 11-20 に DB 追加 | affected | sqlite: sqlite: Arbitrary code execution via corrupted FTS5 index |
| [CVE-2026-119379](https://security-tracker.debian.org/tracker/CVE-2026-119379) | libsqlite3-0 | 11-20 に DB 追加 | affected | sqlite: sqlite: Arbitrary code execution via crafted session changesets |

## 2026-11-05 の記録（履歴）

検査日 2026-11-05 / Trivy 0.76.2 / Debian 13.7 / `ruby:4.0.9-slim-trixie`。Critical 0 件、High 75 件（37 CVE）、修正版の提供 0 件。生の結果は [container-audit.json](container-audit.json)。元の MCR イメージの 451 件から削減し、修正可能だった JSON の Critical を解消した。期限 2026-11-12 に失効し、上記の再評価で置き換えた。
