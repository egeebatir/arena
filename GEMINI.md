# Android Mobile UI & UX Standards

This workspace enforces modern, high-standard Android UI/UX guidelines:

1. **Touch Ergonomics & Targets:**
   - Interactive elements must maintain at least 48x48 dp touch target dimensions.
   - Buttons must provide tactile visual depth (3D style with pressed state).

2. **Edge-to-Edge & Banner Safe Areas:**
   - Always reserve 120-130 px top margin for adaptive AdMob banners.
   - Always reserve 80-90 px bottom margin for bottom navigation bars.

3. **Touch-Friendly Scroll Containers:**
   - Always set `horizontal_scroll_mode` and `vertical_scroll_mode` to `SCROLL_MODE_SHOW_NEVER` for mobile lists to avoid intrusive desktop scrollbars.

4. **Dynamic Theme Harmonization:**
   - Derive panel and card backgrounds dynamically from `active_theme.bg_bottom.darkened(...)` and borders from `active_theme.accent`.
   - Never hardcode raw black or opaque dark backgrounds.

5. **Internationalization (i18n):**
   - Provide generous width (180-210 px) for buttons to prevent text truncation across TR, ENG, ESP, POR.
   - Enable `autowrap_mode` on multi-line text descriptions.

# Multi-Agent Council & Ecosystem Governance

This workspace is part of the 3-project Bol Gol Futbol ecosystem:
1. `futbol` (Mobile Godot 4.6 Game)
2. `futbol_automation` (Content & Social Media Factory)
3. `futbol-web` (Web & Landing Page)

**Governance Principles:**
- **Central Blackboard:** Always consult and maintain `COUNCIL_BOARD.md` (at repo root `futbol/COUNCIL_BOARD.md` or `c:\Users\egebatir\Documents\COUNCIL_BOARD.md`) for live task statuses, milestones, and active roadmaps.
- **Context Window Conservation:** Delegate heavy implementation, research, and test runs to subagents defined in `.agents/council/` using the `multi-agent-council` skill. Keep the main conversation clean and focused on user decisions.
- **Adversarial QA Gatekeeper:** Never mark a task complete or push a release without verification from the `adversarial_qa` role (`python tests/test_backend_logic.py`, syntax checks, 5-language cross-checks).
- **Safe Push Protocol:** Never run git push or publish releases without explicit user confirmation.

# Video Automation & YouTube Publishing Standards

1. **Resolution, Rendering & Quality:**
   - Always record in native 1080x1920 Full HD 60 FPS (Godot MovieWriter).
   - Match duration is set to **Normal** (`Global.match_duration = 1`, 36s realistic match simulation).
   - Enhanced FFmpeg render quality: CRF 18 visually lossless, video bitrate 6000k, maxrate 8500k, audio bitrate 256k, YUV420p for crisp YouTube Shorts compression resilience.

2. **Top Header & Scoreboard Safety:**
   - Scoreboard top margin must be at least 115px in automation mode.
   - Dynamic zoompan hook must be arena-centered with safe vertical anchor so top buttons (`<`, `||`) and scoreboard are never cut off.

3. **CTA Block Placement & Localization:**
   - Modern glassmorphism `ebstudyo.com` CTA badge must strictly be positioned between the scoreboard bottom (y~215) and arena circle top (y~570) at y = 265..373.
   - Dimensions: Compact width (`badge_w = 660px`) and increased vertical size (`badge_h = 108px`, logo 70px, large fonts 38px/23px) for maximum readability.
   - **Language Localization:** On English channels (`EB Studio`), CTA badge text is strictly in English (`ebstudyo.com | EARLY ACCESS`, `Play Test Build • Link in Channel`). On Turkish channel (`EB Stüdyo`), it remains in Turkish (`ebstudyo.com | TEST SÜRÜMÜ`, `Erken Erişime Katıl • Link Kanalda`).

4. **Dynamic Stoppage / Extra Time:**
   - Never hardcode added time (+1', +2', etc.). Keep extra time dynamic to reflect natural match simulation events and late drama.
   - Post-match screen must display for 2.2s before finishing.

