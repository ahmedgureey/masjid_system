# Security Requirements

Security and privacy controls for the Masjid Management App. IDs: `SEC-<AREA>-<NN>`. The app holds **money records** and **children's data**, so security is a first-class requirement, not an add-on.

---

## 1. Threat Summary

| Threat | Example | Primary control |
|---|---|---|
| Cross-tenant access | Treasurer of Mosque A reads Mosque B's finances | RLS on every table (SEC-AUTHZ) |
| Privilege escalation | Member edits their own role to Mosque Admin | Roles writable only by MA via controlled functions |
| Financial fraud / tampering | Deleting or editing a donation after the fact | No hard delete, void + audit, approval workflow |
| Account takeover | Stolen phone, OTP brute-force | OTP rate limits, secure token storage, session revocation |
| Data leak of minors | Student photos exposed via public URL | Private buckets, signed URLs, restricted RLS |
| Leaked secrets | `service_role` key shipped in app | Only anon/publishable key in app; secrets in server env |
| Notification abuse | Spam pushes to whole community | Role-restricted sending, rate limits |
| Malicious uploads | Executable disguised as receipt | MIME/size validation, allowed types only |

---

## 2. Authentication (AUTHN)

| ID | Requirement |
|---|---|
| SEC-AUTHN-01 | Authentication only via Supabase Auth (phone OTP, email + password). |
| SEC-AUTHN-02 | Passwords: minimum 8 characters; Supabase leaked-password protection enabled where available. |
| SEC-AUTHN-03 | Email verification required for email accounts before accessing mosque data. |
| SEC-AUTHN-04 | OTP: 6 digits, expiry ≤ 5 min, resend cooldown 60 s, max attempts and per-number/IP rate limits. |
| SEC-AUTHN-05 | Access token short-lived (≈1 h) with refresh token rotation (Supabase default). |
| SEC-AUTHN-06 | Tokens stored only in secure storage (iOS Keychain / Android Keystore via `flutter_secure_storage` or equivalent). |
| SEC-AUTHN-07 | Re-authentication required for sensitive actions: account deletion, changing phone/email; recommended for approving large expenses. |
| SEC-AUTHN-08 | Super Admin accounts must use MFA (TOTP) before production launch. |
| SEC-AUTHN-09 | Logout clears tokens and local cached sensitive data (finance, student data). |
| SEC-AUTHN-10 | Ability to revoke all sessions of a user (SA / user "log out everywhere") — v1.1. |

## 3. Authorization (AUTHZ)

| ID | Requirement |
|---|---|
| SEC-AUTHZ-01 | **RLS enabled on every table**; default deny. |
| SEC-AUTHZ-02 | Every mosque-scoped policy checks that the user has an **active membership** in that `mosque_id` and the **required role**. |
| SEC-AUTHZ-03 | Role checks implemented in reusable `SECURITY DEFINER` SQL helper functions with a fixed `search_path`. |
| SEC-AUTHZ-04 | The app UI hides actions a role cannot perform, **but the database is the source of truth** — never rely on UI checks alone. |
| SEC-AUTHZ-05 | Role assignment, membership approval, expense approval and voiding happen through server-side functions that validate permissions and write audit logs. |
| SEC-AUTHZ-06 | A user cannot change their own roles or approve their own expense. |
| SEC-AUTHZ-07 | Teachers only access students enrolled in classes they teach. |
| SEC-AUTHZ-08 | Members only see their own donations; donor identities never exposed to other members. |
| SEC-AUTHZ-09 | Suspended mosques: all non-SA access denied by policy. |
| SEC-AUTHZ-10 | Super Admin support access to a mosque's private data is explicit, time-limited, and audit-logged. |
| SEC-AUTHZ-11 | Automated tests for every RLS policy: allowed role succeeds, other roles and other mosques fail. |

## 4. Data Protection (DATA)

| ID | Requirement |
|---|---|
| SEC-DATA-01 | All network traffic over HTTPS (TLS 1.2+); no cleartext HTTP allowed in Android/iOS config. |
| SEC-DATA-02 | Data at rest encrypted (Supabase managed encryption for DB and Storage). |
| SEC-DATA-03 | Private buckets for receipts, student photos and reports; access via short-lived **signed URLs** (≤ 1 h). |
| SEC-DATA-04 | Minimum personal data collected; date of birth and guardian phone only for students. |
| SEC-DATA-05 | Children's (students') data visible only to MA, IM and their teachers (and guardians in v1.1). |
| SEC-DATA-06 | No personal or financial data in logs, crash reports or analytics events. |
| SEC-DATA-07 | Local cache on device: non-sensitive data (prayer times, public announcements) may be cached; finance and student data cached only in encrypted storage or not at all. |
| SEC-DATA-08 | Account deletion anonymizes personal data; financial records stay for accounting with donor shown as "Deleted user". |
| SEC-DATA-09 | Data exports (reports) only for authorized roles; exported PDFs include mosque name, generation date and generator's name. |

## 5. Financial Integrity (FIN)

