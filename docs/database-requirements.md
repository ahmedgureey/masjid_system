# Database Requirements

This document defines **what data the system must store and the rules around it**. It is not the final schema — the physical schema (exact columns, types, indexes, SQL migrations, RLS policies) is designed in **Phase 3** and no database is created in Phase 1.

Database: **PostgreSQL on Supabase**, with **Supabase Auth** for identities and **Supabase Storage** for files.

---

## 1. General Data Rules

| ID | Rule |
|---|---|
| DB-01 | **Multi-tenancy:** every mosque-owned table has a `mosque_id` column (not null) referencing `mosques`. |
| DB-02 | **Row Level Security** is enabled on every table in the exposed schema; no table is readable without a policy. |
| DB-03 | Primary keys are UUIDs. |
| DB-04 | All timestamps stored as `timestamptz` in UTC; display converted using the mosque's timezone. |
| DB-05 | Money stored as `numeric(14,2)` (never floating point), always with a currency code (ISO 4217). |
| DB-06 | Standard columns on main tables: `id`, `mosque_id`, `created_at`, `created_by`, `updated_at`, `updated_by`. |
| DB-07 | **Soft delete** (`deleted_at` / `status`) for business records; financial records are never deleted — only **voided** (`voided_at`, `voided_by`, `void_reason`). |
| DB-08 | Enumerations (roles, statuses, prayer names, payment methods) defined as Postgres enums or lookup tables — decided in Phase 3. |
| DB-09 | All schema changes through versioned migrations stored in Git; never edit production schema by hand. |
| DB-10 | Indexes on `mosque_id` + common filters (`date`, `status`, `type`) and on all foreign keys. |
| DB-11 | Personal data kept to the minimum needed (data minimisation). |

---

## 2. Entity Overview

```
auth.users ─1:1─ profiles ─1:N─ memberships ─N:1─ mosques
                                   │
                                   └─1:N─ membership_roles (mosque_admin, imam, treasurer, teacher, student, member)

mosques ─1:1─ mosque_settings
mosques ─1:N─ iqamah_rules, jumuah_sessions, special_prayers
mosques ─1:N─ funds, finance_categories, transactions ─1:N─ attachments
mosques ─1:N─ classes ─N:M─ teachers (class_teachers)
              classes ─N:M─ students (enrollments)
              classes ─1:N─ class_sessions ─1:N─ attendance_records
              students ─1:N─ quran_progress, assessments
mosques ─1:N─ events ─1:N─ event_registrations
mosques ─1:N─ announcements ─1:N─ notifications (per user inbox)
profiles ─1:N─ device_tokens, notification_preferences
audit_logs (all modules)
```

---

## 3. Entities by Module

### 3.1 Identity & Platform

| Entity | Purpose | Key data | Notes |
|---|---|---|---|
| `profiles` | App profile for each auth user | user_id (= auth.users.id), full_name, phone, email, gender, photo_path, preferred_language, last_active_mosque_id, deleted_at | Created automatically on sign-up |
| `platform_admins` | Who is Super Admin | user_id, granted_by, granted_at | Kept separate from mosque roles |
| `app_config` | Global settings | min_app_version (android/ios), default calc methods, notification daily limit, maintenance flag | SA only |

### 3.2 Mosques & Membership

| Entity | Purpose | Key data | Notes |
|---|---|---|---|
| `mosques` | Tenant | name, slug, description, address, city, region, country, latitude, longitude, timezone, currency, phone, email, logo_path, cover_path, facilities, status (pending / active / suspended / rejected) | Public fields readable by anyone logged in |
| `mosque_settings` | Per-mosque configuration | calc_method, asr_method, high_latitude_rule, expense_approval_threshold, auto_approve_members, attendance_edit_days, default_language | 1:1 with mosques |
| `mosque_payment_details` | How to donate | method (EVC Plus, Zaad, Sahal, e-Dahab, Bank…), account name, account number, instructions, display order | Shown to members |
| `mosque_registration_requests` | New mosque requests | requester_id, proposed details, proof_path, status, reviewed_by, review_note | SA reviews |
| `memberships` | User ↔ mosque link | mosque_id, user_id (nullable for manual records), display name/phone for manual records, status (pending / active / inactive / left), joined_at, approved_by | Unique (mosque_id, user_id) |
| `membership_roles` | Roles in a mosque | membership_id, role, granted_by, granted_at | Many roles per membership |
| `invitations` | Staff invites | mosque_id, phone/email, roles, token (hashed), status, expires_at, invited_by | Expires after 7 days |

### 3.3 Prayer Times