5. **Post-Match Title Archetypes, Nicknames & Conversion Funnel:**
   - Simulate and record the match first to extract true final score (`home_score - away_score`), scorers list, comeback status, and match events.
   - **Dynamic 5-Category Title Archetypes:** Titles must strictly avoid repetitive formulaic prefixes and reflect specific match events:
     1. **Goalscorer / Star Magic:** (e.g., `MESSI MAGIC IN MIAMI!`, `OSIMHEN ŞOV YAPTI!`, `HAALAND RUNS RIOT!`, `KANE SHOWTIME!`). Always prioritize world stars or decisive goalscorers.
     2. **European Representative (*Temsilcimiz* in TR):** When a Turkish team (Galatasaray, Fenerbahçe, Beşiktaş, Trabzonspor, Başakşehir, etc.) plays a foreign team in UEFA Champions League, Europa League, or Conference League:
        - Win: `TEMSİLCİMİZ CİMBOM'DAN DEV ZAFER!`, `TEMSİLCİMİZ FENERBAHÇE DEVİ DEVİRDİ!`
        - Stage/Clash: `TEMSİLCİMİZ KARA KARTAL AVRUPA'DA SAHNEDE!`
     3. **Match Narrative & Drama:**
        - Comeback: `EFSANE GERİ DÖNÜŞ! {WINNER_NICK} PES ETMEDİ!` / `INCREDIBLE COMEBACK! {WINNER} REFUSES TO LOSE!`
        - High-Scoring (5+ goals): `{GOALS} GOLLÜ ÇILGIN DÜELLO!` / `{GOALS}-GOAL THRILLER!`
        - Blowout (3+ goal margin): `{WINNER}'DAN GÖVDE GÖSTERİSİ!` / `{WINNER} ANNIHILATION!`
        - Defensive / Goalless (0-0 or 1-0): `KALE GOLE KAPANDI!` / `DEFENSIVE MASTERCLASS! GOALLESS STALEMATE!`
     4. **Team Nicknames & Heritage Clash:** Naturally incorporate established nicknames:
        - GS: *Cimbom* / *Aslan*, FB: *Sarı Kanarya* / *Fener*, BJK: *Kara Kartal*, TS: *Fırtına*, Başakşehir: *Boz Baykuşlar*, Samsunspor: *Kırmızı Şimşekler*, Konyaspor: *Anadolu Kartalı*.
        - Arsenal: *The Gunners*, Liverpool: *The Reds*, Real Madrid: *Los Blancos*, Barcelona: *Blaugrana*, Man City: *Cityzens*, Man United: *Red Devils*, Chelsea: *The Blues*, Bayern: *Die Roten* / *Bavarian Giants*, Dortmund: *Die Schwarzgelben*, PSG: *Les Parisiens*, Juventus: *Bianconeri*, Inter: *Nerazzurri*, Milan: *Rossoneri*, Atletico: *Colchoneros*.
        - National: *Bizim Çocuklar* (TR), *Die Mannschaft* (GER), *The Oranje* (NED), *Les Bleus* (FRA), *La Roja* (ESP), *Seleção* (POR/BRA), *The Three Lions* (ENG), *Albiceleste* (ARG), *Danish Dynamite* (DEN), *The Eagles* (SRB), *The Dragons* (WAL).
     5. **Stadium / Derby Intensity:** High-tension atmospheric hooks (`RAMS PARK'TA BÜYÜK DEPREM!`, `KADIKÖY'DE NEFESLER TUTULDU!`, `SHOCKWAVE AT THE BERNABÉU!`).
   - Title Suffix Format: `[DYNAMIC HOOK]! | [Team A] [Score or vs] [Team B] | [Tournament] | BolGol`
   - **Title Length Budgeting (Strictly <= 92 Chars):** Titles must never be truncated on mobile devices or lose the `| BolGol` brand suffix. Clean tournament names (`Champions League` / `UCL` instead of `UEFA Champions League - League Phase - MD2`) and clean internal team strings (`Roma` instead of `ROMA SC`).
   - **Evergreen Search Descriptions & Antislop Compliance:** Descriptions must drive search traffic long after the initial viral window. In addition to the conversion funnel (`https://ebstudyo.com`), include official game metadata (`Bol Gol Futbol`, Godot Engine, Android / Web), 2D elastic physics simulation explanations, featured player lineups, and community discussion prompts. Strictly adhere to antislop R-02 (zero em dashes `—`, zero synthetic buzzwords).
   - **Conversion Funnel in Descriptions (Lead with `ebstudyo.com`):** The primary goal is pulling viewers to the website and Google Play downloads. Every video description MUST strictly lead with:
     - TR: `⚽ OYUNU HEMEN ÜCRETSİZ OYNAYIN: https://ebstudyo.com\n📲 Google Play Android Erken Erişim Sürümü Yayında!\n🔥 Bağımsız Türk futbol simülasyonumuzu web sitemizden veya Android cihazınızdan hemen ücretsiz deneyin.`
     - EN: `⚽ PLAY THE FREE GAME NOW: https://ebstudyo.com\n📲 Google Play Android Beta Access Live!\n🔥 Experience authentic physics-driven football simulation built from scratch on web and Android.`
     - ESP: `⚽ JUEGA GRATIS EN NUESTRA WEB: https://ebstudyo.com\n📲 ¡Acceso Beta para Android en Google Play ya disponible!\n🔥 Prueba nuestro simulador de fútbol independiente gratis desde el navegador o en tu móvil Android.`
   - **YouTube 500-Character Tag Packing (450 - 494 Chars):** YouTube Data API v3 enforces a 500-character limit across all tags and automatically wraps multi-word tags in quotes (`"..."`), adding +2 chars per spaced tag. The publisher and metadata generator must enforce a dual-counter packing algorithm (`yt_tag_len`):
     - Raw comma-joined length must be strictly >= 450 characters.
     - YouTube API total length (including quote penalty) must be strictly <= 494 characters.
     - Tag pool must blend match matchups, fan nicknames, star players, tournament queries, physics simulation terms, platform discovery tags, and official game tags (`Bol Gol Futbol`).
   - **National Team Name Translation:** When publishing on foreign channels (e.g. English), country/national team names MUST be translated into that language (e.g., `Germany` instead of `Almanya`, `Netherlands` instead of `Hollanda`, `Denmark` instead of `Danimarka`, `Spain` instead of `İspanya`).
   - **Match-First Hashtag Hierarchy & Localization:** 15 hashtags max in description body, strictly ordered:
     1. Match combination query (`#{HomeTeam}{AwayTeam}`, `#{HomeTeam}vs{AwayTeam}`)
     2. Real team names & fan nicknames (`#{Home}`, `#{Away}`, `#{FanAlias}`)
     3. Goalscorers and star players (`#{ScorerName}`, `#{StarPlayer}`)
     4. Official tournament name (`#{TournamentName}`)
     5. High-volume search intent queries (`#MaçÖzeti`, `#Goller` / `#MatchHighlights`, `#Goals`)
     6. Platform discovery tags (`#Shorts`, `#Futbol`, `#Football`)
     7. Minimal studio branding at the very end (`#BolGol`, `#EBStüdyo` / `#EBStudio`)

