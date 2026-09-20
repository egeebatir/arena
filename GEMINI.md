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

