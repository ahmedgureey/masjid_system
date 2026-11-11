# Masjid Al-Ikhlas — Design & Architecture Plan

Status: **approved to proceed with recommended defaults** (2026-11-11). Items marked *(default)* were proposed by the developer and accepted by "continue"; the owner can still change them.

## 1. Direction

| Topic | Decision |
|---|---|
| Scope | Single mosque: **Masjid Al-Ikhlas** (tables keep `mosque_id`, so more mosques can be added later) *(default)* |
| Roles | Super Administrator · Mosque Administrator · Content Editor *(default; replaces the 7-role model of Phase 1 docs)* |
| Start-up | Splash → **Welcome** ("Gal" / "Samee akoon") → Login → Home *(owner decision, 2026-11-11 — replaces the earlier no-login default)* |
| Admin dashboard | Flutter Web, same repository, separate entry point (`lib/main_admin.dart`) *(default)* |
| Backend | Supabase (Auth, PostgreSQL + RLS, Storage, Edge Functions) |
| Prayer times | Calculated on device (`adhan`) from admin-configured settings; per-date overrides in `prayer_times` |
| Maps | Open Google Maps / Apple Maps with coordinates (`url_launcher`); embedded map optional later |
| Payments | Not integrated until an authorised provider is configured and verified; collected totals come only from real recorded donations |
| Content languages | Somali, Arabic (RTL), English; translatable fields stored as `jsonb` `{"so","ar","en"}` with fallback |
| Real data | No invented mosque information. Missing content is shown as a clearly labelled empty state until an administrator adds it |

Earlier planning documents (Phase 1–3) describe a multi-mosque platform with classes, attendance and finance. They remain for reference; this plan takes precedence where they differ.

## 2. Home screen

Header: cover photo (admin-uploaded; labelled placeholder until then), circular logo, mosque name, subtitle (shown only when provided), live date and time, language button.

Menu — six cards, two columns × three rows:

| # | English | Somali *(default)* | Arabic | Icon |
|---|---|---|---|---|
| 1 | Mosque Profile | Macluumaadka Masaajidka | عن المسجد | Mosque |
| 2 | Prayer Times | Waqtiyada Salaadda | مواقيت الصلاة | Clock |
| 3 | Mosque Calendar | Kalandarka Masaajidka | تقويم المسجد | Calendar |
| 4 | News & Articles | Wararka iyo Maqaallada | الأخبار والمقالات | Newspaper |
| 5 | Donation Program | Barnaamijka Deeqaha | برنامج التبرعات | Heart |
| 6 | Contact Us *(default)* | Nala Soo Xiriir | اتصل بنا | Phone |

Card style: white background, light green border, rounded corners (16), subtle shadow, icon in a light-green (`#E8F3EC` ≈ `#E7F3EB`) circle.

## 3. Database (Supabase / PostgreSQL)

`users` (profiles, role) · `mosques` · `mosque_settings` · `prayer_settings` · `prayer_times` (overrides) · `mosque_events` · `article_categories` · `islamic_articles` · `donation_campaigns` · `donations` (void, never delete) · `contact_information` · `notifications` · `audit_logs` (insert-only).

RLS: anonymous visitors read **published** rows only; Content Editor writes articles, events, notifications; Mosque Administrator writes everything for the mosque; Super Administrator writes everything. Storage bucket `mosque-media` (public read, role-restricted write).

## 4. Phases

| # | Phase | Status |
|---|---|---|
| 1 | Design system & reference analysis | Tokens reused; **reference image not received yet** |
| 2 | Architecture | Repository interfaces + localized content model |
| 3 | Database | **Blocked:** needs a Supabase project and owner approval |
| 4 | Home screen | In progress |
| 5 | Prayer dashboard | — |
| 6 | Prayer-time management | — |
| 7 | Mosque profile & calendar | — |
| 8 | News & articles | — |
| 9 | Donations | — |
| 10 | Admin dashboard | — |
| 11 | Auth, security, languages | — |
| 12 | Testing & deployment | — |

## 5. Needed from the owner

1. The reference image.
2. Real Masjid Al-Ikhlas content: cover photo, logo, subtitle, address and coordinates, history, imam, services, contacts, social links.
3. A Supabase project (dev) for Phase 3.
4. Android SDK on the development machine for Android testing.