| ID | Requirement |
|---|---|
| SEC-FIN-01 | Financial records cannot be hard-deleted by any app user; only voided with reason. |
| SEC-FIN-02 | Approved/voided records are immutable; edits blocked by database policy/trigger. |
| SEC-FIN-03 | Expense approval threshold enforced in the database, not only in the app. |
| SEC-FIN-04 | Separation of duties: recorder ≠ approver. |
| SEC-FIN-05 | Receipt numbers generated server-side, sequential, unique. |
| SEC-FIN-06 | Every financial action logged in insert-only `audit_logs`. |
| SEC-FIN-07 | Closed periods (v1.1) reject inserts/edits dated within them. |
| SEC-FIN-08 | Amount validation: positive, max precision 2 decimals, reasonable upper bound with confirmation for unusually large amounts. |

## 6. API, Keys & Secrets (KEYS)

| ID | Requirement |
|---|---|
| SEC-KEYS-01 | The mobile app contains only the Supabase **URL and anon/publishable key**. |
| SEC-KEYS-02 | `service_role` key, FCM server credentials, SMS provider keys stored only in Supabase Edge Function secrets / CI secrets — **never in the app or Git**. |
| SEC-KEYS-03 | `.env` files and Firebase config with secrets excluded from Git; secret scanning enabled on GitHub. |
| SEC-KEYS-04 | Separate Supabase/Firebase projects and keys for dev, staging, production. |
| SEC-KEYS-05 | Edge Functions verify the caller's JWT and role before acting. |
| SEC-KEYS-06 | Rotate keys immediately if exposure is suspected. |

## 7. Mobile App Security (APP)

| ID | Requirement |
|---|---|
| SEC-APP-01 | Release builds obfuscated (`--obfuscate --split-debug-info`). |
| SEC-APP-02 | Debug logging disabled in release. |
| SEC-APP-03 | Input validation on all forms (length, format, allowed characters); server validates again. |
| SEC-APP-04 | File uploads: allowed types (jpg, png, webp, pdf), size limits, images re-encoded/compressed before upload. |
| SEC-APP-05 | Deep links validated; they only navigate, never perform actions without user confirmation. |
| SEC-APP-06 | Minimum app version enforcement to retire insecure versions. |
| SEC-APP-07 | Optional: screenshot protection on sensitive finance/student screens (Android `FLAG_SECURE`) — decide in design phase. |
| SEC-APP-08 | Dependencies reviewed; only well-maintained packages; `flutter pub outdated` checked each release. |

## 8. Notifications (NOTI)

| ID | Requirement |
|---|---|
| SEC-NOTI-01 | Only MA, IM (mosque), TE (own class) and SA (platform) can trigger pushes. |
| SEC-NOTI-02 | Push sending only from server (Edge Function), never directly from the app with server credentials. |
| SEC-NOTI-03 | Daily rate limit per mosque. |
| SEC-NOTI-04 | Push payload contains no sensitive data (no amounts, no student names) — details loaded in-app after authentication. |
| SEC-NOTI-05 | Invalid device tokens removed automatically. |

## 9. Audit & Monitoring (AUD)

| ID | Requirement |
|---|---|
| SEC-AUD-01 | Audit log for: financial actions, role changes, membership approvals, settings changes, mosque status changes, SA support access. |
| SEC-AUD-02 | Audit log is insert-only; nobody (including MA) can modify or delete entries through the API. |
| SEC-AUD-03 | Monitor Supabase security advisors and fix warnings before each release. |
| SEC-AUD-04 | Alerting on abnormal activity (many failed logins, mass voids, notification spikes) — v1.1. |

## 10. Backup & Recovery (BAK)

| ID | Requirement |
|---|---|
| SEC-BAK-01 | Daily automated backups; point-in-time recovery enabled on production before public launch. |
| SEC-BAK-02 | Restore procedure documented and tested at least once before launch. |
| SEC-BAK-03 | Storage files backed up or reproducible (receipts are critical). |

## 11. Privacy & Compliance (PRIV)

| ID | Requirement |
|---|---|
| SEC-PRIV-01 | Privacy Policy explains what data is collected, why, retention, and user rights. |
| SEC-PRIV-02 | Comply with applicable data protection laws where mosques operate (e.g., Somalia's Data Protection Act; GDPR/UK GDPR for diaspora mosques in Europe) — legal review recommended before launch. |
| SEC-PRIV-03 | Guardian consent captured (checkbox + date) when registering a minor student. |
| SEC-PRIV-04 | Users can request a copy of their personal data (manual process in MVP). |
| SEC-PRIV-05 | Location permission requested only when needed (Qibla, nearby mosques), with clear explanation. |

## 12. Secure Development Process (DEV)

| ID | Requirement |
|---|---|
| SEC-DEV-01 | Branch protection on `main`; changes via pull requests with review. |
| SEC-DEV-02 | CI runs analysis, tests and RLS tests on every PR. |
| SEC-DEV-03 | Security review checklist before each release (RLS, secrets, storage policies, dependencies). |
| SEC-DEV-04 | Penetration-style test of tenant isolation before pilot and before public launch. |
| SEC-DEV-05 | Incident response plan: who is contacted, how keys are rotated, how affected mosques are informed. |
