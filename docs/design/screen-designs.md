# Screen Designs

Phase 3 – UI/UX Design · v1.0 · 2026-11-11

Specification of every requested screen plus the management interfaces for Mosque Admin, Treasurer, Imam and Teacher. Each screen has: purpose, users, wireframe (text), components, behaviour, states, and platform/RTL notes. Screen IDs link to [../screen-list.md](../screen-list.md); components link to [reusable-components.md](reusable-components.md).

Wireframes are **low-fidelity text layouts** for structure. Colors, type and spacing follow the tokens in the design system. Width shown ≈ 375 dp baseline.

## Contents

**Requested screens**
1. [Splash](#1-splash-screen) · 2. [Onboarding](#2-onboarding) · 3. [Login](#3-login) · 4. [Registration](#4-registration) · 5. [Home Dashboard](#5-home-dashboard) · 6. [Prayer Times](#6-prayer-times) · 7. [Donations](#7-donations-give) · 8. [Donation History](#8-donation-history) · 9. [Events](#9-events) · 10. [Quran Classes](#10-quran-classes) · 11. [Notifications](#11-notifications) · 12. [User Profile](#12-user-profile) · 13. [Settings](#13-settings) · 14. [About Application](#14-about-application)

**Supporting screen:** [Find Mosque](#15-find-mosque-supporting)

**Management interfaces:** [Mosque Admin](#m1-mosque-admin) · [Treasurer](#m2-treasurer) · [Imam](#m3-imam) · [Teacher](#m4-teacher)

**[Review & open design decisions](#review--open-design-decisions)**

---

## 1. Splash Screen

**ID:** S-AUTH-01 · **Users:** everyone · **Purpose:** brand moment while the app checks session, app version and loads cached prayer data.

```
┌───────────────────────────────┐  gradient.splash (green-800 → green-900)
│                               │  + geometric pattern 6%
│                               │
│            ╭───╮              │
│           ( 🕌 )              │  App mark: gold-400 mosque/crescent, 96 dp
│            ╰───╯              │
│                               │
│     بِسْمِ ٱللَّٰهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ    │  Amiri 22, gold-300 (5.69)
│                               │
│     Masjid Management         │  display 32, white
│     Maamulka Masjidka         │  body-md, green-100 (subtitle in UI language)
│                               │
│             ◌                 │  small progress indicator (white) after 1.5 s only
│                               │
│          v1.0.0               │  caption green-100
└───────────────────────────────┘
```

**Behaviour**
- Native splash (OS) → in-app splash with fade-in of the mark (350 ms). Maximum 2 s if data is ready; spinner appears only if checks take > 1.5 s.
- Routes to: Language (first launch) · Welcome (logged out) · Find Mosque (no mosque) · Home (normal) · Force Update (S-AUTH-11) if below minimum version.
- Offline: continues to Home with cached data and offline banner.

**Notes:** status bar icons light; no buttons. RTL: centered layout — no change. Reduced motion: no fade scale.

---

## 2. Onboarding

**IDs:** S-AUTH-02 Language · S-AUTH-03 Slides · **Users:** first launch

### 2a. Language selection
```
┌───────────────────────────────┐  neutral-25 bg, pattern header band (green-800, 120 dp)
│  [app mark]                   │
│  Choose your language         │  headline
│  Dooro luqadda · اختر اللغة     │  body-md neutral-500
│                               │
│  ┌─────────────────────────┐  │
│  │ English            ( )  │  │  selectable cards 64 dp, radio
│  ├─────────────────────────┤  │
│  │ Soomaali           (•)  │  │  selected: green-50 bg, 2 dp green border, ✓
│  ├─────────────────────────┤  │
│  │ العربية             ( )  │  │  label in its own script/font
│  └─────────────────────────┘  │
│                               │
│  [        Continue         ]  │  primary large
└───────────────────────────────┘
```
Default selection = device language if supported, else Somali (*confirm, DD-12*). Choosing Arabic switches the layout to RTL immediately (live preview).

### 2b. Onboarding slides (3)
```
┌───────────────────────────────┐
│                       Skip    │  text button (top-end)
│   ┌───────────────────────┐   │
│   │   [illustration in    │   │  arch-masked illustration, green + gold line art
│   │    mihrab arch]       │   │  ~45% of height
│   └───────────────────────┘   │
│                               │
│   Never miss a prayer         │  headline, centered
│   Accurate prayer and Iqamah  │  body-lg neutral-500, max 3 lines
│   times from your mosque.     │
│                               │
│          ● ○ ○                │  page dots: active green-600 pill
│  [          Next          ]   │  primary large; last slide: "Get started"
└───────────────────────────────┘
```

| Slide | Title | Message | Illustration |
|---|---|---|---|
| 1 | Never miss a prayer | Prayer and Iqamah times, reminders and Qibla for your mosque | Mosque + crescent + clock |
| 2 | Give with trust | Support your mosque and see how donations help | Hand with coin + lantern |
| 3 | Learn and stay connected | Qur'an classes, events and announcements in one place | Open Qur'an on rehal + calendar |

**Behaviour:** swipe or Next; Skip → Welcome. Shown once. RTL: swipe direction and dots reversed. Small heights: illustration shrinks to 35%.

---

## 3. Login

**IDs:** S-AUTH-04 Welcome · S-AUTH-05 Phone · S-AUTH-06 OTP · S-AUTH-07 Email login · S-AUTH-09 Forgot password

### 3a. Welcome / Login entry
```
┌───────────────────────────────┐
│ ▓▓▓▓▓▓ green-800 header ▓▓▓▓▓ │  curved bottom edge (arch), pattern, app mark
│ ▓▓   Assalamu alaikum   ▓▓▓▓▓ │  title-lg white
│ ▓▓  Welcome to Masjid App ▓▓▓ │  body-md green-100
│╰─────────────────────────────╯│
│  Log in                       │  headline
│  [ Phone ] [ Email ]          │  segmented control
│                               │
│  Phone number                 │
│  ┌─────┬──────────────────┐   │
│  │🇸🇴+252│ 61 234 5678       │   │  PhoneField (LTR)
│  └─────┴──────────────────┘   │
│                               │
│  [      Send code       ]     │  primary large
│                               │
│  ─────────  or  ─────────     │
│  New here?  Create account    │  text button
│                               │
│  Continue as guest ›          │  text button (prayer times only) — DD-13
│  Terms · Privacy              │  caption links
└───────────────────────────────┘
```
**Email tab:** Email field, Password field (show/hide), "Forgot password?" text button (end-aligned), primary "Log in".

### 3b. OTP verification
```
┌───────────────────────────────┐
│ ←                             │
│  Enter the code               │  headline
│  We sent a 6-digit code to    │  body-md
│  +252 61 234 5678  Edit       │  number LTR, "Edit" text button
│                               │
│  [ 4 ][ 8 ][ 1 ][ _ ][ _ ][ _ ]│  OtpField, auto-submit on 6th digit
│                               │
│  Resend code in 0:45          │  caption → becomes "Resend code" text button
│  [        Verify         ]    │  primary (enabled when 6 digits)
└───────────────────────────────┘
```
**States:** wrong code → boxes shake (no shake with reduced motion) + error text "The code is wrong. Try again (2 attempts left)"; too many attempts → cooldown message; expired → "Code expired · Resend".

**Forgot password (email):** single email field → "Send reset link" → success screen with "Open email app".

**Platform:** OTP autofill (Android SMS Retriever, iOS one-time-code). Keyboard numeric. RTL: layout mirrors; phone and OTP stay LTR.

---

## 4. Registration

**IDs:** S-AUTH-08 Register · S-AUTH-06 OTP · S-AUTH-10 Complete profile

### 4a. Create account
```
┌───────────────────────────────┐
│ ←  Create account             │
│  [ Phone ] [ Email ]          │
│                               │
│  Full name *                  │
│  [ Ahmed Abdi Hassan       ]  │
│  Phone number *               │
│  [+252][ 61 234 5678       ]  │
│  (Email tab: Email *, Password *, Confirm password *, strength hint)
│                               │
│  ☐ I agree to the Terms of    │  checkbox, links
│     Use and Privacy Policy    │
│                               │
│  [     Create account     ]   │  primary large (sticky above keyboard)
│  Already have an account? Log in
└───────────────────────────────┘
```
→ OTP screen (same as login) → Complete profile.

### 4b. Complete profile
```
┌───────────────────────────────┐
│  Complete your profile   1/1  │
│         ( 📷 avatar )         │  96 dp, "Add photo" (optional)
│  Gender                       │
│  ( ) Male   ( ) Female        │  needed for gender-specific classes/events
│  Preferred language           │
│  [ Soomaali            ▾ ]    │  pre-filled
│                               │
│  [        Continue        ]   │
│  Skip for now                 │  text (only photo optional; gender required — DD-14)
└───────────────────────────────┘
```
Next: pending staff invitation screen (if any) → Find Mosque (if no mosque) → Home.

**Validation:** name ≥ 3 chars; phone valid for country; password ≥ 8 chars; inline errors on blur.

---

## 5. Home Dashboard

**ID:** S-HOME-01 (member), with role sections for S-HOME-02/03/05/06 · **Users:** all

```
┌───────────────────────────────┐
│ [logo] Masjid Al-Noor ▾    🔔³│  Home app bar (mosque switcher, bell badge)
│ Assalamu alaikum, Ahmed       │  title-lg
│ Wed 11 Nov · 17 Jumādā I 1448 │  body-md neutral-500
│ ┌───────────────────────────┐ │
│ │ NEXT PRAYER          ☀︎ Asr│ │  NextPrayerHeroCard
│ │ Asr                       │ │
│ │ 01:42:18                  │ │  gold-300 countdown
│ │ Adhan 3:31 · Iqamah 3:45  │ │
│ └───────────────────────────┘ │
│ Fajr  Dhuhr  [Asr]  Maghrib Isha│  PrayerStrip (next = gold chip, dark text)
│ 4:58  12:05  3:31   5:52   7:05│
│                               │
│ ┌───┐ ┌───┐ ┌───┐ ┌───┐       │  QuickActionTile ×4 (role-based)
│ │🕐 │ │🤲 │ │📅 │ │🧭 │       │
│ Times Donate Events Qibla     │
│                               │
│ ⚠ URGENT  Janazah prayer after│  pinned urgent AnnouncementCard (error border)
│   Dhuhr today for …        ›  │
│                               │
│ Announcements          See all│  SectionHeader
│ [AnnouncementCard]            │
│ [AnnouncementCard]            │
│                               │
│ Upcoming events        See all│
│ [EventListTile] [EventListTile]│
│                               │
│ Active campaign               │
│ [CampaignCard — compact]      │
├───────────────────────────────┤
│ 🏠Home 🕌Prayer 🤲Give 👥Community 👤Profile │  bottom nav (member)
└───────────────────────────────┘
```

### Role sections (inserted after quick actions)

| Role | Extra section on Home |
|---|---|
| Mosque Admin | `StatCard` row: Pending approvals (warning) · Join requests · Members · Balance |
| Treasurer | `StatCard` row: Donations this month · Expenses this month · Pending · Quick buttons [+ Donation] [+ Expense] |
| Imam | "Today's Iqamah" summary card with [Edit times] · Upcoming Jumu'ah card |
| Teacher | "Today's classes" card: class name, time, students count, [Take attendance] (primary small) |
| Student | "My learning" card: next class, attendance % ring, last lesson (surah/ayah) |

**Behaviour:** pull to refresh; sections hide when empty (except prayer); hero card tap → Prayer tab; urgent announcement pinned until expiry or dismissed.

**States:** skeleton for announcements/events; prayer from cache always available; pending membership → info banner under greeting "Your membership request is waiting for approval"; suspended mosque → error banner and limited content.

**Small screens:** hero capped 180 dp; prayer strip scrolls; quick actions 4 per row with 2-line labels.

**RTL:** greeting right-aligned; bell on the left; prayer strip order Fajr starts at right.

---

## 6. Prayer Times

**IDs:** S-PRAY-01 Today · S-PRAY-02 Month · S-PRAY-03 Qibla · **Users:** all

### 6a. Today
```
┌───────────────────────────────┐
│ Prayer times              ⚙︎  │  large title; ⚙︎ = reminder settings
│ [ Today ] [ Month ] [ Qibla ] │  segmented control
│ ┌───────────────────────────┐ │
│ │ Masjid Al-Noor · Hargeisa │ │  compact hero (gradient), pattern
│ │ Asr in 01:42:18           │ │  countdown gold-300
│ │ ‹  Wed 11 Nov 2026  ›     │ │  day switcher (prev/next day)
│ │    17 Jumādā al-Ūlā 1448  │ │
│ └───────────────────────────┘ │
│         Adhan    Iqamah   🔔  │  column header caption
│ 🌙 Fajr   4:58     5:20    🔔 │  PrayerTimeRow (past = muted)
│ 🌅 Sunrise 6:12     —      —  │
│ ☀︎ Dhuhr  12:05    12:30   🔕 │
│▌☀︎ Asr    3:31     3:45    🔔 │  NEXT: gold-50 bg + gold start border + "Next" chip
│ 🌇 Maghrib 5:52    5:57    🔔 │
│ 🌙 Isha   7:05     7:30    🔔 │
│ ┌───────────────────────────┐ │
│ │ 🕌 Jumu'ah                │ │  JumuahCard (Friday sessions)
│ │ Khutbah 12:15 · Prayer 12:45│ │
│ │ Somali · Arabic  Main hall│ │
│ └───────────────────────────┘ │
│ Method: Muslim World League · │  caption neutral-500, info icon → explanation sheet
│ Asr: Shafi'i                  │
└───────────────────────────────┘
```
**Bell per row:** toggles reminder for that prayer; long-press/⚙︎ opens reminder sheet (minutes before Adhan/Iqamah).

### 6b. Month
```
│ ‹  November 2026  ›     [Share]│  Share = v1.1 (staff)
│ Date      Fajr Dhuhr Asr Magh Isha│  sticky header
│ 1  Sun    4:55 12:02 3:30 5:55 7:07│
│ …                               │
│ 11 Wed ▌  4:58 12:05 3:31 5:52 7:05│  today highlighted green-50 row
```
Times shown = Adhan; toggle chip "Show Iqamah" swaps values. Hijri date as second line per row. Table uses `figure` 14 tabular; at 200% text scale switches to one card per day.

### 6c. Qibla
```
│        Qibla direction        │
│        ┌─────────────┐        │
│        │   compass   │        │  compass rose (neutral), needle green, Kaaba icon gold
│        │     ▲ 🕋    │        │  on gold-50 circle
│        └─────────────┘        │
│   Turn right 12°  · 41° from N│  instruction text; "Facing Qibla ✓" when aligned (+haptic)
│   ⓘ Keep phone flat, away from│
│     metal objects. Calibrate  │
```
**Permissions:** explainer card before location permission; fallback uses mosque location if permission denied. Low-accuracy sensor → calibration hint (figure-8). Compass **does not mirror** in RTL.

---

## 7. Donations (Give)

**IDs:** S-DON-07 Campaigns · S-DON-08 Campaign detail · S-DON-05 How to donate · **Users:** all (Give tab for members; Home quick action for others)

### 7a. Give tab
```
┌───────────────────────────────┐
│ Give                          │  large title
│ ┌───────────────────────────┐ │
│ │ 🤲 "The believer's shade on│ │  tinted gold-50 card, hadith/ayah short quote
│ │  the Day of Resurrection  │ │  (Amiri for Arabic text + translation)
│ │  will be his charity."    │ │  gold-800 text
│ └───────────────────────────┘ │
│ How to donate                 │  SectionHeader
│ [PaymentMethodCard: EVC Plus  │
│   Masjid Al-Noor             │
│   61 555 1234       [Copy]]  │
│ [PaymentMethodCard: Zaad …]   │
│ [Bank transfer ›]             │
│                               │
│ Campaigns              See all│
│ [CampaignCard Featured]       │
│ [CampaignCard]                │
│                               │
│ Donation types                │  info chips explaining Sadaqah, Zakat, Zakat al-Fitr, Waqf
│ (Sadaqah)(Zakat)(Waqf)(Fitr)  │  tap → short explanation sheet
│                               │
│ My donations ›                │  list tile → Donation History
└───────────────────────────────┘
```
**After paying:** helper text "After sending, show the confirmation SMS to the treasurer, or ask them to record it. Your receipt will appear in My donations." (v1.1: "I have donated" button submits the reference — S-DON-10.)

### 7b. Campaign detail
```
│ [cover photo 16:9, transparent app bar, share]│
│ New Roof Project                │ headline
│ ███████████░░░░ 68%             │ ProgressBar gold + label
│ $6,800 raised of $10,000        │ figure
│ 124 donations · 12 days left    │ caption
│ About this campaign …           │ body
│ How funds are used (TR/MA see   │ for staff: linked expenses list
│ linked expenses)                │
│ [         Donate now        ]   │ gold accent button, sticky bottom → How to donate sheet
```

**States:** no campaigns → section hidden; no payment details configured → info card "Contact the mosque office to donate" (and admin sees "Add payment details" CTA).

**Platform:** Copy → system clipboard + snackbar. Optional Android "Dial EVC Plus" shortcut — *DD-08*.

---

## 8. Donation History

**IDs:** S-DON-06 My donations · S-DON-04 Receipt · **Users:** members (own data only)

```
┌───────────────────────────────┐
│ ←  My donations               │
│ ┌───────────────────────────┐ │
│ │ Total in 2026             │ │  DonationSummaryCard (green-50)
│ │ $480.00                   │ │  display figure
│ │ 14 donations              │ │
│ └───────────────────────────┘ │
│ (2026 ▾) (All types ▾)        │  FilterBar chips: year, type, campaign
│ NOVEMBER                      │  DateGroupHeader (sticky)
│ 🤲 Sadaqah · EVC Plus   $25.00│  DonationListItem
│    11 Nov · #MSQ12-2026-000154│
│ 🌾 Zakat · Cash        $200.00│
│    02 Nov · #MSQ12-2026-000131│
│ OCTOBER                       │
│ 🏗 New Roof · Zaad      $50.00│
│ …                             │
└───────────────────────────────┘
```

### Receipt (tap an item)
```
┌───────────────────────────────┐
│ ✕  Receipt               ⤴︎    │  share
│ ┌───────────────────────────┐ │  ReceiptView (paper card)
│ │     [mosque logo]         │ │
│ │   Masjid Al-Noor          │ │
│ │   ─── ◆ gold divider ◆ ───│ │
│ │ Receipt  MSQ12-2026-000154│ │  LTR
│ │ Date     11 Nov 2026      │ │
│ │ Donor    Ahmed Abdi       │ │
│ │ Type     Sadaqah          │ │
│ │ Method   EVC Plus · 8842… │ │
│ │ Amount        $25.00      │ │  display
│ │ جزاك الله خيراً             │ │  Amiri, "May Allah reward you"
│ └───────────────────────────┘ │
│ [ Share PDF ]  [ Download ]   │
└───────────────────────────────┘
```
**States:** empty → illustration "No donations recorded yet · Learn how to give" (→ Give). Voided donation → "Voided" chip, receipt watermark "VOID". Offline → cached list, Share disabled with tooltip.

---

## 9. Events

**IDs:** S-EVT-01 List · S-EVT-03 Calendar · S-EVT-02 Detail · S-EVT-06 My registrations · **Users:** all (create/edit = MA, IM)

### 9a. Events (inside Community tab → Events)
```
┌───────────────────────────────┐
│ Community                     │
│ [Announcements][ Events ][Campaigns]│
│ [ Upcoming ] [ Past ]   📅 ⌕  │  segmented + calendar toggle + search
│ (All)(Lectures)(Ramadan)(Youth)│  category chips
│ ┌───────────────────────────┐ │
│ │[12]   [photo]             │ │  EventCard: date badge green
│ │ NOV                       │ │
│ │ Friday Night Halaqa       │ │
│ │ 🕐 7:30 PM – 9:00 PM       │ │
│ │ 📍 Main hall · (Men)      │ │
│ │ ✓ Registered              │ │  green chip  /  "12 seats left"
│ └───────────────────────────┘ │
│ [EventCard] …                 │
│                        ( + )  │  FAB — MA/IM only
└───────────────────────────────┘
```
**Calendar view:** month grid, dots on event days (green), selected day lists `EventListTile`s below. Week starts Saturday or Monday by locale (*Somalia commonly Saturday* — follows locale).

### 9b. Event detail
```
│ [photo, transparent bar, share, ⋮ (edit/cancel for MA/IM)]│
│ RAMADAN · LECTURE              │ overline category
│ Preparing for Ramadan          │ headline
│ 📅 Thu 12 Nov 2026 · 22 Jumādā I│
│ 🕐 7:30 – 9:00 PM  [Add to calendar] (v1.1)│
│ 📍 Main hall  [Open map]       │
│ 👥 All · 48/100 registered     │
│ About …                        │
│ Speaker: Sheikh …              │
│ [       Register        ]      │ gold accent, sticky; registered → "Cancel registration" (outline)
```
**States:** full → disabled button "Event full"; cancelled → error banner "This event was cancelled"; past → no button, "Event ended".
**Staff extras:** "Registrants (48) ›" row → registrants list with export.

---

## 10. Quran Classes

**IDs:** S-EDU-12 My learning (student) · S-EDU-02/04/09 (read views) · **Users:** students (Classes tab); teachers/admin see management versions (M4)

### 10a. My learning (student)
```
┌───────────────────────────────┐
│ Classes                       │
│ ┌───────────────────────────┐ │
│ │ Next class                │ │  hero (gradient)
│ │ Hifz Group A              │ │
│ │ Today · 4:00 PM · Room 2  │ │
│ │ Teacher: Macallin Yusuf   │ │
│ └───────────────────────────┘ │
│ ┌──────────┐ ┌──────────────┐ │
│ │ (ring)92%│ │ Juz 3 / 30   │ │  StatCards: attendance ring (green), memorization
│ │Attendance│ │ Memorized    │ │  progress ring
│ └──────────┘ └──────────────┘ │
│ Last lesson                   │
│ Al-Baqarah 142–157 · New      │  surah name + Arabic (Amiri) "البقرة"
│ ★ Good · "Focus on tajweed of │  quality chip + teacher note
│   ghunnah"                    │
│ My classes                    │
│ [Class tile: Hifz Group A · Sat–Wed 4–6 PM ›]│
│ [Class tile: Tajweed · Thu 5 PM ›]│
│ Progress history       See all│
│ [ProgressRow] [ProgressRow]   │
│ Attendance             See all│
│ ▢▢▣▢▢▢▣ (last 14 sessions)    │  mini calendar: icon + color per status
└───────────────────────────────┘
```
**Class detail (student view):** schedule, teacher, room, class announcements list.
**Progress history:** grouped by month; each row: date, type chip (New / Revision / Reading), surah + ayah range, quality, note.

**States:** not enrolled → empty state "You're not in a class yet. Contact the mosque office." **RTL:** surah lists show Arabic name first. Students without app accounts are managed by teachers only.

---

## 11. Notifications

**ID:** S-NOTI-04 Inbox (bell) · related S-NOTI-01/03 · **Users:** all

```
┌───────────────────────────────┐
│ ←  Notifications   Mark all read│
│ (All)(Prayer)(Events)(Classes)(Approvals)│  filter chips (role-based)
│ TODAY                         │
│ ● [🕐] Iqamah times updated  2h│  unread: green dot, bold, green-50 tint
│        Dhuhr Iqamah is 12:45 …│
│ ● [⚠] Expense waiting for    3h│  (Mosque Admin) warning icon
│        approval · $650.00     │
│ YESTERDAY                     │
│   [📅] Reminder: Halaqa       │  read: white bg
│        tonight 7:30 PM        │
│ EARLIER                       │
│   [📣] Eid prayer location …  │
└───────────────────────────────┘
```
**Behaviour:** tap → deep link + mark read; swipe → mark read/delete; badge count on bell clears as read. Push permission not granted → top info card "Turn on notifications to get prayer and event alerts [Turn on]".
**Empty:** "You're all caught up" illustration. **RTL:** dot and icon on right; swipe reversed.

---

## 12. User Profile

**IDs:** S-PROF-01 Profile · S-PROF-02 Edit · S-PROF-03 My mosques · **Users:** all

```
┌───────────────────────────────┐
│ Profile                       │
│        ( avatar 96 )          │
│      Ahmed Abdi Hassan        │  title-lg
│      +252 61 234 5678         │  LTR
│  (Member)(Teacher)            │  role chips for active mosque
│      [ Edit profile ]         │  secondary small
│ ┌───────────────────────────┐ │
│ │ 🕌 Masjid Al-Noor       ⇄ │ │  current mosque card → switcher sheet
│ │    Hargeisa · Member since 2025│
│ └───────────────────────────┘ │
│ MY ACTIVITY                   │
│ 🤲 My donations             › │
│ 📅 My event registrations   › │
│ 📖 My learning              › │  students only
│ PREFERENCES                   │
│ ⚙︎ Settings                  › │
│ 🌐 Language       Soomaali  › │
│ SUPPORT                       │
│ ⓘ About the app             › │
│ ✉ Contact support           › │
│                               │
│ [ Log out ]                   │  destructive outline + confirmation dialog
└───────────────────────────────┘
```
**Edit profile:** avatar (change/remove), full name, gender, email, phone (change requires OTP re-verification), Save (form app bar). 
**My mosques:** see navigation-flow §10.

---

## 13. Settings

**IDs:** S-SET-01 Settings · S-SET-02 Notifications · S-SET-03 Language · S-SET-06 Delete account · **Users:** all (admin section MA only)

```
┌───────────────────────────────┐
│ ←  Settings                   │
│ GENERAL                       │
│ Language            Soomaali ›│
│ Theme                  Light ›│  row hidden in MVP; appears when dark mode ships (v1.1)
│ Digits (Arabic only) Western ›│
│ NOTIFICATIONS                 │
│ Prayer reminders            › │
│ Announcements           [◉ ]  │  switches (platform-adaptive)
│ Events                  [◉ ]  │
│ Classes                 [◉ ]  │  role-based
│ Approvals               [◉ ]  │  MA/TR
│ MOSQUE ADMINISTRATION         │  Mosque Admin only
│ Mosque profile              › │
│ Mosque settings             › │
│ Payment details             › │
│ Audit log                   › │
│ PRIVACY & SECURITY            │
│ Privacy policy              › │
│ Terms of use                › │
│ Delete account              › │  error text
└───────────────────────────────┘
```

### Prayer reminders (S-SET-02)
Per prayer row: switch + "10 min before Iqamah" selector (sheet: At Adhan / 5/10/15/30 min before Adhan / before Iqamah). Sound: Notification tone / Short Adhan / Vibrate only (*DD-07*). Test reminder button.

### Delete account (S-SET-06)
Explanation list (what is deleted / what is kept anonymized), re-authentication (OTP/password), destructive button "Delete my account", typed confirmation not required (OTP is enough). Blocked state if last Mosque Admin with explanation and link to Staff.

---

## 14. About Application

**ID:** S-SET-05 · **Users:** all

```
┌───────────────────────────────┐
│ ←  About                      │
│        [app mark 72]          │  on green-50 arch shape
│     Masjid Management         │  title-lg
│     Version 1.0.0 (1)         │  caption; long-press copies build info
│ ┌───────────────────────────┐ │
│ │ Our mission               │ │  short text: transparent finances,
│ │ …                         │ │  organized education, connected community
│ └───────────────────────────┘ │
│ What's new                  › │  release notes
│ Rate the app                › │  store review
│ Share the app               › │
│ Contact support             › │  email / WhatsApp link
│ Privacy policy              › │
│ Terms of use                › │
│ Open-source licenses        › │  OS license page
│ Credits (fonts: Inter, Noto,  │
│ Amiri — SIL OFL)            › │
│                               │
│  Made with care for the Ummah │  caption, centered
└───────────────────────────────┘
```

---

## 15. Find Mosque (supporting)

**IDs:** S-MOSQ-01, S-MOSQ-02 · Needed by the new-user journey.

```
│ Find your mosque               │ headline
│ [⌕ Search by name or city   ] │ SearchField
│ [📍 Use my location] (v1.1)    │
│ RESULTS                        │
│ [logo] Masjid Al-Noor          │ list tile: city, members count
│        Hargeisa · 1.2k members ›│
│ …                              │
│ Can't find your mosque?        │
│ Register your mosque ›         │ → S-MOSQ-03
```
**Mosque profile:** cover photo, logo, name, address + map button, today's prayer times (compact), facilities chips, [Join mosque] primary sticky; pending state "Request sent".

---

# Management Interfaces

All management screens live under the **Manage** tab. Visual cue for the staff area: standard white app bar with a small role chip under the title (e.g., "Treasurer") — or a green app bar (*DD-04*). Same components as the member app.

## M1. Mosque Admin

### M1a. Admin dashboard (S-HOME-02)
```
┌───────────────────────────────┐
│ Manage            (Admin ▾)   │  role switcher if multiple roles
│ ┌──────────┐ ┌──────────┐     │
│ │⚠ 3        │ │👤 5      │     │  StatCards: Pending approvals (warning), Join requests
│ │Approvals │ │Requests  │     │
│ └──────────┘ └──────────┘     │
│ ┌──────────┐ ┌──────────┐     │
│ │$12,430    │ │1,204     │     │  Balance, Members
│ │Balance   │ │Members   │     │
│ └──────────┘ └──────────┘     │
│ This month                    │
│ [mini bar chart: income vs expenses, 6 months]│  green-600 vs neutral-400 bars + legend
│ MANAGE                        │
│ 👥 Members & staff          › │
│ 📖 Classes                  › │
│ 📅 Events                   › │
│ 📣 Announcements            › │
│ 💰 Finance overview         › │
│ 📊 Reports                  › │
│ 🕌 Mosque profile & settings › │
│ 🧾 Audit log                › │
└───────────────────────────────┘
```

### M1b. Pending approvals → Expense detail (S-FIN-06 / S-FIN-05)
```
│ ←  Expense                     │
│ [⏳ Waiting for approval]       │ warning StatusChip
│ $650.00                        │ display
│ Maintenance · Generator repair │
│ Payee: Hassan Electric         │
│ Date 10 Nov · Cash · Ref —     │
│ Recorded by Fatima (Treasurer) │
│ [receipt thumbnail → full view]│
│ History: created 10 Nov 14:05  │
│ ┌───────────┐ ┌──────────────┐ │ sticky bottom
│ │  Reject   │ │   Approve    │ │ destructive-outline + primary
│ └───────────┘ └──────────────┘ │
```
Reject → bottom sheet with required comment. Approve → confirmation dialog with amount. Own expense → buttons hidden + info "Another admin must approve".

### M1c. Members & staff (S-MEMB-01/03/04/05)
Tabs: **Members · Staff · Requests (5)**. Search + role filter chips. Requests list rows with [✓] [✕] buttons; swipe actions. FAB "Invite staff" → form: phone/email, roles (multi-select chips Imam/Treasurer/Teacher), message → Send.

---

## M2. Treasurer

### M2a. Finance dashboard (S-FIN-01)
```
┌───────────────────────────────┐
│ Finance          (Treasurer)  │
│ ┌───────────────────────────┐ │
│ │ Current balance           │ │  hero card (gradient)
│ │ $12,430.00                │ │  display white
│ │ ▲ $2,140 this month       │ │  green-100
│ └───────────────────────────┘ │
│ [+ Donation] [+ Expense] [+ Income]│  3 QuickActionTiles (primary emphasis on Donation)
│ ┌────────┐ ┌────────┐ ┌──────┐│
│ │$4,250  │ │$2,110  │ │⏳ 2   ││  StatCards: Donations, Expenses, Pending
│ └────────┘ └────────┘ └──────┘│
│ Recent transactions    See all│
│ [DonationListItem] ×5         │
│ Campaigns              See all│
│ Reports ›  Categories ›       │
└───────────────────────────────┘
```

### M2b. Record donation (S-DON-02) — the most important staff form
```
┌───────────────────────────────┐
│ ✕  Record donation            │
│        $ [  25.00  ]          │  AmountField large, autofocus, decimal keypad
│ Type                          │
│ (Sadaqah)(Zakat)(Fitr)(Waqf)(General)│  choice chips
│ Campaign (optional)           │
│ [ None                    ▾ ] │
│ Payment method                │
│ (Cash)(EVC Plus)(Zaad)(Sahal)(Bank)(Other)│
│ Reference number *            │  required for non-cash
│ [ 8842 1937               ]   │
│ Donor                         │
│ [⌕ Search member…         ]   │  or "Enter name" / toggle
│ Anonymous donor         [  ]  │
│ Date   [ Today, 11 Nov    ]   │
│ Note   [                  ]   │
│ [        Review         ]     │  primary sticky
└───────────────────────────────┘
```
→ **Review sheet** (ConfirmReviewList of all fields, amount large) → [Confirm & save] → **Success screen** with receipt preview: [Share receipt] [Record another] [Done].
Target: < 30 s; last used method remembered.

### M2c. Record expense (S-FIN-03)
Fields: amount, category (select sheet), payee, date, method, reference, note, **receipt photo** (`ImagePickerField`, camera first), campaign (optional). If amount ≥ threshold, inline info banner before saving: "This expense needs Mosque Admin approval". Save → status chip on detail.

### M2d. Ledger (S-FIN-02)
Search, FilterBar (date range, type, category, status, method), grouped by date, totals bar at top for current filter ("In $4,250 · Out $2,110"). Item → transaction detail with [Void] (destructive, reason required).

---

## M3. Imam

### M3a. Imam dashboard (S-HOME-03)
Today's Iqamah card (all 5 + Jumu'ah, [Edit]) · Quick actions: Iqamah times · Announce · + Event · Jumu'ah · Upcoming events list · Recent announcements with view counts (*future*).

### M3b. Prayer & Iqamah settings (S-PRAY-04)
```
┌───────────────────────────────┐
│ ✕  Iqamah times         Save  │
│ Effective from [ Tomorrow ▾ ] │
│ ┌───────────────────────────┐ │
│ │ Fajr   Adhan 4:58         │ │
│ │ ( Fixed )( After Adhan )  │ │  segmented per prayer
│ │ Iqamah [ 5:20 ]           │ │  TimeField or [+ 20 min] stepper
│ │ Adjust Adhan  [−] 0 [+] min│ │
│ └───────────────────────────┘ │
│ [Dhuhr card] [Asr card] …     │
│ Preview next 7 days         › │  table sheet
│ ☑ Notify members of changes   │
└───────────────────────────────┘
```
Save → confirmation "Members will be notified". Other screens: Jumu'ah sessions (list + add form), Special prayers (Taraweeh/Eid form), Calculation method (radio list with short descriptions + today preview).

### M3c. Compose announcement (S-NOTI-02) — shared with Admin & Teacher
```
│ ✕  New announcement     Post  │
│ Title *  [                  ] │
│ Message *[                  ] │  TextArea
│ [+ Add image] [+ Attach PDF]  │
│ Priority (Normal)(Important)(Urgent)│
│ Audience [ All members   ▾ ]  │  Teacher: own classes only
│ Publish  (Now)(Schedule…)     │
│ Expires  [ in 7 days     ▾ ]  │
│ Send push notification [◉ ]   │
│ [ Preview ]                   │  shows AnnouncementCard + push preview
```
Urgent → confirmation explaining it is pinned and pushed to everyone.

---

## M4. Teacher

### M4a. Teacher dashboard (S-HOME-05)
"Today" list of classes with time and [Take attendance] (done → "✓ Taken 4:05 PM"); quick actions: Take attendance · Add progress · My classes · Announce; "Needs attention" card: students with 3+ absences (*v1.1 alert logic, visual now*).

### M4b. Take attendance (S-EDU-06)
```
┌───────────────────────────────┐
│ ✕  Hifz Group A               │
│ Wed 11 Nov · 4:00 PM   20 students│
│ [All present ✓]  [Reset]      │  bulk actions
│ ✓18  ✕1  ⏱1  E0               │  live summary chips
│ ┌───────────────────────────┐ │
│ │(av) Abdirahman Ali        │ │
│ │ [✓ P][✕ A][⏱ L][E]        │ │  AttendanceToggle: selected = filled with status color + label
│ ├───────────────────────────┤ │
│ │(av) Bilal Hassan          │ │
│ │ [✓ P][✕ A][⏱ L][E]  ✎note │ │
│ └───────────────────────────┘ │
│ …                             │
│ [ Save attendance (20) ]      │  primary sticky
└───────────────────────────────┘
```
Tap row cycles status; segmented buttons for direct choice; selection haptic. Save → summary dialog → success snackbar. Edit window badge "Editable until 18 Nov". Offline (v1.1) → "Saved on device · will sync".

### M4c. Add Qur'an progress (S-EDU-08)
```
│ ✕  Progress · Bilal Hassan  Save│
│ Type (New)(Revision)(Reading)  │
│ Surah [ 2 · Al-Baqarah  البقرة ▾]│  SurahPicker
│ Ayah  [142] – [157]  of 286    │  AyahRangeField (validated)
│ Quality (Excellent)(Good)(Needs work)(Repeat)│
│ Note  [                    ]   │
│ Date  [ Today              ]   │
```
"Save & next student" secondary action for fast entry during class.

### M4d. Class detail (S-EDU-02)
Header: class name, level chip, schedule, room, teachers. Tabs: **Students · Attendance · Progress · Announcements**. Students list with attendance % and last lesson; FAB contextual (add student / take attendance).

---

# Review & Open Design Decisions

## Design review checklist (Phase 3 final review)

| Check | Result | Notes |
|---|---|---|
| All 14 requested screens specified | ✅ | Sections 1–14, plus Find Mosque |
| Management interfaces (Admin, Treasurer, Imam, Teacher) | ✅ | M1–M4 |
| Consistent components across screens | ✅ | Every screen uses components from reusable-components.md; same app bar/nav patterns |
| Color usage follows palette & gold rules | ✅ | No gold text on white; gold buttons use dark text; countdown gold-300 on green-800 |
| Color contrast (WCAG AA) | ✅ | All text pairs ≥ 4.5:1; input borders ≥ 3:1 (calculated values in color-palette.md) |
| Android layouts | ✅ | Back behaviour, edge-to-edge, gesture bar, Material pickers, 360 dp baseline + 320 dp check |
| iPhone layouts | ✅ | Dynamic Island/home indicator insets, edge-swipe back, large titles, iPhone SE height rule |
| Arabic RTL | ✅ | Mirroring rules, non-mirroring exceptions, Arabic type scale, bidi data |
| Navigation flow | ✅ | 5-tab skeleton, role center tab, ≤ 3 depth for frequent tasks, deep links |
| Empty / loading / error / offline states | ✅ | Defined globally (design-system §9) and per screen |
| Text scaling 200% | ✅ (spec) | Must be verified in hi-fi mockups / implementation |
| High-fidelity visual mockups | ⏳ | Not yet produced — see DD-05 |

## Missing design elements (identified)

1. **High-fidelity visual mockups / clickable prototype** — specs are complete, visuals are not yet drawn.
2. **Custom icon set** (prayer icons, Qibla, Sadaqah, Quran) — defined, needs drawing.
3. **Illustrations** (onboarding ×3, empty states ×~8) — defined, needs drawing.
4. **App icon & native splash artwork** — concept defined (gold mark on green), needs final artwork.
5. **Islamic geometric pattern asset** — needs one tileable vector.
6. **Somali UI copy** — labels proposed; native-speaker copy review pending.
7. **Report PDF layouts** (receipt, finance statement) — receipt defined; report templates to design with Reports module.
8. **Screens outside this brief** but in the Phase 1 screen list (mosque setup wizard, registration request, categories, campaign editor, event editor, class editor, Super Admin area) — follow the same patterns; detailed specs recommended before their sprints.

## Open design decisions (need owner input)

| ID | Decision | Recommendation |
|---|---|---|
| DD-01 | **Arabic at launch?** Phase 1 planned Arabic for v1.1; this brief requires Arabic RTL support. | Design is RTL-ready now. Ship Arabic in **MVP** only if translation + RTL QA time (~1–2 weeks) is accepted; otherwise v1.1. |
| DD-02 | Font pairing | Inter + Noto Sans Arabic + Amiri (all free, OFL) |
| DD-03 | Digits in Arabic UI | Western digits default, Eastern Arabic optional in Settings |
| DD-04 | Staff area visual cue | White app bar + role chip (calmer); green app bar is the alternative |
| DD-05 | How to produce hi-fi mockups | Option A: designer in Figma using these specs. Option B: an HTML visual prototype generated from these specs for quick review. |
| DD-06 | Somali labels | Native review of navigation labels (Hoyga, Salaadda, Deeq, Dugsi, Maamul, Bulshada, Akoonka) |
| DD-07 | Reminder sound | Notification tone + optional short Adhan clip (iOS limits notification sounds to 30 s; full Adhan not possible as a notification sound on iOS) |
| DD-08 | "Pay with EVC Plus" dial shortcut | Android only (iOS blocks USSD codes with * and # from apps) — show "Copy number" on both, dial shortcut Android-only, or skip in MVP |
| DD-09 | Per-mosque branding | Mosque logo/name only; app colors stay fixed (consistency, contrast) |
| DD-10 | Dark mode timing | Tokens ready; ship in v1.1 |
| DD-11 | Week start in calendars | Follow device locale |
| DD-12 | Default language when device language unsupported | Somali |
| DD-13 | Guest mode (prayer times without account) | Recommended — lowers barrier for new users; was not in Phase 1 requirements |
| DD-14 | Gender required at registration | Required (gender-specific classes/events); confirm culturally acceptable |
