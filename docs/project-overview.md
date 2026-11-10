# Project Overview — Masjid Management App

| Item | Value |
|---|---|
| Project name | Masjid Management App |
| Document version | 1.0 (Phase 1 – Planning) |
| Date | 2026-11-10 |
| Status | Draft — awaiting owner review |
| Platforms | Android, iOS (iPhone) |

---

## 1. Summary

The Masjid Management App is a mobile application that lets a mosque run its daily operations from one place: prayer times, members and staff, donations (sadaqah, zakat, waqf), income and expenses, Qur'an classes, student attendance and progress, events, announcements, and financial reports.

The platform is **multi-mosque (multi-tenant)**: one installation of the system serves many mosques. Each mosque's data is fully isolated from the others. A platform-level **Super Admin** onboards mosques; each mosque is then run by its own **Mosque Admin** and staff.

## 2. Problem Statement

Most mosques today manage their work with paper, WhatsApp groups and spreadsheets. This causes:

- **Financial opacity** — donations and expenses are hard to track and audit; trust suffers.
- **Lost information** — student attendance and Qur'an memorization progress are kept in notebooks.
- **Poor communication** — announcements and prayer-time changes do not reach the whole community.
- **No reporting** — leadership cannot easily see income, expenses, or class performance over time.

## 3. Vision

> A trusted, simple, and modern digital home for every mosque — transparent finances, organized education, and a connected community.

## 4. Goals

| # | Goal | Measure of success |
|---|---|---|
| G1 | Transparent finance | 100% of donations and expenses recorded with receipts and audit trail |
| G2 | Organized education | Teachers record attendance and Qur'an progress in under 2 minutes per class |
| G3 | Connected community | Announcements and prayer-time changes reach members via push notification |
| G4 | Easy administration | A new mosque can be onboarded and configured in under 30 minutes |
| G5 | Accessible | Works on low-end Android phones and on slow / unstable internet |

## 5. Target Users

| Role | Who they are |
|---|---|
| Super Admin | Platform owner/operator who manages all mosques |
| Mosque Admin | Mosque chairman / committee manager |
| Imam | Leads prayers, manages prayer times and religious programs |
| Treasurer | Manages money: donations, income, expenses, reports |
| Teacher | Teaches Qur'an / Islamic classes (macallin) |
| Student | Learner enrolled in a class (ardayga) |
| Mosque Member | Regular community member / worshipper (jamaaca) |

Full detail: [user-roles-permissions.md](user-roles-permissions.md).

## 6. Technology Stack

| Layer | Technology |
|---|---|
| Mobile app | Flutter (Dart) — single codebase for Android & iOS |
| Backend | Supabase |
| Database | PostgreSQL (managed by Supabase) with Row Level Security (RLS) |
| Authentication | Supabase Auth |
| File storage | Supabase Storage (logos, profile photos, receipts, reports) |
| Push notifications | Firebase Cloud Messaging (FCM) |
| Server logic | Supabase Edge Functions / Postgres functions (notifications, reports) |
| Version control | Git & GitHub |
| AI assistant | Claude Code |

## 7. Design Direction

| Token | Color | Usage |
|---|---|---|
| Primary | Green | App bars, primary buttons, active states |
| Secondary | White | Backgrounds, cards, surfaces |
| Accent | Gold | Highlights, next-prayer indicator, badges, important figures |

Style: modern, clean, professional, user-friendly; respects Material (Android) and Cupertino (iOS) conventions where it matters (back navigation, date pickers, sheets). Light mode first; dark mode recommended (see Open Decisions).

## 8. Main Modules

1. Authentication & Profile
2. Mosque Management (multi-mosque)
3. Staff & Member Management
4. Prayer Times (Salah, Iqamah, Jumu'ah)
5. Donations & Sadaqah
6. Finance (Income & Expenses)
7. Qur'an Education (Classes, Students, Attendance, Progress)
8. Events (Munaasabadaha)
9. Announcements & Notifications
10. Reports & Financial Records
11. Settings & Administration

## 9. Document Map

| Document | Purpose |
|---|---|
| [project-requirements.md](project-requirements.md) | Business requirements, constraints, assumptions |
| [functional-requirements.md](functional-requirements.md) | What the system must do (FR IDs) |
| [non-functional-requirements.md](non-functional-requirements.md) | Quality attributes (performance, usability…) |
| [user-roles-permissions.md](user-roles-permissions.md) | Roles and permission matrix |
| [app-features.md](app-features.md) | Feature catalogue by module and release |
| [user-flows.md](user-flows.md) | Step-by-step user journeys |
| [screen-list.md](screen-list.md) | Complete list of screens |
| [database-requirements.md](database-requirements.md) | Data entities, relationships, rules |
| [security-requirements.md](security-requirements.md) | Security and privacy controls |
| [development-roadmap.md](development-roadmap.md) | Phases, milestones, sprints |
| [project-scope.md](project-scope.md) | In scope / out of scope / MVP boundary |

## 10. Working Assumptions (to be confirmed)

These assumptions were made so planning could proceed. Each one is listed in **Open Decisions** below and in [project-scope.md](project-scope.md).

- **A1** Multi-tenant: one platform, many mosques.
- **A2** A single user account can belong to more than one mosque, with a role per mosque.
- **A3** App languages: **Somali and English** in MVP; **Arabic (RTL)** in a later release.
- **A4** Default currency **USD**, configurable per mosque (e.g., SOS, KES, ETB, GBP).
- **A5** MVP records donations **manually** (cash / mobile money reference entered by Treasurer). Online payment (EVC Plus, Zaad, Sahal, card) comes later.
- **A6** Prayer times are **calculated automatically** from mosque location, and **Iqamah times are set manually** by the Imam/Admin.
- **A7** Login with **phone number + OTP** as primary method, email + password as alternative.
- **A8** Mobile app only in MVP. A web admin dashboard is a future release.
- **A9** Students who are children may not have their own phone; a teacher can manage them without them having an account.

## 11. Open Decisions (owner must decide)

| ID | Question | Recommendation |
|---|---|---|
| D1 | Single mosque or multi-mosque platform? | Multi-mosque (the Super Admin role implies it) |
| D2 | Can one user belong to several mosques? | Yes, role per mosque |
| D3 | Which languages at launch? | Somali + English; Arabic in v1.1 |
| D4 | Default currency & multi-currency? | USD default, one currency per mosque |
| D5 | Online payments in MVP? | No — manual recording first; EVC Plus/Zaad in v2 |
| D6 | Login method? | Phone OTP + email/password (SMS provider cost must be budgeted) |
| D7 | Add a **Parent/Guardian** role? | Yes in v1.1 — parents want to see child attendance/progress |
| D8 | Web admin dashboard? | Future (v2), Flutter Web reusing code |
| D9 | Prayer-time calculation method default? | Muslim World League, editable per mosque; Asr: Shafi'i default, Hanafi option |
| D10 | Who approves expenses? | Treasurer records; Mosque Admin approves above a threshold set per mosque |
| D11 | Subscription / pricing model for mosques? | Free during pilot; decide before public launch |
| D12 | Dark mode in MVP? | Nice-to-have; design tokens prepared from the start |
| D13 | Data hosting region? | Closest Supabase region to users (e.g., EU Frankfurt) — confirm |

## 12. Current Phase

**Phase 1 – Project Planning.** No code, no database, no Supabase integration is created in this phase.

> Note: the repository already contains a default Flutter template project (`flutter create` output). It has not been modified and will be restructured in Phase 4 (Project Setup).
