---
name: android-ui-dev
description: >-
  Expert guidelines, design systems, and best practices for Android mobile UI/UX development.
  Use this skill whenever designing, building, styling, or refactoring user interfaces for Android apps
  and mobile games (Jetpack Compose, Material Design 3, Godot Mobile UI, XML layouts, responsive layouts,
  touch targets, edge-to-edge insets, dark/light theme harmonization, and tactile mobile interactions).
---

# Android UI & Mobile UX Specialist Skill

This skill provides comprehensive instructions, standards, and architecture patterns for designing and implementing production-grade, highly polished Android mobile user interfaces.

---

## 1. Core Android UI Principles

### 1.1 Touch Targets & Ergonomics
- **Minimum Target Size:** All clickable elements (buttons, icons, toggles, chips) MUST have a minimum touch target of **48×48 dp** (in game engines: min 48–56 px / scaled equivalent).
- **Touch Separation:** Provide at least **8 dp** spacing between interactive elements to prevent accidental miss-clicks.
- **Thumb-Zone Optimization:** Place primary interactive controls, bottom navigation bars, and confirmation actions in the bottom two-thirds of the viewport where one-handed thumb reach is natural.

### 1.2 Safe Area Insets & Edge-to-Edge Display
- **Status Bar & Gesture Bar Insets:** Always reserve margin/padding for system bars:
  - Top: Reserve min **24–48 dp** (status bar / display cutout / camera hole punch).
  - Bottom: Reserve min **16–36 dp** above system navigation pill / gesture bar.
- **AdMob / Banner Ad Safe Zones:**
  - When adaptive banner ads are displayed at top or bottom, reserve **90–130 dp** dedicated margin to prevent UI overlay or clipping.
- **Modal Scrims & Backdrop Touch Traps:**
  - All pop-ups and dialogs MUST render a full-screen semi-transparent backdrop overlay (`Color(0, 0, 0, 0.75)` with `PRESET_FULL_RECT`) to trap touches and prevent accidental background clicks.

### 1.3 Responsive Density & Aspect Ratio Handling
- Support aspect ratios from **16:9** up to **21:9**, including foldable and tablet displays.
- Use expandable containers (`VBoxContainer`, `HBoxContainer`, `ScrollContainer`, `Box`, `LazyColumn`) with automatic stretch/shrink policies.
- Always wrap variable-length or dense vertical content in a `ScrollContainer` with `SCROLL_MODE_SHOW_NEVER` on mobile to avoid ugly OS desktop scrollbars while supporting fluid touch fling/inertial scrolling.

---

## 2. Visual Hierarchy & Theming Standards

### 2.1 Material 3 (M3) & Modern Glassmorphism
- **Color Roles:**
  - **Primary / Accent:** Used for key calls to action (e.g., "START MATCH", "BUY", "CONFIRM").
  - **Surface & Surface-Variant:** Backgrounds of cards and dialogue containers (`bg_bottom.darkened(...)`).
  - **Outline / Border:** Subtle 1–2.5 dp border with theme-accented tint or glassmorphism glow.
  - **Scrim:** Deep backdrop shade (`#000000` at 70–80% opacity) behind overlays.
- **Theme Harmonization:**
  - Never hardcode raw opaque black or arbitrary gray values. Derive container backgrounds dynamically from active theme colors (e.g., `active_theme.bg_bottom.darkened(0.15)`).
  - Provide crisp contrast for typography (minimum 4.5:1 for normal text, 3:1 for large headers per WCAG AA).

### 2.2 Tactile 3D Buttons & Feedback
- High-end mobile UIs use tactile depth:
  - Base button top color with a darker 3–5 dp bottom border.
  - Pressed state collapses the bottom border (`border_width_bottom = 0` or position offset y +2–3 px) to simulate physical button depression.
  - Integrate subtle haptic feedback on touch (`Input.vibrate_handheld(30)` or Android `HapticFeedbackConstants.VIRTUAL_KEY`).