| Entity | Purpose | Key data | Notes |
|---|---|---|---|
| `iqamah_rules` | Iqamah per prayer | mosque_id, prayer (fajr…isha), mode (fixed / offset), fixed_time, offset_minutes, adhan_adjust_minutes, effective_from | History kept by effective date |
| `jumuah_sessions` | Friday prayers | mosque_id, khutbah_time, prayer_time, language, location_note, active | Multiple per mosque |
| `special_prayers` | Taraweeh, Eid, etc. | mosque_id, type, date (or date range), time, location, notes | |

> Daily Adhan times are **calculated on the device** from mosque coordinates and settings; they are not stored per day (saves storage, works offline). Optional server cache can be added later.

### 3.4 Finance & Donations

| Entity | Purpose | Key data | Notes |
|---|---|---|---|
| `finance_categories` | Income & expense categories | mosque_id, kind (income / expense), name (localized), is_system, active | Seeded defaults per mosque |
| `funds` | Funds & campaigns | mosque_id, name, description, kind (general / restricted / campaign), target_amount, start_date, end_date, image_path, status, is_public | General Fund created by default |
| `donors` | Non-registered donors | mosque_id, name, phone, linked user_id (optional) | Anonymous donations have no donor |
| `transactions` | **Single ledger** for all money movements | mosque_id, kind (donation / income / expense / opening_balance), amount, currency, transaction_date, category_id, fund_id, payment_method, reference_no, payee (expenses), donor_id / donor_user_id, donation_type (sadaqah, zakat, zakat_al_fitr, waqf, general), is_anonymous, receipt_no, note, status (approved / pending / rejected / voided), approved_by, approved_at, approval_comment, voided_by, voided_at, void_reason | Recommendation: one ledger table makes balance and reports simple; final decision in Phase 3 |
| `receipt_sequences` | Receipt numbering | mosque_id, year, last_number | Number assigned atomically on server |
| `attachments` | Receipt / invoice files | mosque_id, owner table & id, storage_path, mime_type, size, uploaded_by | Files in private bucket |
| `period_closings` (v1.1) | Locked months | mosque_id, period (YYYY-MM), closed_by, closed_at | Locked periods reject edits |

**Finance rules**
- FIN-DB-01 Balance = Σ approved inflows (donation, income, opening_balance) − Σ approved expenses; voided/pending/rejected excluded.
- FIN-DB-02 Amount must be > 0; kind decides direction.
- FIN-DB-03 Expense status `pending` when amount ≥ mosque threshold; approval only by a Mosque Admin who is not the creator.
- FIN-DB-04 Approved or voided transactions cannot be edited; correction = void + new entry.
- FIN-DB-05 Receipt numbers unique per mosque, sequential, never reused (format e.g. `<mosque code>-<year>-<6 digits>`).
- FIN-DB-06 Every insert/update/void/approve writes an `audit_logs` row in the same database transaction.

### 3.5 Education

| Entity | Purpose | Key data | Notes |
|---|---|---|---|
| `classes` | Qur'an / Islamic classes | mosque_id, name, level, gender_group, age_group, schedule (days + start/end time), room, capacity, status | |
| `class_teachers` | Teachers per class | class_id, membership_id | Teacher role required |
| `students` | Student records | mosque_id, full_name, date_of_birth, gender, guardian_name, guardian_phone, photo_path, notes, user_id (optional), status | Minors' data — restricted access |
| `enrollments` | Student ↔ class | class_id, student_id, enrolled_at, withdrawn_at, status | |
| `class_sessions` | One meeting of a class | class_id, session_date, start_time, taken_by, notes | Created when attendance is taken |
| `attendance_records` | Per student per session | session_id, student_id, status (present / absent / late / excused), note | Unique (session_id, student_id) |
| `quran_progress` | Memorization tracking | student_id, class_id, teacher membership, date, type (new / revision / reading), surah_no, from_ayah, to_ayah, juz, page, quality, notes | Ayah range validated against `surahs` |
| `assessments` | Exams / tests | student_id, class_id, title, score, max_score, date, remarks | |
| `surahs` | Reference data (114) | number, name_ar, name_en, name_so, ayah_count, juz_start | Global read-only table |
| `guardians` (v1.1) | Parent ↔ student link | student_id, user_id, relationship | For Parent role |

### 3.6 Events

| Entity | Purpose | Key data | Notes |
|---|---|---|---|
| `events` | Mosque events | mosque_id, title, description, category, starts_at, ends_at, location, image_path, audience, capacity, registration_required, status (draft / published / cancelled), recurrence (v1.1) | |
| `event_registrations` | Sign-ups | event_id, user_id, status (registered / cancelled / checked_in), registered_at | Unique (event_id, user_id); capacity check on server |

