---
name: android-edge-to-edge
description: >-
  Official Android Edge-to-Edge UI modernization guidelines and implementation runbook.
  Use this skill whenever implementing, fixing, or modernizing edge-to-edge display, handling
  system bar insets (status bar, gesture navigation bar, display cutouts/notches, IME/software keyboard),
  and ensuring compliance with Android 15 (API 35+) edge-to-edge enforcement across Compose, Views, and Game Engines.
---

# Android Edge-to-Edge UI Modernization

This skill provides step-by-step instructions for implementing edge-to-edge display on Android, drawing behind system bars, and properly handling insets across Android 15 (API 35+) and legacy versions down to API 21.

---

## 1. Core Principles of Edge-to-Edge

Starting with Android 15 (targetSdk 35+), edge-to-edge is **enforced by default**. Apps draw edge-to-edge and system bars are transparent by default.

### Key Inset Types
- **`systemBars()`:** Status bar + Navigation bar.
- **`displayCutout()`:** Camera notch, pinhole, or waterfall curves.
- **`safeDrawing()`:** Union of `systemBars()`, `displayCutout()`, and `ime()` (safest default).
- **`ime()`:** Software keyboard visibility and animation height.

---

## 2. Jetpack Compose Implementation

### 2.1 Enabling in Activity
```kotlin
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()
        setContent {
            AppTheme {
                MainScreen()
            }
        }
    }
}
```

### 2.2 Applying Insets in Compose
```kotlin
import androidx.compose.foundation.layout.*
import androidx.compose.material3.*

@Composable
fun MainScreen() {
    Scaffold(
        contentWindowInsets = WindowInsets.safeDrawing,
        topBar = {
            TopAppBar(
                title = { Text("App Title") },
                windowInsets = WindowInsets.safeDrawing.only(WindowInsetsSides.Top + WindowInsetsSides.Horizontal)
            )
        },
        bottomBar = {
            NavigationBar(
                windowInsets = WindowInsets.safeDrawing.only(WindowInsetsSides.Bottom + WindowInsetsSides.Horizontal)
            ) {
                // Navigation items
            }
        }
    ) { innerPadding ->
        LazyColumn(
            modifier = Modifier
                .fillMaxSize()
                .padding(innerPadding)
                .consumeWindowInsets(innerPadding)
        ) {
            // Scrollable items draw cleanly without clipping
        }
    }
}
```

---

## 3. View System / XML Layouts Implementation

```kotlin
import androidx.core.view.ViewCompat
import androidx.core.view.WindowInsetsCompat
import androidx.core.view.updatePadding

ViewCompat.setOnApplyWindowInsetsListener(binding.root) { view, windowInsets ->
    val insets = windowInsets.getInsets(
        WindowInsetsCompat.Type.systemBars() or WindowInsetsCompat.Type.displayCutout()
    )
    view.updatePadding(
        top = insets.top,
        bottom = insets.bottom,
        left = insets.left,
        right = insets.right
    )
    WindowInsetsCompat.CONSUMED
}
```

---

## 4. Mobile Games & Godot Engine Implementation

In game engines rendering to a full-screen canvas (e.g. Godot, Unity):

```gdscript
# Query device hardware safe area and apply to root UI margins
func apply_safe_area_insets(root_margin_container: MarginContainer, has_top_banner: bool = true):
    var safe_rect: Rect2i = DisplayServer.get_display_safe_area()
    var window_size: Vector2i = DisplayServer.window_get_size()
    
    var top_inset: int = safe_rect.position.y
    var bottom_inset: int = window_size.y - (safe_rect.position.y + safe_rect.size.y)
    
    # Add clearance for adaptive AdMob banner (100-130px) if banner is active
    var top_margin: int = max(top_inset, 40) + (130 if has_top_banner else 0)
    var bottom_margin: int = max(bottom_inset, 40) + 90 # Bottom nav bar allowance
    
    root_margin_container.add_theme_constant_override("margin_top", top_margin)
    root_margin_container.add_theme_constant_override("margin_bottom", bottom_margin)
```

---

## 5. Verification & Common Anti-Patterns

### Anti-Patterns to Avoid:
❌ **Hardcoding status bar height as 24dp:** Status bar heights vary between devices (32–56dp on modern hole-punch screens).  
❌ **Setting non-transparent system bar colors:** On Android 15, `statusBarColor` is ignored or deprecated.  
❌ **Applying padding to the ScrollView itself:** When padding is on the ScrollView rather than inside its content or clipToPadding=false, content gets clipped when scrolling under transparent system bars.  

### Verification Steps:
1. Test with Gesture Navigation enabled (thin home bar at bottom).
2. Test with 3-button Navigation enabled (black navigation bar).
3. Test with camera cutout / notch in portrait and landscape.
4. Verify keyboard opening pushes interactive fields via `WindowInsets.ime`.
