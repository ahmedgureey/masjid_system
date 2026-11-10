# Reusable Components

Phase 3 – UI/UX Design · v1.0 · 2026-11-11

Specification of every reusable UI component. Each component lists: purpose, anatomy, variants, sizes, states, tokens, accessibility and RTL notes. Proposed widget names (prefix `App…` or domain name) are given so Phase 4+ implementation stays consistent — **no code is written in Phase 3**.

Tokens referenced: colors from [color-palette.md](color-palette.md), type from [typography.md](typography.md), spacing/radius/elevation from [design-system.md](design-system.md).

---

## 1. Buttons — `AppButton`

### Variants

| Variant | Background | Content | Border | Use |
|---|---|---|---|---|
| **Primary** | `green-600` | White (6.51) | — | Main action per screen: Login, Save, Record donation |
| **Secondary (outline)** | Transparent | `green-600` | 1.5 dp `green-600` | Second action: Cancel, View receipt |
| **Accent (gold)** | `gold-400` | `#1F2937` (6.98) | — | Special emphasis, max one per screen: Donate, Register for event |
| **Text** | Transparent | `green-600` | — | Low emphasis: Skip, See all, Resend code |
| **Destructive** | `error #B42318` | White (6.57) | — | Void, Delete account, Reject |
| **Destructive outline** | Transparent | `error` | 1.5 dp `error` | Log out, Remove role |
| **Icon button** | Transparent / `neutral-50` on press | `neutral-800` or `green-600` | — | App bar actions |
| **FAB** | `green-600` | White icon (+ optional label = extended FAB) | — | Create action on list screens (staff) |

### Sizes

| Size | Height | Padding (h) | Text | Use |
|---|---|---|---|---|
| Large | 52 dp | 24 | `label-lg` | Full-width form submits, auth screens |
| Medium | 44 dp | 20 | `label-lg` | Default |
| Small | 36 dp (touch area still 48) | 12 | `label-md` | Inside cards, chips-like actions |

### States

| State | Change |
|---|---|
| Pressed | Primary → `green-700`; gold → `gold-500`; ripple (Android) / opacity 0.85 (iOS) |
| Disabled | `neutral-100` background, `neutral-500` text; not focusable |
| Loading | Spinner replaces leading icon, label kept, width fixed, disabled |
| Focus (keyboard / switch access) | 2 dp `green-600` outline, 2 dp offset |

Rules: radius `radius-md` 12; optional leading icon 20 dp; labels in sentence case; full-width buttons on forms with 16 dp side margins; button labels may wrap to 2 lines for Somali.

---

## 2. Input Fields — `AppTextField` and family

### Anatomy
```
Label (body-md, neutral-800)            * required marker
┌──────────────────────────────────────────┐
│ [lead icon]  Input text (body-lg)   [trail]│  height 52 dp, radius 8
└──────────────────────────────────────────┘
Helper text / error (caption)        0 / 140
```

| State | Border | Label / helper |
|---|---|---|
| Default | 1 dp `neutral-400` (3.59 ✅) | neutral |
| Focused | 2 dp `green-600` | label `green-600` |
| Filled | 1 dp `neutral-400` | — |
| Error | 2 dp `error` + error icon | helper becomes error message in `error` |
| Disabled | 1 dp `neutral-200`, bg `neutral-50` | text `neutral-500` |
| Read-only | No border, bg `neutral-50` | — |

Labels sit **above** the field (always visible — better for Somali long labels and for elders) instead of floating labels.

### Specialised inputs

| Component | Behaviour |
|---|---|
| `PhoneField` | Country code selector (flag + code, default from mosque country, e.g. +252) + number; always LTR; numeric keypad |
| `OtpField` | 6 boxes 48×56 dp, auto-advance, paste support, SMS autofill (Android SMS Retriever / iOS one-time-code); LTR in all languages |
| `PasswordField` | Show/hide toggle (eye icon), strength hint on register |
| `AmountField` | Large `figure` text 28 sp, currency prefix/suffix by locale, decimal keypad, thousands separators while typing, max 2 decimals |
| `SearchField` | Pill shape (radius-full), search icon, clear ✕, 44 dp |
| `DropdownField` / `SelectField` | Opens a **bottom sheet** list (with search when > 8 items) instead of a small menu |
| `DateField` / `TimeField` | Android: Material date/time picker; iOS: Cupertino wheel in a sheet. Shows Hijri date under the Gregorian date where relevant |
| `TextArea` | Min 3 lines, grows to 8, character counter |
| `SurahPicker` | Searchable sheet of 114 surahs: number, English/Somali name, Arabic name (Amiri), ayah count |
| `AyahRangeField` | Two numeric fields "From – To" validated against surah ayah count |
| `ImagePickerField` | Tile with camera icon → sheet: Take photo / Choose from gallery; shows thumbnail with remove ✕ |
| `SegmentedControl` | 2–4 options (e.g., Today / Month / Qibla); green-50 selected bg with green text |
| `Checkbox`, `Radio`, `Switch` | Platform-adaptive: Material on Android, Cupertino switch on iOS; green active color |
| `Chip` (filter/choice) | 32 dp, radius-sm; selected = green-50 bg + green text + ✓ icon |

