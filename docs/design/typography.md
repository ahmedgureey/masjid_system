# Typography

Phase 3 – UI/UX Design · v1.0 · 2026-11-11

The app must read well in **English**, **Somali** (Latin script) and **Arabic** (right-to-left). The type system uses two UI families that are designed to sit together, plus one traditional family for Qur'anic and decorative Arabic.

---

## 1. Font Families

| Role | Family | Why | License |
|---|---|---|---|
| UI — Latin (English, Somali) | **Inter** | Very legible at small sizes on low-DPI screens; large x-height; **tabular numerals** for prayer times and money; variable weights; neutral and professional | SIL OFL 1.1 |
| UI — Arabic | **Noto Sans Arabic** | Clean modern Naskh-style UI face, wide weight range (100–900), matches Inter's tone and weight; excellent RTL shaping | SIL OFL 1.1 |
| Qur'anic & decorative Arabic | **Amiri** (and **Amiri Quran** for āyāt) | Classical Naskh, proper harakāt and Qur'anic marks; gives the premium Islamic feel for Bismillah, āyah quotes, splash | SIL OFL 1.1 |

### Rules
- Fonts are **bundled in the app** (assets), not downloaded at runtime — works offline, consistent first render.
- Bundle only weights used: Inter 400/500/600/700; Noto Sans Arabic 400/500/600/700; Amiri 400/700; Amiri Quran 400.
- The UI font follows the **app language**: Inter for `en`/`so`, Noto Sans Arabic for `ar`. Mixed content (an Arabic surah name inside an English screen) uses font fallback — Inter first, Noto Sans Arabic second.
- **Amiri is never used for UI controls** (buttons, inputs, tabs). It is used only for: Bismillah on splash, Qur'anic quotes, surah names in the Arabic column of the progress list, and decorative mosque name in Arabic.

> Alternative considered: *IBM Plex Sans + IBM Plex Sans Arabic* (also a matched pair, OFL). Inter was preferred for better small-size legibility and tabular figures. Decision can be revisited during visual design review.

---

## 2. Type Scale (Latin — Inter)

Sizes in **sp** (Android) = **pt** (iOS). Line heights chosen on a 4-pt rhythm.

| Token | Size / Line height | Weight | Letter spacing | Use |
|---|---|---|---|---|
| `display` | 32 / 40 | 700 | -0.5 | Splash title, big totals on finance dashboard |
| `countdown` | 40 / 48 | 600, **tabular** | -0.5 | Next-prayer countdown in hero card |
| `headline` | 24 / 32 | 700 | -0.25 | Screen titles (large title on iOS-style scroll) |
| `title-lg` | 20 / 28 | 600 | 0 | Section headers, dialog titles |
| `title-md` | 18 / 26 | 600 | 0 | Card titles, app bar title |
| `title-sm` | 16 / 24 | 600 | 0 | List item titles |
| `body-lg` | 16 / 24 | 400 | 0 | Main body text, form input text |
| `body-md` | 14 / 20 | 400 | 0.1 | Secondary body, descriptions |
| `label-lg` | 16 / 24 | 600 | 0.1 | Buttons |
| `label-md` | 14 / 20 | 500 | 0.1 | Chips, tabs, nav labels (selected = 600) |
| `caption` | 12 / 16 | 500 | 0.2 | Timestamps, helper text, badges |
| `overline` | 11 / 16 | 600, UPPERCASE (Latin only) | 0.8 | Small section labels ("TODAY") |
| `figure` | any size, **tabular** | 600 | 0 | Money amounts, times, statistics |

Minimum readable size: **12 sp**. Nothing smaller, including bottom-nav labels.

---

## 3. Arabic Adjustments (Noto Sans Arabic)

Arabic glyphs are visually smaller and need more vertical room for ascenders, descenders and diacritics.

| Rule | Value |
|---|---|
| Size | Latin size **+2 sp** for body and labels (e.g., body-lg 16 → 18) ; headlines +2 sp |
| Line height | ≈ **1.6×** font size (vs 1.4–1.5× for Latin) |
| Letter spacing | **Always 0** — positive letter spacing breaks Arabic joining |
| Uppercase / overline | Not applicable — `overline` becomes `caption` weight 600 |
| Italic | Never used in Arabic; use weight or color for emphasis |
| Text alignment | Use `start`/`end` (directional), never hard-coded `left`/`right` |

