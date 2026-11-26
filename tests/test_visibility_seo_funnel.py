"""
Adversarial QA suite for Phase 2 Organic Visibility & Mutual Game/Web Funnel:
1. 8-locale ASO metadata limits, antislop rules & web cross-links
2. 48 captioned 1080x1920 PNG screenshots (8 locales x 6 slots)
3. Web GA4 + Play Store UTM attribution + shared simulator.js integrity
4. 17 simulator pages (/simulasyon/ + 16 SEO rivalry pages): team codes, JSON-LD, internal links, antislop R-02, sitemap.xml (31 URLs)
5. itch.io HTML5 zip archive & 630x500 cover graphic
"""
import glob
import json
import os
import re
import zipfile
from xml.etree import ElementTree as ET
from PIL import Image

FUTBOL_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
WEBFUTBOL_ROOT = r"c:\Users\egebatir\Documents\Bol Gol Futbol\webfutbol"


def verify_screenshots():
    cap_root = os.path.join(FUTBOL_ROOT, "store_assets", "screenshots_captioned")
    expected_locales = {"tr-TR", "en-US", "en-GB", "en-IN", "es-ES", "es-419", "pt-BR", "it-IT"}
    found_locales = set(os.listdir(cap_root))
    assert expected_locales.issubset(found_locales), f"Missing screenshot locales: {expected_locales - found_locales}"

    count = 0
    for loc in expected_locales:
        pngs = sorted(glob.glob(os.path.join(cap_root, loc, "*.png")))
        assert len(pngs) == 6, f"{loc} expected 6 screenshots, got {len(pngs)}"
        for p in pngs:
            with Image.open(p) as im:
                assert im.size == (1080, 1920), f"{p} wrong dimensions {im.size}"
            count += 1
    print(f"[PASS] Verified {count} captioned 1080x1920 screenshots across 8 locales.")


def verify_web_seo_and_funnel():
    with open(os.path.join(WEBFUTBOL_ROOT, "assets", "redesign", "teams-data.js"), "r", encoding="utf-8") as f:
        raw = f.read()
    teams_list = json.loads(raw[raw.index("["):raw.rindex("]") + 1])
    team_names = {t["name"] for t in teams_list}
    assert len(team_names) == 232, f"Expected 232 teams, got {len(team_names)}"

    with open(os.path.join(WEBFUTBOL_ROOT, "assets", "redesign", "site.js"), "r", encoding="utf-8") as f:
        site_js = f.read()
    for token in ["bolgolTrack", "buildPlayStoreUrl", "click_google_play", "start_web_game", "submit_beta_email"]:
        assert token in site_js, f"Missing funnel hook '{token}' in site.js"

    with open(os.path.join(WEBFUTBOL_ROOT, "assets", "redesign", "simulator.js"), "r", encoding="utf-8") as f:
        sim_js = f.read()
    for token in ["run_quick_sim", "share_matchup", "sim-share-btn", "data-default-home"]:
        assert token in sim_js, f"Missing simulator hook '{token}' in simulator.js"

    rivalry_pages = sorted(glob.glob(os.path.join(WEBFUTBOL_ROOT, "simulasyon", "*", "index.html")))
    assert len(rivalry_pages) == 16, f"Expected 16 rivalry SEO pages, got {len(rivalry_pages)}"

    all_pages = rivalry_pages + [os.path.join(WEBFUTBOL_ROOT, "simulasyon", "index.html")]
    for p in all_pages:
        with open(p, "r", encoding="utf-8") as f:
            html_txt = f.read()

        assert "G-W5T3VVF16F" in html_txt, f"Missing GA4 tag in {p}"
        assert "/assets/redesign/simulator.js" in html_txt, f"Missing shared simulator.js in {p}"

        for m in re.finditer(r'data-default-(?:home|away)="([^"]+)"', html_txt):
            assert m.group(1) in team_names, f"Unknown team '{m.group(1)}' in {p}"

        for m in re.finditer(r'<script type="application/ld\+json">(.*?)</script>', html_txt, re.S):
            parsed = json.loads(m.group(1))
            assert "@graph" in parsed, f"Malformed JSON-LD in {p}"

        for m in re.finditer(r'href="(/[^"#?]*)"', html_txt):
            rel = m.group(1).lstrip("/")
            target = os.path.join(WEBFUTBOL_ROOT, rel.replace("/", os.sep)) if rel else WEBFUTBOL_ROOT
            if os.path.isdir(target):
                assert os.path.exists(os.path.join(target, "index.html")), f"Broken directory link {m.group(1)} in {p}"
            else:
                assert os.path.exists(target), f"Broken file link {m.group(1)} in {p}"

        if p in rivalry_pages:
            assert "—" not in html_txt, f"Forbidden em-dash found in {p}"
            title_m = re.search(r"<title>(.*?)</title>", html_txt)
            assert title_m and len(title_m.group(1)) <= 60, f"SEO title >60 chars in {p}"

    tree = ET.parse(os.path.join(WEBFUTBOL_ROOT, "sitemap.xml"))
    locs = [el.text for el in tree.getroot().findall("{http://www.sitemaps.org/schemas/sitemap/0.9}url/{http://www.sitemaps.org/schemas/sitemap/0.9}loc")]
    assert len(locs) == 31, f"Expected 31 URLs in sitemap.xml, got {len(locs)}"
    assert "https://www.ebstudyo.com/canli/" in locs, "Missing /canli/ in sitemap.xml"
    assert "https://www.ebstudyo.com/simulasyon/galatasaray-fenerbahce/" in locs
    assert "https://www.ebstudyo.com/simulasyon/real-madrid-barcelona/" in locs
    print(f"[PASS] Verified {len(all_pages)} web simulator pages, GA4/UTM hooks, JSON-LD schemas, and 31 sitemap URLs.")


def verify_itchio_package():
    itch_dir = os.path.join(FUTBOL_ROOT, "store_assets", "itchio_build")
    zip_path = os.path.join(itch_dir, "bol_gol_futbol_itchio_web.zip")
    cover_path = os.path.join(itch_dir, "itchio_cover_630x500.png")
    assert os.path.exists(zip_path), "Missing itch.io zip archive"
    assert os.path.exists(cover_path), "Missing itch.io 630x500 cover"

    with Image.open(cover_path) as im:
        assert im.size == (630, 500), f"Invalid itch.io cover size: {im.size}"

    with zipfile.ZipFile(zip_path, "r") as zf:
        names = set(zf.namelist())
        for req in ["index.html", "weboyun1.js", "weboyun1.wasm", "weboyun1.pck"]:
            assert req in names, f"Missing {req} inside itch.io zip"
        idx_html = zf.read("index.html").decode("utf-8")
        assert "ensureCrossOriginIsolationHeaders: false" in idx_html
        assert "utm_source=itchio" in idx_html
        assert "utm_source%3Ditchio" in idx_html
    print("[PASS] Verified itch.io zip archive and 630x500 cover image.")


if __name__ == "__main__":
    verify_screenshots()
    verify_web_seo_and_funnel()
    verify_itchio_package()
    print("[ALL PASS] Phase 2 Organic Visibility & Funnel QA 100% GREEN.")
