# Responsive & Platform Guidelines

Phase 3 – UI/UX Design · v1.0 · 2026-11-11

How layouts adapt to screen sizes, Android vs iPhone conventions, text scaling, and Arabic right-to-left (RTL).

---

## 1. Target Devices

| Class | Width | Examples | Priority |
|---|---|---|---|
| Small phone | 320–359 dp | Old/low-end Android (e.g., 4.7–5" devices) | Must work (no overflow) |
| **Standard phone** | 360–413 dp | Most Android phones (360/393/412 dp), iPhone SE (375 pt), iPhone 15/16 (393 pt) | **Design baseline: 375 × 812** |
| Large phone | 414–479 dp | iPhone Plus/Pro Max (430–440 pt), large Android | Must look good |
| Small tablet / foldable open | 600–839 dp | 7–8" tablets, foldables | Usable (centered column) |
| Tablet | ≥ 840 dp | iPad, 10" Android | Usable, not optimized in MVP |

Orientation: **portrait only** on phones in MVP (simplifies layouts; prayer/attendance use is one-handed). Tablets allow landscape with the centered-column rule.

---

## 2. Breakpoints & Layout Rules

| Breakpoint | Width | Side margin | Columns | Rules |
|---|---|---|---|---|
| Compact-S | < 360 | 16 | 4 | Stat cards 1 per row if label wraps; quick actions 2×2; prayer strip scrolls horizontally |
| Compact | 360–599 | 16 (20 when ≥ 400) | 4 | Baseline layouts below |
| Medium | 600–839 | 24 | 8 | Content max width 600 centered; stat cards 3 per row; lists may show 2-column cards |
| Expanded | ≥ 840 | 32 | 12 | Navigation rail instead of bottom bar (*future*); master–detail for lists (*future*); max content width 840 |

Rules:
- Use **flexible widths** (fractions, `Expanded`-style), never fixed pixel widths for content.
- Cards stretch to container width; images keep aspect ratio (16:9 media, 1:1 avatars).
- Long lists are virtualized and paginated.
- Forms: one column on phones; max form width 560 on tablets.

---

## 3. Safe Areas & System UI

| Area | Android | iOS |
|---|---|---|
| Top | Status bar (24–48 dp), punch-hole cameras | Notch / **Dynamic Island** (59 pt safe top on recent iPhones) |
| Bottom | Gesture navigation bar or 3-button bar | **Home indicator** (34 pt) |
| Rule | Draw edge-to-edge; pad content with system insets | Same |

- Bottom navigation adds the bottom inset below its 64 dp height.
- Sticky bottom buttons (forms, review sheets) sit above the inset.
- Status bar icons: dark on light screens; light on green/hero/splash screens.
- Edge-to-edge is mandatory on recent Android versions — no hard-coded status bar heights.

---

## 4. Android vs iPhone — Platform Adaptation

The app has **one visual identity** on both platforms, with platform-native **behaviour** where users expect it.

| Element | Android | iPhone |
|---|---|---|
| Back navigation | System back button / gesture, **predictive back** animation | Edge-swipe back, chevron back button |
| App bar title | Start-aligned | Centered; large titles that collapse on scroll |
| Page transition | Material fade-through / shared axis | Cupertino horizontal slide |
| Date / time picker | Material calendar & clock dialog | Cupertino wheel in bottom sheet |
| Switch | Material switch (green) | Cupertino switch (green) |
| Dialog | Material dialog, buttons side by side end-aligned | Same style, vertically stacked buttons when long |
| Action menu | Bottom sheet | Bottom sheet (Cupertino action-sheet style) |
| Pull to refresh | Material refresh indicator | Cupertino refresh control |
| Scrolling | Clamping with glow/stretch | Bouncing |
| Haptics | Light vibration patterns | Taptic engine feedback |
| Share | Android share sheet | iOS share sheet |
| Keyboard | "Next/Done" IME actions | Toolbar "Done" above numeric keypad (iOS numeric keypad has no Done) |
| OTP autofill | SMS Retriever / User Consent API | `oneTimeCode` autofill from Messages |
| Notifications permission | Runtime prompt (Android 13+) | Prompt — shown after explainer card |
| Fonts | Bundled Inter / Noto Sans Arabic (not Roboto) | Bundled (not SF Pro) — keeps identity consistent |

### Android-specific checks
- Works with 3-button navigation and gesture navigation.
- No content under the gesture bar.
- Material ripple on all tappables.
- Back from a tab root → goes to Home tab; back from Home → exits (with no "press again" toast required).
- Test on Android 7 (API 24) minimum and latest.

### iPhone-specific checks
- Content not hidden by Dynamic Island / notch; large title behaves correctly.
- Edge-swipe back is never blocked (avoid horizontal gestures starting at screen edge; attendance swipe starts away from edge).
- Numeric keypads have a "Done" accessory.
- Tested on iPhone SE (375×667, small height!) and Pro Max.

> **Small-height warning:** iPhone SE (667 pt) and many Android phones (~640 dp height) — Home hero card + prayer strip + quick actions must fit without scrolling to the quick actions. Hero card height is capped at 180 dp on heights < 700.

---

## 5. Text Scaling

| Scale | Requirement |
|---|---|
| 100% | Baseline design |
| 130% | No truncation of labels, buttons wrap to 2 lines |
| 200% | Everything readable; layouts switch to single column; stat cards stack; bottom-nav labels may hide with icons + tooltips only if they still overflow |

- Never fix text container heights; use min heights.
- Countdown/display text capped at 1.3× (avoid overflow), body never capped.
- Test strings in **Somali** (longest) at 200%.

---

## 6. Arabic RTL Support

### 6.1 What mirrors

| Element | In RTL |
|---|---|
| Overall layout | Start = right; padding/margins use start/end, never left/right |
| Bottom navigation order | Home at far right |
| Back arrow / chevrons / "›" | Point left→ mirrored |
| Lists | Leading avatar on the right; trailing values (amounts, times) on the left |
| Swipe actions | Reversed |
| Progress bars | Fill from right to left |
| Onboarding slides / carousels | Swipe direction reversed; page dots reversed |
| Text alignment | Right-aligned (start) |
| Forms | Labels and inputs right-aligned; leading icons on the right |
| Hero card | Icon moves to the left side |
| Step indicators (setup wizard) | Step 1 on the right |

### 6.2 What does NOT mirror

| Element | Why |
|---|---|
| Clocks, countdown digits, times | Numbers are LTR |
| Phone numbers, receipt numbers, amounts, OTP boxes | LTR data |
| Qibla compass | Geographic, absolute direction |
| Media play/pause icons | Universal convention |
| Checkmark, search, settings, bell icons | Non-directional |
| Logos and photos | Not mirrored |
| Charts' numeric axes | Values LTR; time axis direction follows locale (right-to-left for Arabic) |

### 6.3 RTL rules for designers & developers
- Use directional properties (`start`/`end`, `EdgeInsetsDirectional`, `AlignmentDirectional`) everywhere.
- Mirror directional custom icons (back, forward, send, undo/redo, "list with bullets").
- Verify every screen in Arabic: no clipped Arabic diacritics (use Arabic line heights from [typography.md](typography.md)).
- Arabic strings are often **shorter** horizontally but **taller** vertically — check card heights.
- Mixed content: Latin names inside Arabic UI and vice versa are isolated (see typography §6).

### 6.4 RTL example — Home hero card

```
LTR (English/Somali)                         RTL (Arabic)
┌─────────────────────────────┐              ┌─────────────────────────────┐
│ NEXT PRAYER            ☀    │              │    ☀               الصلاة القادمة │
│ Asr                         │              │                         العصر │
│ 03:42:18                    │              │                    03:42:18 │
│ Adhan 3:31 · Iqamah 3:45    │              │     الإقامة 3:45 · الأذان 3:31 │
└─────────────────────────────┘              └─────────────────────────────┘
```

---

## 7. Images & Assets

- Provide raster images at 1x/2x/3x (iOS) and mdpi→xxxhdpi (Android); prefer **vector (SVG converted)** for icons and illustrations.
- App icon: green background, gold mosque/crescent mark; Android **adaptive icon** (foreground + background layers, monochrome layer for themed icons); iOS icon without transparency.
- Splash: native splash (Android 12+ Splash Screen API: centered icon on `green-800`; iOS launch storyboard) followed by the in-app animated splash.
- Uploaded photos compressed and displayed with placeholders (blur/skeleton) to save data.

---

## 8. Performance-Aware Design

- Avoid heavy blur/glass effects (expensive on low-end Android).
- Geometric pattern = lightweight vector or pre-rendered tiled image, cached.
- Shadows minimal (level 1–2) in long lists.
- Prayer and Home screens render from cache instantly; network data fades in.

---

## 9. Responsive Test Matrix (Phase 3 review & QA)

| Device profile | Size | Text scale | Language |
|---|---|---|---|
| Small Android | 320×640 dp | 100% / 130% | Somali |
| Standard Android | 360×780 dp | 100% / 200% | English, Arabic |
| Pixel-class | 412×915 dp | 100% | Arabic |
| iPhone SE | 375×667 pt | 100% / 200% | Somali |
| iPhone 16 | 393×852 pt | 100% | English, Arabic |
| iPhone Pro Max | 440×956 pt | 130% | Arabic |
| Tablet | 800×1280 dp | 100% | English |
