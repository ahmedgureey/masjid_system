# Color Palette

Phase 3 – UI/UX Design · v1.0 · 2026-11-11

All contrast ratios in this document were **calculated** with the WCAG 2.1 relative-luminance formula. Targets: **4.5:1** for normal text, **3:1** for large text (≥ 18 sp regular or ≥ 14 sp bold) and for meaningful non-text UI (borders of inputs, icons, focus rings).

---

## 1. Official Brand Colors

| Token | Hex | Role |
|---|---|---|
| `brand.green` | `#176B45` | Primary — app bars, primary buttons, active states, links |
| `brand.white` | `#FFFFFF` | Surfaces — cards, sheets, inputs, app bar on light screens |
| `brand.gold` | `#D4AF37` | Accent — next prayer highlight, badges, campaign progress, premium details |
| `brand.darkText` | `#1F2937` | Primary text and icons on light surfaces |
| `brand.lightBg` | `#F7F9F7` | Page background behind cards |

### Usage ratio (60 · 30 · 10)

- **60%** light: `lightBg` + `white` surfaces.
- **30%** green: app bars, primary actions, hero cards, selected states.
- **10%** gold: accents only. Gold is never the main color of a screen.

---

## 2. Contrast Check of the Official Palette

| Foreground on background | Ratio | Normal text | Large text / UI | Decision |
|---|---|---|---|---|
| Dark Text `#1F2937` on White | **14.68** | ✅ | ✅ | Default body text |
| Dark Text on Light Bg `#F7F9F7` | **13.87** | ✅ | ✅ | Default body text on page background |
| Green `#176B45` on White | **6.51** | ✅ | ✅ | Links, green text, outline buttons |
| Green on Light Bg | **6.15** | ✅ | ✅ | OK |
| White on Green | **6.51** | ✅ | ✅ | Primary button label, app bar title |
| Dark Text on Gold | **6.98** | ✅ | ✅ | **Gold buttons/badges use dark text** |
| Gold on Green | **3.10** | ❌ | ✅ | Gold only for large text/icons on green |
| Gold on Green-800 `#0F4D31` | **4.70** | ✅ | ✅ | Gold text allowed on dark-green hero cards |
| **Gold on White** | **2.10** | ❌ | ❌ | **Forbidden for text and icons** |
| **White on Gold** | **2.10** | ❌ | ❌ | **Forbidden** — never white text on gold |

### The gold rules (important)

1. **Never** gold text or gold icons on white / light background.
2. **Never** white text on gold. Text on gold is always `darkText #1F2937`.
3. Gold *text* is allowed on `green-800 #0F4D31` or darker (≥ 4.70), or as large text on `green #176B45`.
4. When a gold-tinted text is needed on white (e.g., "Featured" label), use `gold-800 #7A5F12` (**6.05** on white).
5. Gold as decoration (thin divider, ornament, progress bar fill, star badge background) is fine as long as the information is also given as text.

---

## 3. Extended Tonal Scales

The official colors are anchored in the scales (marked ★). Tints/shades are needed for hover/pressed states, tinted backgrounds, and dark mode — they are **not new hues**.

### 3.1 Green (primary)

| Token | Hex | Use |
|---|---|---|
| `green-50` | `#E8F3EC` | Selected chip/nav pill background, success banner bg |
| `green-100` | `#C9E4D3` | Secondary text on green (4.81 on `#176B45`) |
| `green-200` | `#9FCFB2` | Disabled-on-green, chart secondary |
| `green-300` | `#6DB58C` | Chart series |
| `green-400` | `#3F9A6A` | Chart series |
| `green-500` | `#23804F` | Hover on primary (white text 4.92 ✅) |
| ★ `green-600` | `#176B45` | **Primary** |
| `green-700` | `#125A39` | Pressed state (white text 8.24) |
| `green-800` | `#0F4D31` | Hero cards, splash background (white 9.88, gold 4.70) |
| `green-900` | `#0A3622` | Gradient end, status bar on splash |

### 3.2 Gold (accent)

| Token | Hex | Use |
|---|---|---|
| `gold-50` | `#FBF5E1` | Featured card background, campaign card tint |
| `gold-100` | `#F5E8B8` | Progress track |
| `gold-200` | `#EDD88A` | Ornaments |
| `gold-300` | `#E2C25B` | Gold text on dark green (5.69 on green-800), dark-mode accent |
| ★ `gold-400` | `#D4AF37` | **Accent** — fills, badges, next-prayer marker |
| `gold-500` | `#B8952A` | Pressed gold button |
| `gold-600` | `#9A7B20` | Gold large text on white (4.02 — large only) |
| `gold-700` | `#8A6D1A` | Gold text on white (4.90 ✅) |
| `gold-800` | `#7A5F12` | Gold text on white / on gold-50 (6.05 / 5.54) |
| `gold-900` | `#5C470C` | Rare — dark ornament |

### 3.3 Neutrals (green-tinted greys)

Neutrals carry a slight green tint so greys feel part of the brand rather than generic.

