# Non-Functional Requirements

Quality attributes the system must meet. IDs: `NFR-<CATEGORY>-<NN>`. Security is summarized here and detailed in [security-requirements.md](security-requirements.md).

---

## 1. Performance (PERF)

| ID | Requirement |
|---|---|
| NFR-PERF-01 | Cold start to first usable screen ≤ 3 s on a mid-range Android device (e.g., 3 GB RAM). |
| NFR-PERF-02 | Prayer times screen loads instantly from local data (no network needed). |
| NFR-PERF-03 | 95% of list screens load first page ≤ 2 s on a 3G-quality connection. |
| NFR-PERF-04 | Lists are paginated (default 20–50 items) — never load full tables. |
| NFR-PERF-05 | Images are compressed before upload (max ~1 MB, max 1600 px) and thumbnails are used in lists. |
| NFR-PERF-06 | Report generation for one year of a single mosque's data ≤ 10 s. |
| NFR-PERF-07 | Push notifications delivered to devices within 1 minute of publishing (subject to FCM/APNs). |
| NFR-PERF-08 | APK/IPA download size target ≤ 30 MB. |

## 2. Scalability (SCAL)

| ID | Requirement |
|---|---|
| NFR-SCAL-01 | Architecture supports at least 500 mosques and 100,000 users without redesign. |
| NFR-SCAL-02 | All tenant tables are indexed on `mosque_id` plus common filter columns (date, status). |
| NFR-SCAL-03 | Heavy work (bulk notifications, report generation) runs server-side (Edge Functions / DB functions), not on the phone. |

## 3. Availability & Reliability (REL)

| ID | Requirement |
|---|---|
| NFR-REL-01 | Backend availability target 99.5% monthly (depends on Supabase plan). |
| NFR-REL-02 | Daily automated database backups; point-in-time recovery on paid plan before public launch. |
| NFR-REL-03 | App handles network loss gracefully: clear offline message, retry, no data loss on forms. |
| NFR-REL-04 | Financial writes are atomic (transaction + audit log entry succeed or fail together). |
| NFR-REL-05 | Crash-free sessions ≥ 99% (monitored via crash reporting, e.g., Firebase Crashlytics). |

## 4. Offline Support (OFF)

| ID | Requirement |
|---|---|
| NFR-OFF-01 | Prayer times, Iqamah times, mosque profile and last-loaded announcements are cached locally and readable offline. |
| NFR-OFF-02 | Prayer reminders are scheduled as local notifications and work without internet. |
| NFR-OFF-03 | Attendance taking works offline with later sync (v1.1). |
| NFR-OFF-04 | Financial entries require an online connection in MVP (avoids sync conflicts on money). |

## 5. Usability (USE)

| ID | Requirement |
|---|---|
| NFR-USE-01 | A first-time member can see their mosque's prayer times within 2 minutes of installing. |
| NFR-USE-02 | Common tasks (record donation, take attendance) take ≤ 3 taps from the role dashboard. |
| NFR-USE-03 | UI available in Somali and English; all strings externalized (no hard-coded text) to allow Arabic (RTL) later. |
| NFR-USE-04 | Consistent design system: Green primary, White secondary, Gold accent; 8-pt spacing grid; one icon set. |
| NFR-USE-05 | Clear empty states, loading states, and error messages in plain language. |
| NFR-USE-06 | Confirmation dialogs before destructive or financial actions (void, approve, delete). |
| NFR-USE-07 | Dates show both Gregorian and Hijri where relevant; numbers and currency formatted per locale. |
| NFR-USE-08 | Platform-appropriate behaviour on Android and iOS (back gesture, pickers, safe areas). |

## 6. Accessibility (ACC)

| ID | Requirement |
|---|---|
| NFR-ACC-01 | Text contrast meets WCAG 2.1 AA (≥ 4.5:1 for body text). Gold must not be used for body text on white. |
| NFR-ACC-02 | Supports system font scaling up to 200% without broken layouts. |
| NFR-ACC-03 | Touch targets ≥ 48×48 dp. |
| NFR-ACC-04 | Screen reader labels (TalkBack / VoiceOver) on all interactive elements. |
| NFR-ACC-05 | Information is never conveyed by color alone (e.g., attendance status uses icon + label). |

## 7. Compatibility (COMP)

| ID | Requirement |
|---|---|
| NFR-COMP-01 | Android 7.0 (API 24) and above; iOS 13 and above (final minimum confirmed at setup against current Flutter/Firebase requirements). |
| NFR-COMP-02 | Phones in portrait orientation; tablets supported with responsive layout (not optimized in MVP). |
| NFR-COMP-03 | Screen sizes from 4.7" to 6.9". |

## 8. Security & Privacy (SEC) — summary

| ID | Requirement |
|---|---|
| NFR-SEC-01 | All traffic over HTTPS/TLS 1.2+. |
| NFR-SEC-02 | Row Level Security on every table; tenant isolation enforced in the database. |
| NFR-SEC-03 | Tokens stored in secure storage (Keychain / Android Keystore). |
| NFR-SEC-04 | Personal data of minors (students) visible only to their teachers, MA and IM. |
| NFR-SEC-05 | Audit log for financial, role and settings changes. |

Full details: [security-requirements.md](security-requirements.md).

## 9. Maintainability (MAIN)

| ID | Requirement |
|---|---|
| NFR-MAIN-01 | Feature-first clean architecture (presentation / domain / data layers per feature). |
| NFR-MAIN-02 | One state-management approach used consistently (proposal: Riverpod — decided in Phase 3). |
| NFR-MAIN-03 | Database changes only through versioned migrations stored in Git. |
| NFR-MAIN-04 | Lints enforced (`flutter_lints` or stricter); code formatted with `dart format`. |
| NFR-MAIN-05 | Unit test coverage ≥ 70% for domain logic (finance totals, prayer calculation, permissions). |
| NFR-MAIN-06 | Automated tests for every RLS policy (positive and negative cases). |
| NFR-MAIN-07 | Separate environments: development, staging, production (separate Supabase projects). |
| NFR-MAIN-08 | CI on GitHub: analyze + test on every pull request. |

## 10. Localization (L10N)

| ID | Requirement |
|---|---|
| NFR-L10N-01 | Somali (so) and English (en) at launch; Arabic (ar, RTL) in v1.1. |
| NFR-L10N-02 | Islamic terms kept consistent (Fajr, Dhuhr, Asr, Maghrib, Isha, Jumu'ah, Iqamah, Zakat, Sadaqah) with a glossary. |
| NFR-L10N-03 | Timezone handled per mosque, not per device, for prayer times and financial dates. |
| NFR-L10N-04 | Currency per mosque with correct symbol and decimals. |

## 11. Legal & Store Compliance (LEGAL)

| ID | Requirement |
|---|---|
| NFR-LEGAL-01 | Privacy Policy and Terms of Use published before store submission. |
| NFR-LEGAL-02 | In-app account deletion (Apple and Google requirement). |
| NFR-LEGAL-03 | Clear notification and location permission rationales. |
| NFR-LEGAL-04 | Donations recorded in the app are records only (no in-app payment in MVP) — avoids app-store payment policy issues. When online donations are added (v2), use store-compliant methods for charitable donations. |

## 12. Observability (OBS)

| ID | Requirement |
|---|---|
| NFR-OBS-01 | Crash and error reporting in the app (no personal data in logs). |
| NFR-OBS-02 | Backend logs and alerts for Edge Function failures and notification delivery errors. |
| NFR-OBS-03 | Basic anonymous usage analytics (screens, feature adoption) with user consent where required. |
