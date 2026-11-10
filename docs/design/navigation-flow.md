# Navigation Flow

Phase 3 – UI/UX Design · v1.0 · 2026-11-11

How users move through the app: app structure, role-based bottom navigation, dashboards, profile/settings navigation, and the user journeys for each user type. Screen IDs (`S-…`) come from [../screen-list.md](../screen-list.md).

---

## 1. Navigation Principles

1. **Same skeleton for every role.** Five bottom tabs in fixed positions. Only the **center tab** changes by role. A member who becomes a Treasurer does not need to re-learn the app.
2. **Prayer is always reachable** in one tap (tab 2) and visible on Home (hero card).
3. **Max depth 3** for frequent tasks: Tab → List → Detail/Form.
4. **One primary action per screen**, placed consistently (FAB or bottom button).
5. **Notifications live in the app bar** (bell with badge), not in a tab.
6. **Platform back behaviour is respected:** Android system back / predictive back; iOS edge-swipe back. Each tab keeps its own back stack.

---

## 2. App Structure (Information Architecture)

```
App launch
 └─ Splash (S-AUTH-01)
     ├─ First launch → Language (S-AUTH-02) → Onboarding (S-AUTH-03) → Welcome (S-AUTH-04)
     ├─ Not logged in → Welcome → Login (S-AUTH-05/07) | Register (S-AUTH-08) → OTP (S-AUTH-06) → Complete profile (S-AUTH-10)
     ├─ Logged in, no mosque → Find Mosque (S-MOSQ-01) → Mosque profile (S-MOSQ-02) → Join
     └─ Logged in with mosque → MAIN SHELL (bottom navigation)

MAIN SHELL
 ├─ 1 Home ............ greeting, next-prayer hero, quick actions, role cards, announcements, events
 ├─ 2 Prayer .......... Today | Month | Qibla (segmented)
 ├─ 3 [Role tab] ...... Give (member) | Classes (student) | Manage (staff) | Platform (super admin)
 ├─ 4 Community ....... Announcements | Events | Campaigns (segmented)
 └─ 5 Profile ......... profile, my donations, my registrations, my mosques, settings, about, logout

Global (from app bar): 🔔 Notifications (S-NOTI-04) · Mosque switcher sheet (S-PROF-03)
```

---

## 3. Role-Based Bottom Navigation

| Position | Mosque Member | Student | Staff (Admin / Imam / Treasurer / Teacher) | Super Admin |
|---|---|---|---|---|
| 1 | Home | Home | Home | Home (platform) |
| 2 | Prayer | Prayer | Prayer | Prayer |
| 3 | **Give** | **Classes** | **Manage** | **Platform** |
| 4 | Community | Community | Community | Community |
| 5 | Profile | Profile | Profile | Profile |

- **Give** for staff and students moves to a Home quick action ("Donate") and Profile ("My donations").
- If a user has **several roles** (e.g., Imam + Teacher), the **Manage** tab shows a role switcher at the top (segmented chips: *Imam · Teacher*). The last used role is remembered.
- A Student who is also staff sees **Manage**; their learning is reachable from Manage → "My learning" and from Home.

### Manage tab content by role

| Role | Manage home | Main sections |
|---|---|---|
| Mosque Admin | Admin dashboard (S-HOME-02) | Members & staff · Join requests · Approvals · Classes · Finance overview · Events · Announcements · Reports · Mosque profile & settings · Audit log |
| Imam | Imam dashboard (S-HOME-03) | Prayer & Iqamah settings · Jumu'ah · Special prayers · Announcements · Events · Education overview · Reports |
| Treasurer | Finance dashboard (S-FIN-01) | Record donation · Record expense · Record income · Ledger · Campaigns · Categories · Reports |
| Teacher | Teacher dashboard (S-HOME-05) | My classes · Take attendance · Students · Progress · Class announcements · Reports |

---

## 4. Bottom Navigation Bar Specification

| Property | Value |
|---|---|
| Height | 64 dp + bottom safe area (gesture bar / home indicator) |
| Items | Always 5; icon 24 dp + label `label-md` 12–14 sp |
| Inactive | Outlined icon, `neutral-500` label |
| Active | Filled icon `green-600`, label `green-600` weight 600, pill indicator `green-50` behind icon (64×32 dp) |
| Badge | Small `error` dot or count on the tab icon (e.g., Manage: pending approvals) |
| Background | White, elevation level 2 |
| Re-tap active tab | Scrolls to top; second re-tap pops to tab root |
| RTL | Order mirrors: Home is at the right edge in Arabic |
| Keyboard open | Bar hides |

