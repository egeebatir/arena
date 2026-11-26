"""
Adversarial QA validator for Google Play ASO store listings (8 locales).
Enforces Google Play character limits, antislop copywriting rules, accurate game counts,
and mutual web-to-app cross-promotion links.
"""
import json
import os
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
ASO_PATH = os.path.join(ROOT, "store_assets", "aso_listings.json")

EXPECTED_LOCALES = {"tr-TR", "en-US", "en-GB", "en-IN", "es-ES", "es-419", "pt-BR", "it-IT"}

BANNED_BUZZWORDS = [
    "seamless", "revolutionary", "cutting-edge", "cutting edge", "next-generation",
    "next generation", "game-changer", "game changer", "elevate", "unlock the power",
    "delve", "testament", "pivotal moment", "world-class"
]


def main():
    assert os.path.exists(ASO_PATH), f"Missing {ASO_PATH}"
    with open(ASO_PATH, "r", encoding="utf-8") as f:
        data = json.load(f)

    assert data.get("package_name") == "com.ebstudyo.bolgol", "Package name mismatch"
    locales = data.get("locales", {})
    assert set(locales.keys()) == EXPECTED_LOCALES, f"Locale mismatch: {set(locales.keys())} != {EXPECTED_LOCALES}"

    for lang, item in locales.items():
        title = item["title"]
        short_d = item["shortDescription"]
        full_d = item["fullDescription"]

        assert 10 <= len(title) <= 30, f"{lang} title out of range ({len(title)}/30): {title}"
        assert 40 <= len(short_d) <= 80, f"{lang} shortDescription out of range ({len(short_d)}/80): {short_d}"
        assert 900 <= len(full_d) <= 4000, f"{lang} fullDescription out of range ({len(full_d)}/4000)"

        combined = f"{title}\n{short_d}\n{full_d}"
        assert "—" not in combined, f"{lang} contains forbidden em-dash"
        assert "--" not in combined, f"{lang} contains forbidden double-hyphen"

        low = combined.lower()
        for bw in BANNED_BUZZWORDS:
            assert bw not in low, f"{lang} contains banned AI buzzword '{bw}'"

        assert "232" in combined, f"{lang} missing verified 232 team count"
        assert "46" in combined, f"{lang} missing verified 46 national team count"
        assert "ebstudyo.com/liderlik-tablosu" in full_d, f"{lang} missing leaderboard web funnel"

    print(f"[PASS] All {len(locales)} ASO locales verified (limits, antislop, facts, web bridge).")


if __name__ == "__main__":
    main()
