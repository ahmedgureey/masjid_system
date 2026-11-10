# Design System

Phase 3 – UI/UX Design · v1.0 · 2026-11-11
Name: **Masjid Design System (MDS)**

This is the entry point to the design documentation. It defines the principles and foundations that every screen and component follows.

| Document | Content |
|---|---|
| [color-palette.md](color-palette.md) | Brand colors, scales, semantic colors, contrast, dark mode |
| [typography.md](typography.md) | Fonts for English, Somali, Arabic; type scale; RTL text |
| [reusable-components.md](reusable-components.md) | Buttons, inputs, cards, bars, dialogs, sheets, domain cards |
| [navigation-flow.md](navigation-flow.md) | Bottom navigation, role-based navigation, journeys |
| [screen-designs.md](screen-designs.md) | Every screen: layout, components, states |
| [responsive-guidelines.md](responsive-guidelines.md) | Android/iOS, screen sizes, RTL, text scaling |

Planning references: [../screen-list.md](../screen-list.md), [../user-flows.md](../user-flows.md), [../user-roles-permissions.md](../user-roles-permissions.md).

---

## 1. Design Principles

| # | Principle | In practice |
|---|---|---|
| 1 | **Calm & respectful** | Generous white space, soft surfaces, no loud colors or flashy motion. The app serves a place of worship. |
| 2 | **Prayer first** | The next prayer is always one glance away on Home, for every role. |
| 3 | **Simple for everyone** | Designed for elders, volunteers and non-technical treasurers: big targets, plain words, one main action per screen. |
| 4 | **Trust through clarity** | Money screens show exact amounts, status, who and when. Nothing financial happens without a confirmation. |
| 5 | **One app, many roles** | Same structure for all users; extra tools appear in the role tab — users never learn a second app. |
| 6 | **Works everywhere** | Low-end Android, small iPhones, slow networks, Arabic RTL, large text. |

---

## 2. Visual Identity

- **Color:** Primary Green `#176B45`, White, Gold accent `#D4AF37`, Dark Text `#1F2937`, Light Background `#F7F9F7`. 60/30/10 rule. Full rules in [color-palette.md](color-palette.md).
- **Islamic geometric motif:** a subtle 8-point star (khātam) tessellation, used only:
  - on Splash and Onboarding backgrounds,
  - inside hero cards (Home next-prayer card, Prayer screen header),
  - as empty-state illustrations background.
  Opacity 6–10%, never behind body text on white, never on forms.
- **Arch shape:** a soft mihrab-arch silhouette used as image mask for mosque logo placeholders and onboarding illustrations.
- **Illustration style:** flat, two-tone (green + gold) line illustrations; no human faces (respectful and culturally neutral); mosque silhouettes, crescent, lanterns, books, hands giving.
- **Photography:** real mosque photos uploaded by admins (cover, events). Always with rounded corners and, when text is on top, the `image.scrim` gradient.

---

## 3. Spacing

Base unit **4 dp**, layout grid **8 dp**.

| Token | Value | Typical use |
|---|---|---|
| `space-1` | 4 | Icon-to-label gap |
| `space-2` | 8 | Between chips, small gaps |
| `space-3` | 12 | Inside compact cards, list row vertical padding |
| `space-4` | 16 | **Screen side margin (compact phones)**, card padding |
| `space-5` | 20 | Screen side margin on ≥ 400 dp width |
| `space-6` | 24 | Between sections |
| `space-8` | 32 | Large section breaks, onboarding |
| `space-10` | 40 | Splash / empty-state vertical rhythm |

---

## 4. Shape (Corner Radius)

| Token | Radius | Use |
|---|---|---|
| `radius-sm` | 8 | Chips, badges, small buttons, input fields |
| `radius-md` | 12 | Buttons, list cards, snackbars |
| `radius-lg` | 16 | Main cards, dialogs |
| `radius-xl` | 24 | Hero cards, bottom sheets (top corners only) |
| `radius-full` | 999 | Avatars, pills, nav indicator, FAB |

---

## 5. Elevation & Surfaces

The design uses **tonal surfaces + soft shadows**, not heavy shadows.

| Level | Use | Shadow (light mode) |
|---|---|---|
| 0 | Page background `#F7F9F7` | none |
| 1 | Cards on background (white) | `0 1 2 rgba(31,41,55,0.06)` + 1 dp `neutral-200` border |
| 2 | Bottom nav, sticky headers | `0 -2 8 rgba(31,41,55,0.06)` |
| 3 | FAB, dropdown menus | `0 4 12 rgba(31,41,55,0.12)` |
| 4 | Dialogs, bottom sheets | `0 8 24 rgba(31,41,55,0.16)` + scrim |

In dark mode, shadows are replaced by lighter surfaces (`surface` → `surfaceRaised`).