Gold is intentionally **not** used for the active tab (gold on white fails contrast) — gold is reserved for prayer and highlights.

---

## 5. Bottom Navigation Labels

Short labels to avoid truncation (Somali strings to be confirmed by a native reviewer):

| Tab | English | Somali (proposed) | Arabic |
|---|---|---|---|
| Home | Home | Hoyga | الرئيسية |
| Prayer | Prayer | Salaadda | الصلاة |
| Give | Give | Deeq | تبرّع |
| Classes | Classes | Dugsi | الحلقات |
| Manage | Manage | Maamul | الإدارة |
| Platform | Platform | Nidaamka | المنصة |
| Community | Community | Bulshada | المجتمع |
| Profile | Profile | Akoonka | حسابي |

---

## 6. App Bar Patterns

| Type | Where | Content |
|---|---|---|
| **Home app bar** | Home tab | Mosque logo + mosque name (tap → mosque switcher sheet) · 🔔 bell with badge · (avatar on large screens) |
| **Tab root app bar** | Prayer, Community, Manage, Profile, Give | Large title (iOS-style collapse on scroll; Android: medium top app bar) · contextual actions (filter, search) |
| **Detail app bar** | Detail screens | Back · title · up to 2 actions (share, more ⋮) |
| **Form app bar** | Create/edit forms | Close ✕ (with discard confirmation if dirty) · title · Save (text button) — on long forms Save is also a sticky bottom button |
| **Transparent app bar** | Splash, onboarding, hero headers | Over gradient; white icons |

---

## 7. Dashboard Cards as Navigation

Home and Manage dashboards use cards as entry points:

- **Quick action grid** (2×2 or 4×1 icon tiles): one tap to the most frequent tasks for the role.
  - Member: Prayer times · Donate · Events · Qibla
  - Treasurer: + Donation · + Expense · Ledger · Reports
  - Teacher: Take attendance · Add progress · My classes · Announce
  - Imam: Iqamah times · Announce · + Event · Jumu'ah
  - Mosque Admin: Approvals · Join requests · Members · Reports
- **Statistic cards** are tappable and open the filtered list behind the number (e.g., "3 pending approvals" → Pending approvals list).
- **Section headers** have "See all ›" links to the full list.

---

## 8. Profile Menu

```
Profile (tab 5)
 ├─ Header: avatar, name, phone, role chips for active mosque, [Edit profile]
 ├─ My mosque
 │   ├─ My mosques / switch mosque ............ S-PROF-03
 │   └─ Mosque information .................... S-MOSQ-02
 ├─ My activity
 │   ├─ My donations .......................... S-DON-06
 │   ├─ My event registrations ................ S-EVT-06
 │   └─ My learning (students) ................ S-EDU-12
 ├─ Preferences
 │   ├─ Settings .............................. S-SET-01
 │   └─ Language (shortcut) ................... S-SET-03
 ├─ Support
 │   ├─ About the app ......................... S-SET-05
 │   └─ Contact support
 └─ Log out (error-colored text, confirmation dialog)
```

## 9. Settings Navigation

```
Settings (S-SET-01)
 ├─ General
 │   ├─ Language .............................. English / Soomaali / العربية
 │   ├─ Theme ................................. Light (Dark in v1.1)
 │   └─ Digits (Arabic only) .................. Western / Eastern Arabic
 ├─ Notifications (S-SET-02)
 │   ├─ Prayer reminders (per prayer, minutes before Adhan / Iqamah)
 │   ├─ Announcements · Events · Classes · Approvals (role-based)
 │   └─ Quiet hours (optional)
 ├─ Prayer
 │   └─ Adhan sound / vibration for reminders
 ├─ Privacy & security
 │   ├─ Biometric unlock (v1.1)
 │   ├─ Privacy policy · Terms of use
 │   └─ Delete account (S-SET-06)
 ├─ Mosque administration (Mosque Admin only)
 │   ├─ Mosque profile · Mosque settings · Payment details · Audit log
 └─ About (S-SET-05) — version, licenses, credits
```

---

## 10. Mosque Switcher