6. **Publication Scheduling (3-Hour Pre-Kickoff Rule from Oct 1, 2026):**
   - Past matches prior to Oct 1, 2026 are purged from upcoming queues.
   - Every match video from **1 October 2026** onwards must be scheduled strictly on its **ACTUAL MATCH DAY, exactly 3 hours prior to kickoff** (`publishAt = match_kickoff - 3 hours UTC`) to capture the organic search surge leading into the real match.

7. **YouTube Category Playlists & Game Title:**
   - Videos must be published with the Game title set to `Bol Gol Futbol`.
   - Every upload is automatically assigned to its matching official tournament category playlist (`National Teams`, `Champions League`, `Premier League`, `Süper Lig`, etc.), creating the playlist on demand if it does not yet exist.

8. **Fixture Scope & European Coverage:**
   - Fixture queues must maintain all Turkish Big 4 European clashes (UEFA Europa League & Champions League), UEFA Champions League marquee matches, 46 National Team games (Türkiye, Portekiz, Arjantin, İtalya, İngiltere, ABD, Fransa, İspanya, Almanya, Brezilya vb. - UEFA Nations League & FIFA World Cup Qualifiers), Marquee European Showcase games (e.g. Barcelona vs Galatasaray, Real Madrid vs Fenerbahçe), and weekly Süper Lig wildcards.

