# Project Scope

Defines exactly what is included, excluded and deferred, so the project stays focused. Any change to this scope goes through the change-control process at the end of this document.

---

## 1. Scope Statement

Build and launch a **multi-mosque mobile application (Android & iOS)** using Flutter and Supabase that lets mosques manage prayer times, people, donations, finances, Qur'an education, events, announcements and reports, with role-based access for seven roles.

## 2. In Scope — MVP (v1.0)

| Module | Included |
|---|---|
| Authentication | Phone OTP, email/password, profile, mosque switcher, account deletion |
| Mosque management | Registration request & SA approval, setup wizard, profile, settings, directory |
| Staff & members | Join requests, staff invitations, multi-role, manual member records |
| Prayer times | Calculated times (offline), Iqamah rules, Jumu'ah, special prayers, timetable, Qibla, Hijri date, local reminders |
| Donations | Manual recording, donor/anonymous, PDF receipts, funds & campaigns, my donations, payment instructions, void |
| Finance | Income, expenses, receipt photos, threshold approval, categories, opening balance, dashboard, ledger, audit trail |
| Education | Classes, teachers, students (with/without accounts), enrollment, attendance, Qur'an progress, assessments, student view |
| Events | Create/edit/cancel, list & calendar, registration with capacity, registrants, reminders |
| Announcements | Targeted announcements, scheduling, push (FCM), inbox, preferences, pinned urgent notices, platform announcements |
| Reports | Finance, donations, funds, attendance, progress, membership, platform usage; PDF export & share |
| Settings | Somali & English, notification settings, audit log viewer, force update, legal pages |
| Roles | Super Admin, Mosque Admin, Imam, Treasurer, Teacher, Student, Mosque Member |
| Platforms | Android & iOS phones |
| Deliverables | Source code on GitHub, DB migrations, docs, store releases |

## 3. Deferred — v1.1

Arabic language (RTL) · Parent/Guardian role · Offline attendance sync · Excel/CSV export · Nearby mosques map · Donation pledge ("I donated") · Zakat calculator · Period closing · Event QR check-in · Recurring events · Add to calendar · Dark mode · Biometric unlock · CSV member import · Public transparency summary · Absence alerts to guardians · Share prayer timetable.

## 4. Deferred — v2

In-app online donations (EVC Plus, Zaad, Sahal, card) · Web admin dashboard · Recurring donations · Staff payroll · Completion certificates · Class fee tracking · SMS fallback notifications · Home-screen widget · Auditor/committee read-only role · Event waitlists.

## 5. Out of Scope (not planned)

- Full accounting system (double-entry bookkeeping, tax filing, bank reconciliation).
- Live streaming of khutbah/lectures, audio/video library.
- Qur'an reader / Mushaf, Hadith library, Islamic content apps.
- Social network features (chat, comments, likes, private messaging).
- Hardware integrations (masjid display screens, Adhan clocks) — may be considered later.
- Tablet-optimized and desktop layouts.
- Madrasa/school management beyond Qur'an classes (timetabling, transport, full grading systems).
- Marketplace, e-commerce, or advertising.

## 6. MVP Acceptance Criteria

The MVP is accepted when:

1. All MVP functional requirements in [functional-requirements.md](functional-requirements.md) are implemented and tested.
2. All MVP screens in [screen-list.md](screen-list.md) match approved designs.
3. Automated RLS tests show zero cross-mosque and zero cross-role leaks.
4. Financial totals in reports match the ledger exactly in test scenarios (including voided and pending items).
5. Prayer times match the chosen method within ±1 minute for the pilot mosques and are confirmed by their Imams.
6. App runs on the minimum supported Android and iOS versions; crash-free ≥ 99% during pilot.
7. Somali and English translations reviewed by native speakers.
8. Privacy Policy, Terms, and account deletion in place; store reviews passed.

## 7. Assumptions & Decisions Affecting Scope

| ID | Assumption | If changed… |
|---|---|---|
| A1 / D1 | Multi-mosque platform | Single-mosque removes SA tools and simplifies RLS |
| A2 / D2 | One user can join several mosques | If not, mosque switcher removed |
| A3 / D3 | Somali + English at launch | Adding Arabic to MVP adds ~1–2 weeks (RTL testing) |
| A4 / D4 | One currency per mosque | Multi-currency adds conversion and reporting complexity |
| A5 / D5 | Manual donation recording | Online payments add integration, compliance and ~4–6 weeks |
| A6 / D9 | Calculated times + manual Iqamah | Fully manual timetable upload would need an import feature |
| A7 / D6 | Phone OTP + email | SMS costs; email-only would reduce cost but hurt adoption |
| A8 / D8 | Mobile only | Web dashboard adds ~6–8 weeks |
| A9 | Students may have no account | Requiring accounts would exclude young children |
| D7 | Parent role in v1.1 | Moving to MVP adds ~1–2 weeks |
| D10 | Threshold approval by MA | Different workflow changes finance module |

Full list of open decisions: [project-overview.md §11](project-overview.md#11-open-decisions-owner-must-decide).

## 8. Constraints

Fixed tech stack (Flutter, Supabase, FCM, GitHub); small team; budget-conscious hosting; users with low-end devices and weak connectivity; Apple/Google store policies.

## 9. Change Control

1. Any new feature or change is written as a short request (what, why, who benefits).
2. Impact is assessed: effort, affected documents, timeline, risk.
3. The owner approves, rejects, or moves it to v1.1 / v2.
4. Approved changes update the relevant docs (requirements, screens, roadmap) **before** development.
5. During a sprint, scope is frozen; changes go to the next sprint.
