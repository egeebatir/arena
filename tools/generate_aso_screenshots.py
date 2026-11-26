"""
Captioned Google Play Screenshot Generator (1080x1920, 9:16 Portrait) for 8 Locales.

Antislop & R-31 Design Decisions:
- Purpose of Frame: Google Play search results display the first 2-3 portrait screenshots at small thumbnail scale; a high-contrast top headline communicates core mechanics (2D physics, 232 teams, offline play) in <1 second while leading with live match action.
- Palette (R-25, R-29): Deep stadium slate (#0B1218) header, pure white (#FFFFFF, 18.6:1 contrast) headline, pitch green (#4ADE80, 10.2:1 contrast) subline, subtle 3px (#263645) device frame border. Zero purple/blue gradients, zero glow soup, zero decorative badges.
- Typography (R-06): Teko-Bold (matches in-game display identity) for short uppercase headline; Segoe UI Semibold/Bold for crisp multilingual subline legibility.
- Regional Relevance: tr-TR leads with FEN vs GAL derby at Slot #1; global locales lead with PSG vs RMA (#1) and LIV vs RMA (#2).
"""
import os
from PIL import Image, ImageDraw, ImageFont, ImageFilter

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
RAW_DIR = os.path.join(ROOT, "store_assets", "screenshots")
OUT_DIR = os.path.join(ROOT, "store_assets", "screenshots_captioned")

CANVAS_W = 1080
CANVAS_H = 1920
HEADER_H = 290

BG_TOP = (11, 18, 24)        # #0B1218
BG_BOTTOM = (16, 26, 35)     # #101A23
TEXT_WHITE = (255, 255, 255) # #FFFFFF (18.6:1 on #0B1218)
TEXT_ACCENT = (74, 222, 128) # #4ADE80 (10.2:1 on #0B1218)
FRAME_BORDER = (46, 66, 84)  # #2E4254

FONT_HEADLINE_CANDIDATES = [
    os.path.join(ROOT, "Teko-Bold.ttf"),
    r"C:\Windows\Fonts\segoeuib.ttf",
    r"C:\Windows\Fonts\arialbd.ttf",
]
FONT_SUB_CANDIDATES = [
    r"C:\Windows\Fonts\segoeuib.ttf",
    r"C:\Windows\Fonts\arialbd.ttf",
    os.path.join(ROOT, "Teko-SemiBold.ttf"),
]

# Slot definitions per locale group: (raw_folder, raw_filename, out_slug)
SLOTS_TR = [
    ("tr-TR", "05_match_fb_gs_obsidian.png", "01_live_derby_physics.png"),
    ("tr-TR", "07_match_psg_rma_lava.png", "02_european_giants.png"),
    ("tr-TR", "01_home_match_setup.png", "03_232_teams_8_leagues.png"),
    ("tr-TR", "06_match_bjk_ts_ice.png", "04_dynamic_match_events.png"),
    ("tr-TR", "02_stats_career.png", "05_career_and_leaderboard.png"),
    ("tr-TR", "04_lucky_wheel.png", "06_daily_rewards_skins.png"),
]

SLOTS_GLOBAL = [
    ("en-IN", "07_match_psg_rma_lava.png", "01_live_match_physics.png"),
    ("en-IN", "01_home_match_setup.png", "02_232_teams_8_leagues.png"),
    ("en-IN", "05_match_fb_gs_obsidian.png", "03_intense_derby_sim.png"),
    ("en-IN", "02_stats_career.png", "04_career_and_leaderboard.png"),
    ("en-IN", "03_shop_cosmetics.png", "05_custom_balls_crowns.png"),
    ("en-IN", "04_lucky_wheel.png", "06_daily_wheel_offline.png"),
]