# Multi-Platform Distribution, ASO & Web Authority Standards

1. **Social Media Growth (YouTube Shorts, TikTok, Instagram Reels):**
   - Apply `content-marketer` patterns: first 1.2s hook must create cognitive dissonance or high-tension anticipation with dynamic punch-in zoom.
   - Maintain platform-specific narrative rhythm: YouTube Shorts (tactical suspense & score curiosity), TikTok (fast cuts, audio trends, high-energy goal replay), Instagram Reels (clean aesthetic showcase & stadium vibe).
   - End cards must drive traffic directly to `ebstudyo.com` or Google Play closed beta with clear, low-friction CTA.

2. **ASO & Store Discovery (Google Play Store):**
   - Enforce `seo-keyword-strategist` and `seo-meta-optimizer` guidelines for 5 languages (TR, ENG, ESP, POR, ITA).
   - Keep short description within 80 characters, packed with high-intent keywords (arcade football, soccer simulation, offline match).
   - Long descriptions must structure features with scannable headers, bullet points, and Google Play search semantic density.
   - Validate Data Safety, target SDK compliance, and permission minimization via `mobile-security-coder`.

3. **Web Authority, UI/UX & Conversion (`ebstudyo.com`):**
   - Apply `ui-ux-designer` and `ui-visual-validator`: maintain modern glassmorphism design tokens, accessible color contrasts (WCAG AA/AAA), and frictionless 1-click test enrollment.
   - Apply `seo-structure-architect` & `seo-authority-builder`: keep JSON-LD structured data (`Organization`, `MobileApplication`, `FAQPage`) synchronized with live app capabilities (232 teams, 46 national teams, 7 world leagues).
   - Ensure Core Web Vitals (CWV) resilience: zero audio playback before user interaction, on-demand engine loading, and responsive mobile-first layouts.

4. **Pipeline Orchestration & Resilience (`futbol_automation`):**
   - Apply `workflow-orchestration-patterns` and `async-python-patterns`: isolate render, post-production (ffmpeg), and upload jobs with graceful error recovery and automated retry with backoff.
   - Track production metrics via `kpi-dashboard-design` patterns to observe schedule adherence (kickoff - 2 hours) and YouTube API quota efficiency.

<!-- antislop:start -->
## antislop & Non-Sloppy Web Architecture (Frontend & Backend)

For UI, copy, accessibility/contrast, mobile layouts, backend APIs, and code comments, follow `antislop.md` and the modular antislop skills:
- **UI / Visual:** `.agents/skills/antislop-ui/SKILL.md` (Restrained palettes, genuine hierarchy, anti-generic AI card layouts, no mindless glow/glassmorphism/gradients).
- **Copy & Text:** `.agents/skills/antislop-copywriting/SKILL.md` (Honest product-specific copy, zero buzzwords/empty claims, zero conversational AI filler).
- **Human & Accessibility:** `.agents/skills/antislop-human/SKILL.md` (WCAG AA 4.5:1 text / 3:1 non-text contrast, keyboard navigable, visible focus outlines, no mouse-only traps).
- **Mobile / Responsive Layout:** `.agents/skills/antislop-layoutmobile/SKILL.md` (Fluid typography, tap target safety 48x48+, no horizontal scroll leaks, authentic content breakpoints).
- **Code & Backend Cleanliness:** `.agents/skills/antislop-code/SKILL.md` (Zero AI banner comments/workflow narration/restating the obvious, clean idiomatic backend endpoints, robust input validation, meaningful error handling).

### Core Non-Slop Web Tenets (Frontend & Backend):
1. **Frontend Craft:** Every visual element must pass the **purpose test** (what functional or hierarchy goal does it serve?). Avoid generic AI tropes: purple-blue gradients, bento grids with uniform content, fake trust badges, and floating cards.
2. **Backend Integrity:** Avoid generic boilerplate code, dummy try-catch blocks that swallow errors, and vacuous comments (`// Handle post request`). Implement explicit status codes, strict sanitization/validation, clear schema responses, and concise architectural docstrings.
<!-- antislop:end -->