### Arabic scale

| Token | Arabic size / line height |
|---|---|
| `display` | 34 / 54 |
| `headline` | 26 / 42 |
| `title-lg` | 22 / 36 |
| `title-md` | 20 / 32 |
| `title-sm` | 18 / 28 |
| `body-lg` | 18 / 29 |
| `body-md` | 16 / 26 |
| `label-lg` | 18 / 28 |
| `label-md` | 16 / 24 |
| `caption` | 14 / 22 |

### Qur'anic text (Amiri Quran)
- Minimum 22 sp, line height 2.0× (room for harakāt and waqf marks).
- Always RTL, centred or start-aligned; never truncated with "…".
- Āyah numbers in the ornamental end-of-āyah sign ( ۝ ) when shown.

---

## 4. Somali Language Considerations

- Somali uses the Latin alphabet without special diacritics, so Inter covers it fully. Apostrophe-like glottal stop (e.g., *Jimce*, *ka'*) uses the normal apostrophe `'`.
- Somali words and labels are often **20–40% longer** than English (e.g., "Notifications" → "Ogeysiisyada", "Donation history" → "Taariikhda deeqaha").
  - Buttons and tabs must allow **2-line wrapping** or adapt width; never clip.
  - Bottom-nav labels must be short — use the approved short labels in [navigation-flow.md](navigation-flow.md#5-bottom-navigation-labels).
- A native Somali speaker reviews all strings before release (Phase 1 NFR-L10N).

---

## 5. Numbers, Dates and Times

| Item | Rule |
|---|---|
| Digits | Western digits (0–9) by default in all languages for times and money (consistent with mobile-money receipts). Arabic users can switch to Eastern Arabic digits (٠١٢٣) in Settings — *Open decision DD-03*. |
| Tabular figures | Required for times, countdowns, amounts and tables (columns align, countdown does not "jump"). |
| Time format | Follows device 12/24-hour setting. Prayer times show `AM/PM` in small caption weight when 12-hour. |
| Hijri date | Shown with Gregorian: "17 Jumādā al-Ūlā 1448 · 11 Nov 2026". In Arabic: "١٧ جمادى الأولى ١٤٤٨" when Eastern digits are on. |
| Currency | Symbol per mosque currency; amount bold `figure` style; code shown in lists when ambiguous ("$ 50.00 USD"). |
| Phone numbers | Always displayed LTR, even in Arabic UI (wrapped in a direction isolate). |

---

## 6. Bidirectional (Mixed-Direction) Text

- User-entered names may be Latin or Arabic in any language mode — text fields detect direction from the first strong character.
- Phone numbers, receipt numbers (`MSQ12-2026-000154`), amounts and email addresses are forced **LTR** inside RTL layouts.
- Mixed strings (e.g., "Surah الفاتحة, ayah 1–7") are composed from separate text spans, not concatenated strings, so each part keeps its direction.

---

## 7. Accessibility

- All sizes scale with the system font size setting up to **200%**; layouts are tested at 100%, 130% and 200% (see [responsive-guidelines.md](responsive-guidelines.md)).
- The countdown and display sizes are capped at 1.3× scaling to avoid overflow; body text is never capped.
- Body text color is `neutral-800 #1F2937` (14.68:1). Secondary text `neutral-500 #6B7280` (4.83:1) is the lightest allowed text color on white.
- Line length for long text (announcement detail, About) is limited to ~70 characters on large screens.

---

## 8. Quick Reference

```
Screen title ........ headline 24/32 Bold           (AR 26/42)
Card title .......... title-md 18/26 SemiBold       (AR 20/32)
Body ................ body-lg 16/24 Regular         (AR 18/29)
Secondary ........... body-md 14/20 Regular #6B7280 (AR 16/26)
Button .............. label-lg 16/24 SemiBold       (AR 18/28)
Caption ............. caption 12/16 Medium          (AR 14/22)
Prayer countdown .... countdown 40/48 SemiBold tabular, gold-300 on green-800
Money ............... figure SemiBold tabular
```
