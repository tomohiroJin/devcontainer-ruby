import copy
import datetime
import unittest

from check_container_audit import evaluate


class AuditPolicyTests(unittest.TestCase):
    def setUp(self):
        self.today = datetime.date(2026, 11, 6)
        self.finding = dict(
            VulnerabilityID="CVE-example",
            PkgName="libexample",
            InstalledVersion="1",
            Severity="HIGH",
        )
        self.result = {
            "Class": "os-pkgs",
            "Type": "debian",
            "Vulnerabilities": [self.finding],
        }
        self.report = {
            "Metadata": {"OS": {"Family": "debian"}},
            "Results": [self.result],
        }
        entry = dict(
            self.finding,
            Class="os-pkgs",
            Type="debian",
            kind="unfixed",
            reason="Vendor has no fix",
        )
        self.baseline = dict(
            owner="maintainer",
            tracking_issue="issue",
            review_due="2026-11-12",
            findings=[entry],
        )

    def test_known_unfixed_is_reported(self):
        blocked, accepted = evaluate(self.report, self.baseline, self.today)
        self.assertFalse(blocked)
        self.assertEqual(len(accepted), 1)

    def test_new_vulnerability_blocks(self):
        self.finding["VulnerabilityID"] = "CVE-new"
        self.assertTrue(evaluate(self.report, self.baseline, self.today)[0])

    def test_fix_available_blocks(self):
        self.finding["FixedVersion"] = "2"
        self.assertTrue(evaluate(self.report, self.baseline, self.today)[0])

    def test_version_or_severity_change_requires_review(self):
        for field, value in [("InstalledVersion", "2"), ("Severity", "CRITICAL")]:
            report = copy.deepcopy(self.report)
            report["Results"][0]["Vulnerabilities"][0][field] = value
            self.assertTrue(evaluate(report, self.baseline, self.today)[0])

    def test_expiry_blocks_remaining_reviewed_findings(self):
        blocked, accepted = evaluate(self.report, self.baseline, datetime.date(2026, 11, 12))
        self.assertFalse(accepted)
        self.assertIn("expired", blocked[0])

    def test_clean_scan_passes_after_expiry(self):
        self.result["Vulnerabilities"] = []
        self.assertEqual(
            evaluate(self.report, self.baseline, datetime.date(2026, 11, 12)),
            ([], []),
        )

    def test_changed_finding_still_blocks_after_expiry(self):
        self.finding["VulnerabilityID"] = "CVE-new"
        self.assertTrue(evaluate(self.report, self.baseline, datetime.date(2026, 11, 12))[0])

    def test_missing_scan_results_fails_closed(self):
        with self.assertRaises(ValueError):
            evaluate({}, self.baseline, self.today)

    def test_unsupported_kind_fails_closed(self):
        self.baseline["findings"][0]["kind"] = "pip-sbom-only"
        with self.assertRaises(ValueError):
            evaluate(self.report, self.baseline, self.today)


if __name__ == "__main__":
    unittest.main()
