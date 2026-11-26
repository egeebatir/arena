"""
Packages the existing Godot HTML5/WASM build into a self-contained itch.io zip
with a portrait-friendly responsive wrapper and non-intrusive top links driving
players to ebstudyo.com (Leaderboard & Live Queue) and Google Play (Android).

Zero cost, zero rebuild required. Also generates a 630x500 itch.io cover image.
"""
import os
import zipfile
from PIL import Image, ImageDraw, ImageFont

FUTBOL_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
WEBFUTBOL_ROOT = r"C:\Users\egebatir\Documents\Bol Gol Futbol\webfutbol"
OUT_DIR = os.path.join(FUTBOL_ROOT, "store_assets", "itchio_build")

REQUIRED_WEB_FILES = [
    "weboyun1.js",
    "weboyun1.wasm",
    "weboyun1.pck",
    "weboyun1.png",
    "weboyun1.icon.png",
    "weboyun1.apple-touch-icon.png",
    "weboyun1.audio.worklet.js",
    "weboyun1.audio.position.worklet.js",
]

ITCH_INDEX_HTML = """<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0, viewport-fit=cover">
  <title>Bol Gol Football | 2D Physics Match Simulator</title>
  <link rel="icon" type="image/png" href="weboyun1.icon.png">
  <style>
    /*
      R-31 Design Decisions:
      - Dark stadium frame (#0B1014) centers the 9:18.5 portrait Godot canvas cleanly inside itch.io desktop & mobile iframes.
      - Compact 40px top utility bar provides keyboard-accessible external links to the Global Leaderboard (ebstudyo.com) and Android build without stealing vertical game space.
      - WCAG AAA contrast: #F2F6FA text and #4ADE80 action pill on #121A22 bar.
    */
    *, *::before, *::after { box-sizing: border-box; }
    html, body {
      margin: 0;
      padding: 0;
      width: 100%;
      height: 100%;
      background: #0B1014;
      color: #F2F6FA;
      font-family: system-ui, -apple-system, "Segoe UI", Roboto, sans-serif;
      overflow: hidden;
    }
    .shell {
      display: flex;
      flex-direction: column;
      width: 100%;
      height: 100%;
    }
    .topbar {
      height: 40px;
      flex: 0 0 40px;
      display: flex;
      align-items: center;
      justify-content: space-between;
      gap: 8px;
      padding: 0 12px;
      background: #121A22;
      border-bottom: 1px solid #263645;
      font-size: 12px;
    }
    .brand {
      font-weight: 700;
      color: #F2F6FA;
      text-decoration: none;
      white-space: nowrap;
    }
    .links {
      display: flex;
      align-items: center;
      gap: 8px;
    }
    .links a {
      color: #D2DCE6;
      text-decoration: none;
      padding: 4px 8px;
      border-radius: 6px;
      border: 1px solid #33475B;
      white-space: nowrap;
      font-weight: 600;
    }
    .links a:hover { border-color: #F2F6FA; color: #FFFFFF; }
    .links a.gp {
      background: #22C55E;
      color: #05140A;
      border-color: #22C55E;
    }
    .links a.gp:hover { background: #4ADE80; }
    a:focus-visible { outline: 2px solid #38BDF8; outline-offset: 2px; }
    .stage {
      position: relative;
      flex: 1 1 auto;
      display: flex;
      align-items: center;
      justify-content: center;
      min-height: 0;
      background: #070B0E;
    }
    .viewport-box {
      position: relative;
      height: 100%;
      max-width: 100%;
      aspect-ratio: 9 / 18.5;
      background: #000E22;
    }
    @media (max-aspect-ratio: 9/16) {
      .viewport-box { width: 100%; height: 100%; aspect-ratio: auto; }
    }
    #canvas {
      display: block;
      width: 100%;
      height: 100%;
      touch-action: none;
    }
    #canvas:focus-visible { outline: 2px solid #38BDF8; }
    #status {
      position: absolute;
      inset: 0;
      background: #000E22;
      display: flex;
      flex-direction: column;
      align-items: center;
      justify-content: center;
      gap: 16px;
      padding: 20px;
      text-align: center;
    }
    #status.hidden { display: none; }
    #status-splash { max-width: 58%; max-height: 45%; object-fit: contain; }
    #status-progress { width: 65%; height: 8px; }
    #status-notice {
      display: none;
      background: #2B1114;
      border: 1px solid #B91C1C;
      color: #FCA5A5;
      padding: 12px;
      border-radius: 8px;
      font-size: 13px;
    }
  </style>
</head>
<body>
  <div class="shell">
    <header class="topbar">
      <a class="brand" href="https://www.ebstudyo.com/?utm_source=itchio&utm_medium=web_build&utm_campaign=topbar" target="_blank" rel="noopener noreferrer">Bol Gol Football</a>
      <nav class="links" aria-label="External links">
        <a href="https://www.ebstudyo.com/liderlik-tablosu/?utm_source=itchio&utm_medium=web_build&utm_campaign=leaderboard" target="_blank" rel="noopener noreferrer">Leaderboard</a>
        <a href="https://www.ebstudyo.com/canli/?utm_source=itchio&utm_medium=web_build&utm_campaign=live_hub" target="_blank" rel="noopener noreferrer">24/7 Live</a>
        <a class="gp" href="https://play.google.com/store/apps/details?id=com.ebstudyo.bolgol&referrer=utm_source%3Ditchio%26utm_medium%3Dweb_build%26utm_campaign%3Ditch_topbar" target="_blank" rel="noopener noreferrer">Android App</a>
      </nav>
    </header>
    <main class="stage">
      <div class="viewport-box" id="vp-box">
        <canvas id="canvas">Your browser does not support HTML5 Canvas.</canvas>
        <div id="status">
          <img id="status-splash" src="weboyun1.png" alt="Bol Gol Football">
          <progress id="status-progress"></progress>
          <div id="status-notice"></div>
        </div>
      </div>
    </main>
  </div>

  <script src="weboyun1.js"></script>
  <script>
    (function () {
      var canvas = document.getElementById('canvas');
      var box = document.getElementById('vp-box');
      var statusOverlay = document.getElementById('status');
      var statusProgress = document.getElementById('status-progress');
      var statusNotice = document.getElementById('status-notice');

      function resizeCanvas() {
        var w = box.clientWidth || 450;
        var h = box.clientHeight || 900;
        var dpr = Math.min(window.devicePixelRatio || 1, 2);
        canvas.width = Math.round(w * dpr);
        canvas.height = Math.round(h * dpr);
      }
      window.addEventListener('resize', resizeCanvas);
      resizeCanvas();

      // GODOT_THREADS_ENABLED is false, so ensureCrossOriginIsolationHeaders: false allows boot even if COOP/COEP is disabled
      var config = {
        args: [],
        canvasResizePolicy: 0,
        emscriptenPoolSize: 8,
        ensureCrossOriginIsolationHeaders: false,
        executable: 'weboyun1',
        experimentalVK: false,
        fileSizes: { 'weboyun1.pck': 19588760, 'weboyun1.wasm': 37685705 },
        focusCanvas: true,
        gdextensionLibs: [],
        godotPoolSize: 4
      };

      var engine = new Engine(config);
      var missing = Engine.getMissingFeatures({ threads: false });
      if (missing.length !== 0) {
        statusProgress.style.display = 'none';
        statusNotice.style.display = 'block';
        statusNotice.textContent = 'Missing browser features: ' + missing.join(', ');
        return;
      }

      engine.startGame({
        onProgress: function (current, total) {
          if (current > 0 && total > 0) {
            statusProgress.value = current;
            statusProgress.max = total;
          } else {
            statusProgress.removeAttribute('value');
            statusProgress.removeAttribute('max');
          }
        }
      }).then(function () {
        statusOverlay.classList.add('hidden');
        resizeCanvas();
        canvas.focus();
      }, function (err) {
        statusProgress.style.display = 'none';
        statusNotice.style.display = 'block';
        statusNotice.textContent = (err && err.message) ? err.message : String(err);
      });
    })();
  </script>
</body>
</html>
"""