### 3.7 Announcements & Notifications

| Entity | Purpose | Key data | Notes |
|---|---|---|---|
| `announcements` | Mosque or platform notices | mosque_id (null = platform-wide), title, body, image_path, attachment_path, priority, audience_type (all / staff / role / class), audience_value, publish_at, expires_at, send_push, status, created_by | |
| `notifications` | Per-user inbox | user_id, mosque_id, type, title, body, deep_link, data (json), read_at | Created by server functions |
| `device_tokens` | FCM tokens | user_id, token, platform (android / ios), app_version, last_seen_at | One user, many devices |
| `notification_preferences` | Opt-in per category | user_id, mosque_id, category, enabled | Prayer reminder settings stay on device |
| `push_log` | Delivery tracking & rate limits | mosque_id, announcement_id, sent_count, failed_count, sent_at | |

### 3.8 Audit

| Entity | Purpose | Key data | Notes |
|---|---|---|---|
| `audit_logs` | Immutable history | mosque_id (nullable), actor_user_id, action (create / update / void / approve / reject / role_change / login_support_access …), entity_table, entity_id, old_values (json), new_values (json), created_at, ip/device info (optional) | Insert-only: no update/delete policy for anyone |

---

## 4. Storage (Supabase Storage) Buckets

| Bucket | Content | Access |
|---|---|---|
| `mosque-public` | Mosque logos, covers, event images, campaign images | Public read; write by MA/IM/TR of that mosque |
| `avatars` | User profile photos | Read by members of shared mosques; write by owner |
| `student-photos` | Student photos (often minors) | Private; read by MA/IM/teachers of the class; signed URLs |
| `finance-receipts` | Expense / income receipts | Private; TR and MA of the mosque only; signed URLs |
| `announcement-media` | Images / PDFs in announcements | Readable by mosque members |
| `reports` | Generated PDF reports (temporary) | Private; creator only; auto-delete after 7 days |

Path convention: `<bucket>/<mosque_id>/<entity>/<uuid>.<ext>` so storage policies can check `mosque_id`.

File limits: images ≤ 5 MB before compression, PDFs ≤ 10 MB; allowed types jpg, png, webp, pdf.

---

## 5. Server-side Logic Required (designed in Phase 3)

| Item | Type | Purpose |
|---|---|---|
| Create profile on sign-up | DB trigger | Insert into `profiles` |
| Role-check helper functions | SQL functions | e.g., `has_role(mosque_id, role)`, `is_member(mosque_id)` used by RLS |
| Next receipt number | DB function | Atomic sequential numbering |
| Expense status on insert | DB trigger / function | Set pending vs approved by threshold |
| Audit logging | Triggers | Write `audit_logs` for finance, roles, settings |
| Capacity check | DB function | Prevent over-registration |
| Send push notifications | Edge Function | FCM fan-out, respects preferences and rate limits |
| Scheduled announcements & event reminders | Scheduled job (pg_cron / scheduled Edge Function) | Publish at time, remind registrants |
| Report data | DB views / RPC | Aggregated finance & education data |
| Account deletion | Edge Function | Anonymize profile, keep financial history |

---

## 6. Data Retention

| Data | Retention |
|---|---|
| Financial transactions & audit logs | Kept for at least 7 years (or as mosque/local law requires); never auto-deleted |
| Deleted user accounts | Profile anonymized immediately; references kept as "Deleted user" |
| Notifications inbox | 90 days |
| Generated report files | 7 days |
| Device tokens | Removed when invalid or after 90 days inactive |
| Withdrawn students | Kept (history); MA can archive |

## 7. Seed / Reference Data

- 114 surahs with ayah counts and names (Arabic, English, Somali).
- Default finance categories (income & expense) copied to each new mosque.
- Default "General Fund".
- Prayer calculation method list.
- Payment method list (Cash, EVC Plus, Zaad, Sahal, e-Dahab, Bank transfer, Other).

## 8. Open Data Questions (for Phase 3)

1. One `transactions` ledger vs separate tables for donations / income / expenses — recommendation: **one ledger**.
2. Enums vs lookup tables for categories that mosques may customize — recommendation: **lookup tables** for categories, **enums** for fixed statuses.
3. Multi-currency within one mosque? — recommendation: **no** in MVP (one currency per mosque).
4. Should student records be shareable between mosques? — recommendation: **no**, per-mosque only.