CAPTIONS = {
    "tr-TR": [
        ("GERÇEK 2D FİZİK MOTORU", "36 saniyede bol gollü derbi simülasyonları"),
        ("AVRUPA VE DÜNYA DEVLERİ", "Şampiyonlar sahnesi cebinde, internetsiz oyna"),
        ("232 TAKIM VE 46 MİLLİ TAKIM", "8 dünya liginden istediğin eşleşmeyi kur"),
        ("PENALTI BONUSU VE KARTLAR", "Son dakika geri dönüşleri ve dinamik uzatmalar"),
        ("KÜRESEL LİDERLİK TABLOSU", "Kaptanını seç, gollerini ebstudyo.com'a taşı"),
        ("ÖZEL TOPLAR VE ŞANS ÇARKI", "Obsidyen, Lav, Buz topları ve günlük görevler"),
    ],
    "en-US": [
        ("REAL 2D PHYSICS SOCCER", "Unscripted 36-second circular arena matches"),
        ("232 CLUBS & 46 NATIONS", "Build any matchup across 8 world leagues"),
        ("HIGH-SCORING DERBY CLASHES", "Cards, rotating goals & 3s Penalty Bonus"),
        ("GLOBAL CLUB LEADERBOARD", "Name your captain & sync goals at ebstudyo.com"),
        ("CUSTOM BALLS & CROWNS", "Unlock Lava, Ice, Neon & Obsidian skins"),
        ("PLAY OFFLINE ANYTIME", "Daily quests, Lucky Wheel & zero Wi-Fi needed"),
    ],
    "en-GB": [
        ("REAL 2D PHYSICS FOOTBALL", "Unscripted 36-second circular arena matches"),
        ("232 CLUBS & 46 NATIONS", "Create any fixture across 8 world leagues"),
        ("FAST-PACED DERBY DRAMA", "Cards, rotating goals & 3s Penalty Bonus"),
        ("GLOBAL CLUB LEADERBOARD", "Name your captain & sync goals at ebstudyo.com"),
        ("CUSTOM BALLS & CROWNS", "Unlock Lava, Ice, Neon & Obsidian designs"),
        ("PLAY OFFLINE ANYTIME", "Daily quests, Lucky Wheel & no data needed"),
    ],
    "en-IN": [
        ("REAL 2D PHYSICS FOOTBALL", "Fast 36-second circular arena match simulator"),
        ("232 CLUBS & 46 NATIONS", "Play dream fixtures across 8 world leagues"),
        ("UNPREDICTABLE DERBY GOALS", "Cards, rotating goals & 3s Penalty Bonus"),
        ("GLOBAL FAN LEADERBOARD", "Set your captain & sync goals at ebstudyo.com"),
        ("UNLOCK BALLS & CROWNS", "Collect Lava, Ice, Gold & Obsidian skins"),
        ("100% OFFLINE READY", "Lightweight build with Daily Quests & Wheel"),
    ],
    "es-ES": [
        ("FÍSICA 2D EN TIEMPO REAL", "Partidos verticales de 36 s llenos de goles"),
        ("232 CLUBES Y 46 SELECCIONES", "Crea cualquier clásico en 8 ligas mundiales"),
        ("REMONTADAS Y BONO PENALTI", "Tarjetas, tiempo añadido y porterías móviles"),
        ("RANKING MUNDIAL DE CLUBES", "Elige capitán y suma goles en ebstudyo.com"),
        ("BALONES Y CORONAS ÚNICAS", "Desbloquea Lava, Hielo, Neón y Obsidiana"),
        ("JUEGA OFFLINE SIN DATOS", "Misiones diarias y Ruleta sin conexión"),
    ],
    "es-419": [
        ("FÍSICA 2D EN TIEMPO REAL", "Partidos rápidos de 36 s llenos de goles"),
        ("232 CLUBES Y 46 SELECCIONES", "Arma cualquier clásico en 8 ligas del mundo"),
        ("REMONTADAS Y BONO DE PENAL", "Tarjetas, alargue dinámico y arcos móviles"),
        ("RANKING MUNDIAL DE HINCHADAS", "Pon tu nombre de capitán y sube en ebstudyo.com"),
        ("BALONES Y CORONAS", "Consigue diseños Lava, Hielo, Oro y Obsidiana"),
        ("JUEGA OFFLINE SIN INTERNET", "Partidas al instante con una sola mano"),
    ],
    "pt-BR": [
        ("FÍSICA 2D EM TEMPO REAL", "Partidas rápidas de 36s cheias de gols"),
        ("232 CLUBES E 46 SELEÇÕES", "Simule qualquer clássico em 8 ligas mundiais"),
        ("VIRADAS E BÔNUS DE PÊNALTI", "Cartões, acréscimos e gols em movimento"),
        ("RANKING MUNDIAL DE TORCIDAS", "Seja o capitão e some gols em ebstudyo.com"),
        ("BOLAS E COROAS ESPECIAIS", "Desbloqueie Lava, Gelo, Neon e Obsidiana"),
        ("JOGUE OFFLINE SEM INTERNET", "Missões diárias e Roleta em qualquer lugar"),
    ],
    "it-IT": [
        ("FISICA 2D IN TEMPO REALE", "Sfide verticali da 36 secondi ricche di gol"),
        ("232 CLUB E 46 NAZIONALI", "Crea qualsiasi derby in 8 campionati mondiali"),
        ("RIMONTE E BONUS RIGORE", "Cartellini, recupero dinamico e porte mobili"),
        ("CLASSIFICA MONDIALE CLUB", "Scegli il capitano e scala ebstudyo.com"),
        ("PALLONI E CORONE SPECIALI", "Sblocca Lava, Ghiaccio, Neon e Ossidiana"),
        ("GIOCA OFFLINE OVUNQUE", "Missioni giornaliere e Ruota senza rete dati"),
    ],
}


def load_font(candidates, size):
    for path in candidates:
        if os.path.exists(path):
            return ImageFont.truetype(path, size)
    return ImageFont.load_default()