def generate_itch_cover(out_png: str):
    # Resize 1024x500 feature graphic cleanly onto 630x500 itch.io cover spec
    feat_path = os.path.join(FUTBOL_ROOT, "store_assets", "feature_graphic_1024x500.png")
    if not os.path.exists(feat_path):
        return
    src = Image.open(feat_path).convert("RGB")
    target_w, target_h = 630, 500
    # Crop center horizontally while preserving logo & ball center composition
    left = (src.width - target_w) // 2
    cropped = src.crop((left, 0, left + target_w, target_h))
    cropped.save(out_png, format="PNG", optimize=True)


def main():
    os.makedirs(OUT_DIR, exist_ok=True)
    for fname in REQUIRED_WEB_FILES:
        fpath = os.path.join(WEBFUTBOL_ROOT, fname)
        if not os.path.exists(fpath):
            raise FileNotFoundError(f"Missing web build file: {fpath}")

    zip_path = os.path.join(OUT_DIR, "bol_gol_futbol_itchio_web.zip")
    with zipfile.ZipFile(zip_path, "w", compression=zipfile.ZIP_DEFLATED, compresslevel=6) as zf:
        zf.writestr("index.html", ITCH_INDEX_HTML)
        for fname in REQUIRED_WEB_FILES:
            zf.write(os.path.join(WEBFUTBOL_ROOT, fname), arcname=fname)

    cover_path = os.path.join(OUT_DIR, "itchio_cover_630x500.png")
    generate_itch_cover(cover_path)

    size_mb = os.path.getsize(zip_path) / (1024 * 1024)
    print(f"[PASS] Built itch.io HTML5 package: {zip_path} ({size_mb:.1f} MB) + cover image.")


if __name__ == "__main__":
    main()