### 2.3 Internationalization (i18n) Text Budgeting
- German, Spanish, Portuguese, and Turkish strings are typically **20% to 35% longer** than English.
- Rules:
  - Never fix rigid narrow widths on buttons containing localized text (e.g., increase button width from 160 px to 180–205 px, or enable auto-shrink).
  - Enable `autowrap_mode = TextServer.AUTOWRAP_WORD` on multi-line descriptions and dialog bodies.
  - Set `clip_text = false` or ensure sufficient horizontal padding so labels never truncate with ellipsis (`"..."`).

---

## 3. Implementation Cheat Sheets

### 3.1 Godot Mobile UI Container Recipe
```gdscript
# Standard Mobile Page with Safe Margins & Clean Scrolling
func create_mobile_tab() -> Control:
    var page = Control.new()
    page.set_anchors_preset(Control.PRESET_FULL_RECT)
    
    var margin = MarginContainer.new()
    margin.set_anchors_preset(Control.PRESET_FULL_RECT)
    margin.add_theme_constant_override("margin_top", 130)    # Top banner clearance
    margin.add_theme_constant_override("margin_bottom", 90)  # Bottom navigation bar clearance
    margin.add_theme_constant_override("margin_left", 16)
    margin.add_theme_constant_override("margin_right", 16)
    page.add_child(margin)
    
    var scroll = ScrollContainer.new()
    scroll.set_anchors_preset(Control.PRESET_FULL_RECT)
    scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_SHOW_NEVER
    scroll.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_SHOW_NEVER
    scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
    margin.add_child(scroll)
    
    var vbox = VBoxContainer.new()
    vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    vbox.size_flags_vertical = Control.SIZE_EXPAND_FILL
    vbox.add_theme_constant_override("separation", 16)
    scroll.add_child(vbox)
    
    return page
```

### 3.2 3D Tactile Button Recipe
```gdscript
# Creates a modern, tactile mobile button with depth & responsive hover/press states
func apply_3d_style_to_button(btn: Button, main_color: Color, bottom_border_color: Color, radius: int = 14, depth: int = 4, pad_h: int = 20, pad_v: int = 12):
    var normal = StyleBoxFlat.new()
    normal.bg_color = main_color
    normal.corner_radius_top_left = radius; normal.corner_radius_top_right = radius
    normal.corner_radius_bottom_left = radius; normal.corner_radius_bottom_right = radius
    normal.border_width_bottom = depth
    normal.border_color = bottom_border_color
    normal.content_margin_left = pad_h; normal.content_margin_right = pad_h
    normal.content_margin_top = pad_v; normal.content_margin_bottom = pad_v
    
    var pressed = normal.duplicate()
    pressed.border_width_bottom = 0
    pressed.content_margin_top = pad_v + depth
    pressed.content_margin_bottom = pad_v
    pressed.bg_color = main_color.darkened(0.1)
    
    btn.add_theme_stylebox_override("normal", normal)
    btn.add_theme_stylebox_override("hover", normal)
    btn.add_theme_stylebox_override("pressed", pressed)
    btn.add_theme_stylebox_override("focus", normal)
```

---

## 4. Verification Checklist for Android UI
Before presenting any mobile UI change to the user:
- [ ] **No Text Truncation:** Tested in all supported languages (TR, ENG, ESP, POR) with long strings.
- [ ] **Clean Scrollbars:** No default gray OS scrollbars showing on touch lists (`SCROLL_MODE_SHOW_NEVER`).
- [ ] **Banner Clearance:** Top/bottom margins properly accommodate AdMob adaptive banners and navigation bars.
- [ ] **Theme Contrast:** All 11+ themes render high-contrast, readable text and harmonized panel backgrounds.
- [ ] **Backdrop Scrim:** All modal dialogs block background touches and center cleanly on any screen width.
- [ ] **Haptic/Tactile Feel:** Interactive buttons feel responsive and provide visual depth feedback.