def make_vertical_bg(w, h, top_rgb, bot_rgb):
    base = Image.new("RGB", (w, h), top_rgb)
    draw = ImageDraw.Draw(base)
    for y in range(h):
        t = y / max(1, h - 1)
        r = int(top_rgb[0] + (bot_rgb[0] - top_rgb[0]) * t)
        g = int(top_rgb[1] + (bot_rgb[1] - top_rgb[1]) * t)
        b = int(top_rgb[2] + (bot_rgb[2] - top_rgb[2]) * t)
        draw.line([(0, y), (w, y)], fill=(r, g, b))
    return base


def fit_font(draw, text, candidates, start_size, min_size, max_width):
    size = start_size
    while size >= min_size:
        font = load_font(candidates, size)
        bbox = draw.textbbox((0, 0), text, font=font)
        if (bbox[2] - bbox[0]) <= max_width:
            return font
        size -= 2
    return load_font(candidates, min_size)


def rounded_mask(size, radius):
    mask = Image.new("L", size, 0)
    d = ImageDraw.Draw(mask)
    d.rounded_rectangle([0, 0, size[0] - 1, size[1] - 1], radius=radius, fill=255)
    return mask


def render_card(raw_path: str, out_path: str, headline: str, subline: str):
    canvas = make_vertical_bg(CANVAS_W, CANVAS_H, BG_TOP, BG_BOTTOM)
    draw = ImageDraw.Draw(canvas)

    max_text_w = CANVAS_W - 100
    # Use Segoe UI Bold when Turkish dotted capital İ or romance accents need crisp rendering if Teko lacks any glyph,
    # Note: Teko-Bold supports Latin-Ext, but let's check width cleanly.
    h_font = fit_font(draw, headline, FONT_HEADLINE_CANDIDATES, start_size=82, min_size=52, max_width=max_text_w)
    s_font = fit_font(draw, subline, FONT_SUB_CANDIDATES, start_size=36, min_size=26, max_width=max_text_w)

    hb = draw.textbbox((0, 0), headline, font=h_font)
    hw, hh = hb[2] - hb[0], hb[3] - hb[1]
    hx = (CANVAS_W - hw) // 2 - hb[0]
    hy = 56 - hb[1]
    draw.text((hx, hy), headline, font=h_font, fill=TEXT_WHITE)

    sb = draw.textbbox((0, 0), subline, font=s_font)
    sw, sh = sb[2] - sb[0], sb[3] - sb[1]
    sx = (CANVAS_W - sw) // 2 - sb[0]
    sy = 56 + hh + 22 - sb[1]
    draw.text((sx, sy), subline, font=s_font, fill=TEXT_ACCENT)

    # Place rounded device screenshot cleanly below header with generous bottom breathing room
    raw = Image.open(raw_path).convert("RGBA")
    avail_h = CANVAS_H - HEADER_H - 46
    avail_w = CANVAS_W - 110
    scale = min(avail_w / raw.width, avail_h / raw.height)
    target_w = int(round(raw.width * scale))
    target_h = int(round(raw.height * scale))
    resized = raw.resize((target_w, target_h), Image.Resampling.LANCZOS)

    radius = 34
    mask = rounded_mask((target_w, target_h), radius)

    px = (CANVAS_W - target_w) // 2
    py = HEADER_H + (avail_h - target_h) // 2

    # Single subtle elevation shadow (R-12: hierarchy separation between phone frame and dark slate canvas)
    shadow = Image.new("RGBA", (target_w + 40, target_h + 40), (0, 0, 0, 0))
    sd = ImageDraw.Draw(shadow)
    sd.rounded_rectangle([20, 24, 20 + target_w, 24 + target_h], radius=radius, fill=(0, 0, 0, 135))
    shadow = shadow.filter(ImageFilter.GaussianBlur(radius=12))
    canvas.paste(shadow.convert("RGB"), (px - 20, py - 16), shadow.split()[3])

    # Subtle 3px device border frame
    border_box = [px - 3, py - 3, px + target_w + 2, py + target_h + 2]
    draw.rounded_rectangle(border_box, radius=radius + 3, fill=FRAME_BORDER)

    canvas.paste(resized.convert("RGB"), (px, py), mask)

    os.makedirs(os.path.dirname(out_path), exist_ok=True)
    canvas.save(out_path, format="PNG", optimize=True)


def generate_all():
    total = 0
    for locale, caption_list in CAPTIONS.items():
        slots = SLOTS_TR if locale == "tr-TR" else SLOTS_GLOBAL
        assert len(slots) == len(caption_list), f"Slot mismatch for {locale}"
        for idx, (src_folder, src_file, out_name) in enumerate(slots):
            raw_path = os.path.join(RAW_DIR, src_folder, src_file)
            if not os.path.exists(raw_path):
                raise FileNotFoundError(f"Missing raw screenshot: {raw_path}")
            out_path = os.path.join(OUT_DIR, locale, out_name)
            headline, subline = caption_list[idx]
            render_card(raw_path, out_path, headline, subline)
            total += 1
    print(f"[PASS] Generated {total} captioned 1080x1920 screenshots across {len(CAPTIONS)} locales in {OUT_DIR}")


if __name__ == "__main__":
    generate_all()