Validation: validate on blur and on submit (not on every keystroke); first error field is scrolled into view and focused.

---

## 3. Cards — `AppCard` (base)

| Variant | Style | Use |
|---|---|---|
| **Standard** | White, radius-lg 16, padding 16, elevation 1 + `neutral-200` border | Most content |
| **Hero** | `gradient.hero`, radius-xl 24, padding 20, geometric pattern overlay | Next prayer, finance balance |
| **Tinted** | `green-50` or `gold-50` background, no border | Highlights, featured campaign, info |
| **Outlined** | White, 1 dp `neutral-200`, no shadow | Dense lists inside cards |
| **Media** | Image top (16:9), content below | Events, campaigns |

All tappable cards: ripple/opacity feedback, whole card is the hit area, trailing chevron when it navigates.

---

## 4. Navigation Bars — `AppBottomNavBar`

Full spec in [navigation-flow.md §4](navigation-flow.md#4-bottom-navigation-bar-specification). 5 items, green active pill, badges, mirrors in RTL.

Also:
- `AppTabBar` (top tabs, scrollable when > 3) — underline indicator 3 dp `green-600`.
- `AppSegmentedControl` — for 2–4 sibling views inside a tab.

---

## 5. App Bars — `AppTopBar`

| Variant | Height | Background | Content |
|---|---|---|---|
| Home | 64 | `neutral-25` (blends with page) | Mosque logo 32 dp (arch mask) + name `title-md` + ▾ · bell |
| Large title | 56 + 52 expanded | `neutral-25` | Collapses to small title on scroll |
| Standard | 56 (Android) / 44 + status (iOS) | White, elevation 0 → 2 on scroll | Back, title, actions |
| Transparent | 56 | none | White icons over gradient/photo |
| Green | 56 | `green-600` | White title & icons — used in Manage screens to signal "staff area" (*decision DD-04*) |

iOS: title centered; Android: title start-aligned. Back icon: Android arrow, iOS chevron; both mirror in RTL.

---

## 6. Dialogs — `AppDialog`

| Type | Content | Buttons |
|---|---|---|
| Confirmation | Title, 1–2 lines body | Cancel (text) · Confirm (primary) |
| Destructive confirmation | Title, consequence text, optional required reason field | Cancel · Void / Delete (destructive) |
| Information | Title, body, optional illustration | OK |
| Success (full) | Check icon in green circle, title, body | Done / View |

Spec: width = screen − 48 dp (max 400), radius-lg, padding 24, scrim 50%. Android: Material dialog; iOS: same visual style but buttons stack vertically when labels are long. Never more than 2 actions. Destructive actions are never the default focus.

---

## 7. Bottom Sheets — `AppBottomSheet`

| Type | Use |
|---|---|
| Action sheet | List of actions (Share, Edit, Void) |
| Picker sheet | Select field options, surah picker, mosque switcher |
| Form sheet | Short forms (filters, reason for rejection) |
| Review sheet | "Confirm donation" summary before saving |

Spec: top radius 24, drag handle 32×4 dp `neutral-200`, max height 90% of screen, content scrolls, primary action in sticky footer above safe area, dismiss by drag/tap scrim (except when form is dirty → confirm discard).

---

## 8. Prayer Time Cards

### 8.1 `NextPrayerHeroCard`
```
┌────────────────────────────────────────────┐  gradient.hero + pattern
│ NEXT PRAYER                  ☀ Asr icon    │  overline green-100
│ Asr                                        │  headline white
│ 03:42:18                                   │  countdown gold-300 (5.69)
│ Adhan 3:31 PM  ·  Iqamah 3:45 PM           │  body-md white
│ 17 Jumādā al-Ūlā 1448 · Wed 11 Nov         │  caption green-100
└────────────────────────────────────────────┘
```
- Countdown updates every second (tabular).
- Within 10 min of Iqamah: subtitle "Iqamah in 8 min" with gold pulse dot.
- Tap → Prayer tab.

### 8.2 `PrayerTimeRow` / `PrayerTimeCard`
```
[icon]  Dhuhr            12:05 PM      12:30 PM     🔔
        name title-sm    Adhan figure  Iqamah figure reminder toggle
```
States: **past** (text `neutral-500`), **next** (gold-50 background, 4 dp gold-400 start border, label "Next" chip in dark text on gold), **current** (green-50 background). Sunrise row has no Iqamah and no reminder (shown as "—").

### 8.3 `PrayerStrip` (compact, Home)
Horizontal row of 5 prayers: icon, name (caption), time (figure 14). Next prayer chip highlighted gold with dark text. Horizontally scrollable on very small screens.

### 8.4 `JumuahCard`
Mosque icon, "Jumu'ah", khutbah time, prayer time, language chip(s), location note.

---

## 9. Donation Cards

### 9.1 `CampaignCard` (media card)
```
┌─────────────────────────────┐
│ [photo 16:9]   [Featured]   │  badge gold-400 + dark text
├─────────────────────────────┤
│ New Roof Project            │  title-md
│ ███████████░░░░░  68%       │  bar gold-400 on gold-100 + % label
│ $6,800 raised of $10,000    │  figure
│ 12 days left       [Donate] │  gold accent button (small)
└─────────────────────────────┘
```

### 9.2 `DonationListItem` (history / ledger)
```
[type icon]  Sadaqah · EVC Plus            $25.00
             11 Nov 2026 · #MSQ12-2026-000154  [Voided]
```
Amount right-aligned (`figure`), start-aligned text. Voided: strikethrough amount + `error` chip "Voided". Pending (expense): `warning` chip.

### 9.3 `PaymentMethodCard` ("How to donate")
Method logo/icon, account name, number in large LTR `figure`, **Copy** button (snackbar "Number copied"), optional instructions text.

### 9.4 `DonationSummaryCard`
Tinted green-50: "Total this year $480.00 · 14 donations", with period selector.

### 9.5 `ReceiptView`
Paper-like white card with mosque logo, receipt number, date, donor, type, method, reference, amount (display), "Thank you" message and a decorative gold divider; actions: Share PDF · Download.

---

## 10. Event Cards

### 10.1 `EventCard` (media)
Date badge (top-start): day number `title-lg` + month `caption` in white on `green-600` rounded square; image; title; time & location rows with icons; audience chip (Men / Women / All); registration status ("Registered ✓" green chip / "12 seats left" / "Full").

### 10.2 `EventListTile` (compact)
Date block · title · time · chevron. Used in Home "Upcoming" and calendar day lists.

---

## 11. Notification Cards — `NotificationTile`

```
● [icon in tinted circle]  Iqamah times updated            2h
                           Dhuhr Iqamah is now 12:45 from tomorrow.
```
- Unread: green dot + `title-sm` bold + `green-50` tint background. Read: normal weight, white.
- Icon tint by category: prayer (green), announcement (green), event (gold-50 bg with gold-800 icon), approval (warning), finance (green), class (info).
- Urgent announcement: `error` tinted start border + "Urgent" chip; pinned at top of feed.
- Swipe actions: mark read / delete (reversed in RTL).
- Grouped by **Today / Yesterday / Earlier**.

`AnnouncementCard` (feed): optional image, priority chip, title, 2-line preview, author role ("Imam"), time.

---

## 12. Dashboard Statistics Cards — `StatCard`

```
┌──────────────────────┐
│ [icon]   ↑ 12%       │  trend chip: success/error tint
│ $4,250.00            │  display/figure
│ Donations this month │  body-md neutral-500
└──────────────────────┘
```
- 2-column grid on phones (1 column at ≥ 200% text scale).
- Variants: money, count, percentage (with mini ring), alert (warning tint: "3 pending approvals").
- Tap opens the filtered list.
- Optional sparkline (green-400 line) on finance cards.

Related: `QuickActionTile` (icon in 48 dp green-50 circle + label below, 2–4 per row), `SectionHeader` (title-lg + "See all ›" text button).

---

## 13. Other Shared Components

| Component | Spec |
|---|---|
| `AppListTile` | 56–72 dp, leading icon/avatar, title, subtitle, trailing value/chevron; divider inset 16 |
| `AppAvatar` | Circle 32/40/56/96 dp; initials on `green-50` with `green-800` text when no photo |
| `MosqueLogo` | Arch-mask image; placeholder = mosque icon on green-50 |
| `StatusChip` | Icon + label; colors from semantic tokens (Approved, Pending, Rejected, Voided, Present, Absent, Late, Excused) |
| `Badge` | Count badge `error` bg + white text (min 16 dp); "New" badge gold-400 + dark text |
| `AppSnackbar` | `neutral-800` bg, white text, optional action (Undo / View) in `gold-300` (high contrast on dark) |
| `Banner` | Full-width inline: offline (warning), pending membership (info), suspended mosque (error) |
| `EmptyState` | Illustration 160 dp, title-md, body-md, primary action |
| `SkeletonLoader` | `neutral-50` → `neutral-100` shimmer (static when reduced motion) |
| `ProgressBar` | Linear 8 dp radius-full; gold for campaigns, green for attendance %/memorization |
| `ProgressRing` | Attendance % and Hifz progress (juz completed of 30) |
| `AttendanceToggle` | Row: avatar · name · 4-state segmented (P / A / L / E) with icons + labels; tap row cycles state |
| `FilterBar` | Horizontal chips + "Filter" button opening filter sheet; active filter count badge |
| `DateGroupHeader` | Sticky caption header for grouped lists |
| `ConfirmReviewList` | Key-value rows used in review sheets and details |

---

## 14. Accessibility Checklist for Every Component

- Touch target ≥ **48×48 dp** (iOS ≥ 44 pt) — even when the visual is smaller.
- Semantic label for icons; state announced (e.g., "Present, selected").
- Contrast values from [color-palette.md](color-palette.md) only.
- Works at 200% text scale (wrap, never clip).
- Focus order follows reading order (and mirrors in RTL).
- Color is never the only signal.
