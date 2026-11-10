# Development Roadmap

Phased plan from planning to launch and beyond. Durations are **estimates** for a small team (1–2 Flutter developers + Claude Code, part-time designer). They will be re-estimated at the end of Phase 3.

> **Rule:** each phase ends with a review and **owner approval** before the next phase starts.

---

## Overview

| Phase | Name | Duration (est.) | Main output |
|---|---|---|---|
| 1 | Project Planning | 1 week | This documentation set ✅ |
| 2 | Environment Setup | — | Development tools installed ✅ (Android SDK still missing — see setup-guide.md) |
| 3 | UI/UX Design | 3 weeks | Design system & screen specs ✅ (`docs/design/`); hi-fi mockups pending |
| 4 | Flutter Project Setup | 1 week | Folder structure, theme, routing, tests ✅ (`docs/architecture.md`) |
| — | Technical Architecture & Database Design | 2 weeks | ERD, schema, RLS design, API contracts — **not yet scheduled; placement to be confirmed by owner** |
| 5 | MVP Development | 18 weeks (9 sprints × 2 weeks) | Working MVP |
| 6 | Testing & QA | 2 weeks (+ continuous) | Test reports, bug fixes |
| 7 | Pilot (Beta) | 4 weeks | Feedback from 1–3 pilot mosques |
| 8 | Store Launch | 1–2 weeks | App on Google Play & App Store |
| 9 | v1.1 | ~6 weeks | Arabic, Parent role, offline attendance, Excel… |
| 10 | v2 | TBD | Online payments, web dashboard… |

**Estimated time to MVP store launch: ~8 months** (Phases 1–8).

---

## Phase 1 — Project Planning (done)

- Overview, requirements (business, functional, non-functional)
- Roles & permissions, features, user flows, screen list
- Database & security requirements, roadmap, scope
- **Exit criteria:** owner reviews docs and answers Open Decisions (D1–D13).

## Phase 3 — UI/UX Design (done)

- Design system: colors (Green / White / Gold), typography (Latin + Arabic-capable font), spacing, components, icons
- Low-fidelity wireframes for all MVP screens ([screen-list.md](screen-list.md))
- High-fidelity mockups (light mode; dark tokens prepared)
- Clickable prototype of core flows: login, join mosque, prayer times, record donation, take attendance, announcement
- Usability check with 3–5 real users (imam, treasurer, teacher, member)
- **Exit:** approved designs.

## Technical Architecture & Database Design (to be scheduled)

- App architecture: feature-first, layered; state management choice (proposal Riverpod); routing (proposal go_router); local storage choice
- Final ERD and table definitions from [database-requirements.md](database-requirements.md)
- RLS policy design and helper functions; storage policies
- Edge Functions list and contracts (notifications, receipts, reports, account deletion)
- Notification architecture (FCM topics vs tokens)
- Environments strategy (dev / staging / prod), CI/CD plan, branching strategy
- Final estimates & sprint plan
- **Exit:** approved architecture & schema documents.

## Phase 4 — Flutter Project Setup (done; Supabase, CI and i18n items still open)

- Restructure the existing Flutter template into the agreed folder structure
- Supabase projects (dev, staging, prod), migrations folder, seed data
- Firebase project (FCM, Crashlytics) for Android & iOS, APNs key
- GitHub repository, branch protection, CI (analyze, test)
- Theme (design tokens), localization setup (so, en), routing skeleton, error handling, logging
- **Exit:** "hello world" app builds on Android & iOS, connected to dev backend.

## Phase 5 — MVP Development (sprints)

| Sprint | Focus | Key deliverables |
|---|---|---|
| S1 | Auth & profile | Phone OTP, email login, profile, language, session, account deletion |
| S2 | Mosques & membership | Mosque registration & approval (SA), setup wizard, directory, join requests, invitations, roles, mosque switcher, RLS foundation |
| S3 | Prayer times | Calculation, Iqamah rules, Jumu'ah, special prayers, timetable, Qibla, local reminders, Hijri date |
| S4 | Announcements, notifications & events | Announcements, FCM push via Edge Function, inbox, preferences, deep links, events & registration, reminders |
| S5 | Donations | Donation recording, donors, receipts (PDF, numbering), funds/campaigns, my donations, how to donate |
| S6 | Finance | Income, expenses, receipt uploads, approval workflow, categories, opening balance, finance dashboard, ledger, audit log |
| S7 | Education I | Classes, teachers, students, enrollment, attendance |
| S8 | Education II & Reports | Qur'an progress, assessments, student profile, student view; all MVP reports + PDF export |
| S9 | SA tools & hardening | Platform dashboard, users, global settings, force update, audit viewer, performance, accessibility, security review |

Each sprint: planning → build → tests (unit, widget, RLS) → demo → owner feedback.

## Phase 6 — Testing & QA

- Functional testing against [functional-requirements.md](functional-requirements.md)
- RLS / tenant-isolation tests (automated + manual attack scenarios)
- Device testing: low-end Android, recent Android, iPhone (older + newer)
- Performance (startup, lists on slow network), accessibility (font scaling, screen readers)
- Localization review by native Somali speaker
- **Exit:** no open critical/high bugs.

## Phase 7 — Pilot (Beta)

- Internal testing tracks: Google Play internal testing, Apple TestFlight
- 1–3 pilot mosques using real data
- Weekly feedback sessions; fix priority issues
- Validate prayer-time accuracy with the Imams
- **Exit:** pilot mosques confirm readiness; crash-free ≥ 99%.

## Phase 8 — Store Launch

- Store listings (Somali & English), screenshots, privacy policy URL, data safety forms
- Production backups / PITR verified, monitoring and alerts on
- Release v1.0 to Google Play and App Store
- Support channel ready

## Phase 9 — v1.1 (post-launch)

Arabic (RTL), Parent/Guardian role, offline attendance sync, Excel/CSV export, nearby mosques, donation pledges ("I donated"), Zakat calculator, period closing, event QR check-in & recurring events, add-to-calendar, dark mode, biometric unlock, CSV member import, transparency summary, absence alerts.

## Phase 10 — v2 (future)

Online donations (EVC Plus / Zaad / Sahal / card), web admin dashboard (Flutter Web), recurring donations, payroll, certificates, class fees, SMS fallback, home-screen widget, auditor role.

---

## Milestones

| # | Milestone | Target (relative) |
|---|---|---|
| M1 | Planning approved | End of week 1 |
| M2 | Designs approved | Week 4 |
| M3 | Architecture & schema approved | Week 6 |
| M4 | Foundation ready | Week 8 |
| M5 | Core community features (S1–S4) | Week 16 |
| M6 | Finance complete (S5–S6) | Week 20 |
| M7 | Feature-complete MVP (S7–S9) | Week 26 |
| M8 | QA passed | Week 28 |
| M9 | Pilot complete | Week 32 |
| M10 | Public launch v1.0 | Week 34 |

## Team & Tools

| Need | Tool / Person |
|---|---|
| Development | Flutter developers + Claude Code |
| Design | Figma (or similar) |
| Backend | Supabase dashboard + CLI, migrations in Git |
| Push / crashes | Firebase (FCM, Crashlytics) |
| Code & CI | GitHub + GitHub Actions |
| iOS builds | macOS machine or CI service (e.g., Codemagic / GitHub macOS runners) |
| Project tracking | GitHub Projects / Issues |

## Pre-requisites to Arrange Early

- Apple Developer account and Google Play Console account
- SMS provider account for phone OTP (cost estimate per message)
- Domain + hosting for Privacy Policy / Terms pages
- At least one committed pilot mosque
