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
- **Central Blackboard:** Always consult and maintain `c:\Users\egebatir\Documents\COUNCIL_BOARD.md` for live task statuses, milestones, and active roadmaps.
- **Context Window Conservation:** Delegate heavy implementation, research, and test runs to subagents defined in `.agents/council/` using the `multi-agent-council` skill. Keep the main conversation clean and focused on user decisions.
- **Adversarial QA Gatekeeper:** Never mark a task complete or push a release without verification from the `adversarial_qa` role (`python test_backend_logic.py`, syntax checks, 5-language cross-checks).
- **Safe Push Protocol:** Never run git push or publish releases without explicit user confirmation.

# Video Automation & YouTube Publishing Standards

1. **Resolution & Rendering:**
   - Always record in native 1080x1920 Full HD 60 FPS (Godot MovieWriter).
   - Video bitrate 4500k, maxrate 6000k, YUV420p for crisp YouTube Shorts compression resilience.

2. **Top Header & Scoreboard Safety:**
   - Scoreboard top margin must be at least 115px in automation mode.
   - Dynamic zoompan hook must be arena-centered with safe vertical anchor so top buttons (`<`, `||`) and scoreboard are never cut off.

3. **CTA Block Placement:**
   - Modern glassmorphism `ebstudyo.com` CTA badge must strictly be positioned between the scoreboard bottom (y~215) and arena circle top (y~570) at y = 270..362.

4. **Dynamic Stoppage / Extra Time:**
   - Never hardcode added time (+1', +2', etc.). Keep extra time dynamic to reflect natural match simulation events and late drama.
   - Post-match screen must display for 2.2s before finishing.

5. **Post-Match Title & Match-First Hashtag Hierarchy:**
   - Simulate and record the match first to extract the true final score (`home_score - away_score`).
   - Generate titles with actual scores (e.g. `[PUNCHY HOOK]! | [Team A] [Score] [Team B] | [Tournament/Hook] | BolGol`).
   - **Match-First Hashtag Hierarchy:** Hashtags and descriptions must strictly follow the match-first order:
     1. Match combination query (`#{HomeTeam}{AwayTeam}`, `#{HomeTeam}vs{AwayTeam}`)
     2. Real team names & fan nicknames (`#{Home}`, `#{Away}`, `#{FanAlias}`)
     3. Goalscorers and star players (`#{ScorerName}`, `#{StarPlayer}`)
     4. Official tournament name (`#{TournamentName}`)
     5. High-volume search intent queries (`#MaçÖzeti`, `#Goller` / `#MatchHighlights`, `#Goals`)
     6. Platform discovery tags (`#Shorts`, `#Futbol`, `#Football`)
     7. Minimal studio branding at the very end (`#BolGol`, `#EBStüdyo` / `#EBStudio`)
   - The 15 hashtags in the description body must strictly feature these match elements first; generic studio tags must never truncate match elements.

6. **Publication Scheduling (Match-Day Pre-Kickoff Rule):**
   - Every match video must be scheduled strictly on its **ACTUAL MATCH DAY, exactly 2 hours prior to kickoff** (`publishAt = match_kickoff - 2 hours UTC`) to capture the organic search surge and recommendation spike leading into the real match.

7. **Fixture Scope & European Coverage:**
   - Fixture queues must maintain all Turkish Big 4 European clashes (UEFA Europa League & Champions League), UEFA Champions League marquee matches, 46 National Team games (Türkiye, Portekiz, Arjantin, İtalya, İngiltere, ABD, Fransa, İspanya, Almanya, Brezilya vb. - UEFA Nations League & FIFA World Cup Qualifiers), Marquee European Showcase games (e.g. Barcelona vs Galatasaray, Real Madrid vs Fenerbahçe), and weekly Süper Lig wildcards.


