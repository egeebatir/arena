---
name: multi-agent-council
description: Multi-Agent Council & Autonomous Ecosystem Governance for Bol Gol Futbol, Futbol Automation, and Futbol Web. Orchestrates distribution, viral video pipelines, ASO, web landing, and adversarial QA auditing.
---

# Multi-Agent Council Governance Skill

This skill governs the cross-project autonomous Multi-Agent Council for the **Bol Gol Futbol** ecosystem.
It connects three interrelated repositories located in `c:\Users\egebatir\Documents\`:
1. `futbol`: Mobile Godot 4.6 game.
2. `futbol_automation`: Content & Social Media Factory (Python, OBS, 9:16 Shorts/Reels video editing, AI metadata, YouTube API).
3. `futbol-web`: Web version & landing page.

---

## 1. Council Operating Principles

### A. Context-Window Conservation
Never flood the user's primary chat session with raw logs, endless file dumps, or terminal traces.
- Run heavy research, long test suites, and multi-step refactoring in dedicated **Subagents** (`invoke_subagent`).
- Subagents keep their transcripts isolated in `<appDataDir>\brain\<conv_id>\...`.
- Record state, findings, and deliverables in `c:\Users\egebatir\Documents\COUNCIL_BOARD.md`.
- Present the user with high-level syntheses, clear decisions, and approval gates.

### B. Adversarial QA Gatekeeping
No feature, commit, export, or release may proceed without explicit sign-off from `adversarial_qa`.
Before declaring any task complete:
1. Run backend regression logic: `python test_backend_logic.py`.
2. Run Godot syntax verification: `godot --headless --check-only` or script parser.
3. Check 5-language completeness (TR, ENG, ESP, POR, ITA) without text truncation or missing keys.
4. Verify edge cases (offline/no network, zero scores, empty team rosters, AdMob failures).

### C. Live Blackboard Synchronization
Always keep `c:\Users\egebatir\Documents\COUNCIL_BOARD.md` and `c:\Users\egebatir\Documents\futbol\COUNCIL_BOARD.md` up to date with:
- Active task states
- Milestone completions
- QA audit results
- Pending user approvals

---

## 2. Agent Roster & Invocation

When delegating tasks, use `invoke_subagent` with the personas defined in `.agents/council/`:

| Agent | TypeName | Role | Focus |
| :--- | :--- | :--- | :--- |
| **01** | `orchestrator` | Üst Akıl / Genel Koordinatör | Global strategy, task dispatch, ecosystem cohesion |
| **02** | `engine_master` | Mobile Game Core Master | Godot 4.6, GDScript, UI/UX, AdMob, Android AAB |
| **03** | `viral_growth` | Viral Growth & Automation Lead | `futbol_automation`, OBS, 9:16 editing, AI hooks |
| **04** | `web_architect` | Web & Distribution Architect | `webfutbol` (`ebstudyo.com`) HTML5, landing page, store conversion |
| **05** | `adversarial_qa` | Kusur Avcıları Meclisi (4 Müfettiş) | 4 Bağımsız Müfettiş (Engine, Media, Localization, Sync) |
| **06** | `aso_specialist` | ASO & Storefront Specialist | Google Play 5-language copy, keywords, release notes |
| **07** | `version_release_controller` | Sürüm & Dağıtım Bütünlük Lideri | 7 Adımlı versiyon senkronizasyonu, şema ve geriye dönük uyumluluk |

---

## 3. Standard Council Workflows

### Sürüm Güncelleme ve Dağıtım Döngüsü (Release & Distribution Cycle):
1. **Engine Master:** Mobil oyunda güncellemeleri tamamlar.
2. **Version Release Controller:** Yeni versiyon kodunu (`version/code`, `version/name`, `schema_version`) belirler ve 7 halkalı senkronizasyon matrisini başlatır.
3. **Kusur Avcıları Meclisi (Adversarial QA):** 4 bağımsız müfettiş (Engine, Media, Localization, Sync) kodları, dilleri ve senaryoları test eder; onay vermezse hata listesi döner.
4. **ASO Specialist:** Onaylanan sürüm için 5 dilde sürüm notlarını (`What's New`) ve mağaza metinlerini hazırlar.
5. **Viral Growth Lead:** Yeni sürümün en çarpıcı özelliğini öne çıkaran 9:16 dikey video konseptini hazırlar.
6. **Web Architect:** Web sürümünü günceller (`weboyun1.pck`) ve Google Play indirme linklerini doğrular.
7. **Orchestrator:** Kullanıcıya tüm meclisin ortak hazırladığı **"Sürüm Dağıtım Paketi"**ni tek bir net raporda sunar. Kullanıcı onaylamadan asla push yapılmaz.