---

## 6. Iconography

- Base set: **Material Symbols Rounded** (outlined for inactive, filled for active/selected), 24 dp, stroke weight 400. Rounded matches the soft visual style and is available on both platforms.
- On iOS, system-standard actions keep iOS conventions (share icon, back chevron).
- **Custom icons** (same 24 dp grid, 2 dp rounded stroke):

| Icon | Meaning |
|---|---|
| Fajr | Crescent over horizon line (dawn) |
| Sunrise | Half sun on horizon with up arrow |
| Dhuhr | Full sun high |
| Asr | Sun mid-low |
| Maghrib | Half sun setting, down arrow |
| Isha | Crescent with star |
| Jumu'ah | Mosque dome with minaret |
| Qibla | Compass needle with Kaaba cube |
| Mosque | Dome + minaret outline (logo placeholder) |
| Quran | Open book on stand (rehal) |
| Sadaqah | Open hand with coin |
| Iqamah | Two lines of people (rows) — abstract, no faces |

- Icons always have a text label or an accessibility label.
- Directional icons (back, forward, chevrons, "send") **mirror in RTL**. Non-directional icons (clock, search, compass, play) do **not** mirror.

---

## 7. Motion

| Token | Duration | Easing | Use |
|---|---|---|---|
| `motion-fast` | 150 ms | standard | Button press, toggles, chip select |
| `motion-base` | 250 ms | emphasized decelerate | Page transitions, sheets opening |
| `motion-slow` | 350 ms | emphasized | Hero card expansion, onboarding slides |

- Page transitions follow the platform: Android = Material shared-axis/fade-through; iOS = Cupertino slide with edge back-swipe.
- Countdown updates once per second without animation jitter (tabular figures).
- Respect **Reduce Motion** (iOS) / **Remove animations** (Android): replace movement with simple fades.
- No looping decorative animations except the subtle 2-second pulse on the "next prayer" marker (disabled with reduced motion).

---

## 8. Haptics & Feedback

| Event | Feedback |
|---|---|
| Save success (donation, attendance) | Light haptic + success snackbar |
| Destructive confirm (void, delete) | Medium haptic |
| Error | Error haptic (iOS notification-error) + inline message |
| Toggle attendance status | Selection haptic |

---

## 9. States (apply to every screen)

| State | Pattern |
|---|---|
| Loading (first load) | **Skeleton** placeholders shaped like the content (not a full-screen spinner) |
| Loading (action) | Button shows inline spinner, label stays; button disabled |
| Empty | Illustration + one-line explanation + primary action (e.g., "No events yet · Create event") |
| Error | Friendly message + "Try again" button; technical details hidden |
| Offline | Top `warning` banner "You're offline — showing saved data"; cached content still shown |
| Success | Snackbar (bottom) for 3–4 s; important results get a full success screen (e.g., donation receipt) |
| Permission needed | Explainer card before the OS prompt (location for Qibla, notifications) |
| Restricted | If a role cannot access something, the entry point is hidden, not disabled |

---

## 10. Voice & Tone

- Respectful, warm, short. Address the user directly ("Your donation was recorded").
- Islamic greetings where natural: Home greeting "Assalamu alaikum, Ahmed" (Somali: "Assalaamu calaykum", Arabic: "السلام عليكم").
- Plain words over jargon: "Record donation" not "Create transaction"; "Waiting for approval" not "Pending state".
- Errors explain what to do: "The OTP code is wrong. Check the SMS and try again."
- Islamic terms keep standard transliteration from the glossary (Fajr, Dhuhr, Asr, Maghrib, Isha, Jumu'ah, Iqamah, Sadaqah, Zakat).

---

## 11. Theming Model

- One light theme in MVP; dark tokens defined now (ships v1.1, decision D12 in planning).
- All colors referenced by **token names**, never raw hex in screens — enables dark mode and future white-label per mosque (e.g., mosque logo in app bar; brand colors stay fixed).
- Theme maps to Flutter `ThemeData` / `ColorScheme` (mapping in [color-palette.md §7](color-palette.md#7-flutter-colorscheme-mapping-for-phase-4-implementation)) and a custom extension for gold, semantic and gradient tokens.

---

## 12. Design Deliverables Status (Phase 3)

| Deliverable | Status |
|---|---|
| Design principles & foundations | ✅ this document |
| Color system with verified contrast | ✅ |
| Typography (EN / SO / AR) | ✅ |
| Component library specification | ✅ |
| Navigation & journeys | ✅ |
| Screen specifications with wireframes | ✅ (text/ASCII wireframes) |
| Responsive & RTL guidelines | ✅ |
| High-fidelity visual mockups (Figma or similar) | ⏳ Recommended next step — see open decisions in [screen-designs.md](screen-designs.md#review--open-design-decisions) |