| Token | Hex | Use | Contrast |
|---|---|---|---|
| `neutral-0` | `#FFFFFF` | Surface | — |
| ★ `neutral-25` | `#F7F9F7` | Page background | — |
| `neutral-50` | `#F1F4F2` | Pressed list row, skeleton base | — |
| `neutral-100` | `#E6EBE8` | Dividers, skeleton highlight | — |
| `neutral-200` | `#D9E1DC` | Card borders (decorative) | 1.33 (decorative only) |
| `neutral-400` | `#7B8B82` | **Input borders**, inactive icons | 3.59 on white ✅ (UI) |
| `neutral-500` | `#6B7280` | Secondary text, captions | 4.83 white / 4.57 bg ✅ |
| `neutral-600` | `#4B5563` | Tertiary headings, strong secondary text | 7.56 ✅ |
| `neutral-700` | `#374151` | — | — |
| ★ `neutral-800` | `#1F2937` | **Primary text** | 14.68 ✅ |
| `neutral-900` | `#111827` | Scrim base (with opacity) | — |

---

## 4. Semantic (Status) Colors — why they are added

The brief says not to add unrelated colors without a reason. These four are **required for usability and accessibility**: users must instantly tell an error from a success, and green alone cannot express "warning" or "error". They are used **only** for status (validation, alerts, attendance, approval states) — never for decoration.

| Token | Text/icon | Background tint | Contrast (text on white / on tint) | Used for |
|---|---|---|---|---|
| `success` | `#176B45` (reuses brand green) | `#E8F3EC` | 6.51 / 5.72 | Saved, Approved, Present |
| `error` | `#B42318` | `#FEF3F2` | 6.57 / 6.05 | Validation errors, Rejected, Absent, Void |
| `warning` | `#B54708` | `#FFFAEB` | 5.43 / 5.20 | Pending approval, Late, offline banner |
| `info` | `#1D5FA8` | `#EFF6FF` | 6.45 / 5.93 | Tips, Excused, informational banners |

Rules:
- Status is always **icon + label + color**, never color alone (e.g., attendance chip "✓ Present").
- Destructive buttons (Void, Delete account) use `error` with white text (6.57 ✅).

---

## 5. Dark Mode Palette (prepared now, ships in v1.1)

| Token | Hex | Contrast |
|---|---|---|
| `dark.bg` | `#0F1A14` | — |
| `dark.surface` | `#16241C` | — |
| `dark.surfaceRaised` | `#1E3026` | — |
| `dark.text` | `#E8EEEA` | 15.15 on bg, 13.70 on surface |
| `dark.textMuted` | `#9CA3AF` | 6.35 on surface |
| `dark.primary` | `#4CC38A` | 7.27 on surface; text on it `#0F1A14` = 8.05 |
| `dark.gold` | `#E2C25B` | 9.29 on surface |
| `dark.border` | `#7B8B82` | 4.49 on surface (inputs) |
| `dark.error` | `#F97066` | 5.78 on surface |
| `dark.warning` | `#F5B544` | 8.88 on surface |
| `dark.info` | `#7CB4F0` | 7.40 on surface |

In dark mode the primary green is lightened (`#4CC38A`) because `#176B45` is too dark on a near-black surface.

---

## 6. Gradients & Overlays

| Name | Definition | Use |
|---|---|---|
| `gradient.hero` | `green-700 #125A39` → `green-800 #0F4D31` (top-left → bottom-right) | Home next-prayer card, prayer screen header |
| `gradient.splash` | `green-800 #0F4D31` → `green-900 #0A3622` (top → bottom) | Splash, onboarding top area |
| `overlay.pattern` | Islamic geometric pattern, `white` at 6% opacity (or `gold-300` at 10%) | On hero/splash backgrounds only |
| `scrim` | `neutral-900` at 50% | Behind dialogs and bottom sheets |
| `image.scrim` | Black 0% → 60% bottom gradient | Text over event/campaign photos |

---

## 7. Flutter ColorScheme Mapping (for Phase 4+ implementation)

| Material 3 role | Light | Dark |
|---|---|---|
| `primary` | `#176B45` | `#4CC38A` |
| `onPrimary` | `#FFFFFF` | `#0F1A14` |
| `primaryContainer` | `#E8F3EC` | `#125A39` |
| `onPrimaryContainer` | `#0F4D31` | `#E8F3EC` |
| `secondary` | `#D4AF37` | `#E2C25B` |
| `onSecondary` | `#1F2937` | `#0F1A14` |
| `secondaryContainer` | `#FBF5E1` | `#5C470C` |
| `onSecondaryContainer` | `#7A5F12` | `#FBF5E1` |
| `surface` | `#FFFFFF` | `#16241C` |
| `onSurface` | `#1F2937` | `#E8EEEA` |
| `onSurfaceVariant` | `#6B7280` | `#9CA3AF` |
| `surfaceContainerLowest` / scaffold bg | `#F7F9F7` | `#0F1A14` |
| `outline` | `#7B8B82` | `#7B8B82` |
| `outlineVariant` | `#D9E1DC` | `#2C3D33` |
| `error` | `#B42318` | `#F97066` |
| `onError` | `#FFFFFF` | `#0F1A14` |

> This table is a design specification only. No Flutter code is written in Phase 3.
