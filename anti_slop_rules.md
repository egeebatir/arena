# Anti‑Slop Rules for Bol Gol Futbol

## Core hard‑gate rules (must never be emitted)
- **R‑01** – No placeholder logos, generic “sparkle” graphics, or empty hero sections.
- **R‑02** – No fabricated statistics (e.g., “10 000 % ROI”, “5‑star rating from 500 k users”).
- **R‑03** – No emoji‑bulleted lists in marketing copy.
- **R‑04** – No generic “AI‑generated” banner text (“Next‑Gen AI 2.0”).
- **R‑05** – No meaningless UI components (e.g., empty `<div>`, invisible buttons).
- **R‑06** – All comments must explain *why* a line exists, never just restate the code.

## Purpose‑gate and quality‑lock rules (enable only with explicit reason)
- **P‑01** – Motion/animation only when a **motion‑purpose** is supplied (e.g., “show bounce to highlight score”).
- **P‑02** – External libraries only when a **dependency‑justification** is provided.
- **Q‑01** – Consistent naming conventions (snake_case for GDScript, camelCase for TypeScript).

## Liveliness dials (optional)
- **ENERGY** – 0 → 3 (0 = static UI, 3 = subtle micro‑interactions).
- **RHythm** – Controls timing of UI transitions.
- **MOTION** – Enables or disables motion‑based feedback.

## Delivery gate (mandatory)
Run the `antislop-delivery` skill before any commit. It will emit a **PASS/FAIL** report; a FAIL aborts the CI pipeline and surfaces the offending snippet.

> *These rules are enforced automatically when you prefix any generation command with the anti‑slop skills, e.g.*

```bash
agy run --skills antislop-ui,android-ui-dev <prompt>
agy run --skills antislop-code,python-performance-optimization <prompt>
```