- Trigger: tap the mosque name in the Home app bar, or Profile → My mosques.
- Opens a **bottom sheet** listing the user's mosques (logo, name, city, role chips, ✓ on active).
- Footer action: "+ Join another mosque" → Find Mosque.
- On switch: short fade, data reloads, bottom navigation recalculated for the role in that mosque.

---

## 11. Notifications & Deep Links

| Notification | Opens |
|---|---|
| Announcement | Announcement detail (S-NOTI-03) |
| Iqamah times changed | Prayer → Today |
| Event reminder / change | Event detail (S-EVT-02) |
| Expense waiting for approval (MA) | Expense detail with Approve / Reject (S-FIN-05) |
| Approval decision (TR) | Transaction detail |
| Donation recorded (member) | Receipt (S-DON-04) |
| Join request (MA) | Join requests (S-MEMB-03) |
| Membership approved | Home |
| Class announcement | Announcement detail |

If the user is logged out, the deep link is kept and opened after login. If the target belongs to another mosque, the app switches mosque first (with a short toast "Switched to X Mosque").

---

## 12. User Journeys

### 12.1 New user

```
Install → Splash → Language → Onboarding (3 slides, skippable) → Welcome
→ Register (name, phone) → OTP → Complete profile
→ Find Mosque (search / nearby) → Mosque profile → Join
→ Home (pending banner if approval required; prayer times work immediately)
```
Goals: see prayer times in < 2 minutes; never hit a blank screen. While membership is pending, Home shows prayer times and public events with a banner "Your request is waiting for approval".

### 12.2 Registered mosque member

```
Open app → Home: next prayer hero (countdown), today's times strip,
            pinned/urgent announcement, upcoming events, active campaign
Daily:   Prayer tab → Today / Month / Qibla
Give:    Give tab → campaign → how to donate (copy number) → later sees donation in My donations
Events:  Community → Events → detail → Register → reminder notification
Alerts:  🔔 → notification → deep link to detail
```

### 12.3 Mosque administrator

```
Open app → Home (with admin cards: pending approvals, join requests, this month finance)
→ Manage → Admin dashboard
   ├─ Approvals → expense detail → view receipt → Approve / Reject (comment)
   ├─ Join requests → approve / reject (swipe or buttons)
   ├─ Members & staff → invite staff (role, phone) 
   ├─ Classes → create class → assign teacher
   ├─ Announcements → compose → audience → publish (push)
   └─ Reports → choose → filter → preview → export PDF
```

### 12.4 Treasurer

```
Open app → Home quick actions [+ Donation] [+ Expense]
→ Record donation: amount (numeric keypad) → type → method → reference → donor/anonymous
→ Review sheet → Confirm → Receipt screen → Share PDF (WhatsApp)
→ Record expense: category → amount → payee → photo of receipt → Save
   → above threshold → "Waiting for approval" status chip
→ Manage → Finance dashboard → Ledger (filters) → Reports → export
```
Goal: a donation recorded in under 30 seconds.

### 12.5 Teacher

```
Open app → Home: "Today: Hifz Group A · 4:00 PM [Take attendance]"
→ Take attendance: all Present by default → tap exceptions (Absent/Late/Excused) → Save → summary
→ Class → student → + Progress: surah picker → ayah range → quality → Save
→ Class announcement → compose → send to class
```
Goal: attendance for 20 students in under 1 minute.

### 12.6 Imam (also requested as a management interface)

```
Home → quick action [Iqamah times]
→ Prayer & Iqamah settings: per prayer fixed time or +minutes → effective date → preview week → Save (notify members toggle)
→ Jumu'ah sessions → add/edit session
→ Announce → compose → publish
```

---

## 13. Navigation Map (summary diagram)

```
                 ┌───────────── Splash ─────────────┐
                 ▼                                  ▼
          Onboarding/Auth                     Main Shell
                 │                    ┌──────┬──────┼──────┬──────┐
                 ▼                    ▼      ▼      ▼      ▼      ▼
            Find Mosque             Home  Prayer  Role  Community Profile
                                     │      │     tab      │        │
                     ┌───────────────┤   Today  ┌──┴──┐  Announce  My donations
                     ▼               ▼   Month  Give  Manage Events Settings
               Notifications   Mosque    Qibla   │    │    Campaigns About
                               switcher         How   ├ Admin
                                                to    ├ Imam
                                                give  ├ Treasurer
                                                      └ Teacher
```
