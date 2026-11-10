# Functional Requirements

Each requirement has an ID (`FR-<MODULE>-<NN>`), the roles involved, and a release tag:
**MVP** = v1.0 launch · **v1.1** = first update after launch · **v2** = later. Release boundaries are defined in [project-scope.md](project-scope.md).

Role abbreviations: SA, MA, IM, TR, TE, ST, MM (see [user-roles-permissions.md](user-roles-permissions.md)).

---

## 1. Authentication & Account (AUTH)

| ID | Requirement | Roles | Release |
|---|---|---|---|
| FR-AUTH-01 | User can register with phone number (OTP verification) or email + password. | All | MVP |
| FR-AUTH-02 | User can log in with phone OTP or email + password. | All | MVP |
| FR-AUTH-03 | User can reset a forgotten password via email link (email accounts). | All | MVP |
| FR-AUTH-04 | Session persists securely; user stays logged in until logout or token expiry. | All | MVP |
| FR-AUTH-05 | User can log out from the current device. | All | MVP |
| FR-AUTH-06 | User can view and edit own profile (name, photo, phone, email, gender, language). | All | MVP |
| FR-AUTH-07 | User can delete own account (store requirement); financial records stay anonymized. | All | MVP |
| FR-AUTH-08 | User with memberships in several mosques can switch the active mosque. | All | MVP |
| FR-AUTH-09 | Optional biometric unlock (fingerprint / Face ID) for returning users. | All | v1.1 |

## 2. Mosque Management (MOSQ)

| ID | Requirement | Roles | Release |
|---|---|---|---|
| FR-MOSQ-01 | A user can submit a "register my mosque" request (name, address, city, country, GPS location, contact, proof). | Any user | MVP |
| FR-MOSQ-02 | SA can approve or reject mosque registration requests, with a reason. | SA | MVP |
| FR-MOSQ-03 | SA can create a mosque directly and assign its first Mosque Admin. | SA | MVP |
| FR-MOSQ-04 | SA can suspend / reactivate a mosque. | SA | MVP |
| FR-MOSQ-05 | MA can edit mosque profile: name, description, logo, cover photo, address, location, phone, email, facilities, donation payment details. | MA | MVP |
| FR-MOSQ-06 | MA can configure mosque settings: currency, timezone, prayer calculation method, Asr method, expense approval threshold, default language. | MA | MVP |
| FR-MOSQ-07 | Users can search / browse approved mosques by name or city and view a public mosque profile. | All | MVP |
| FR-MOSQ-08 | Users can find nearby mosques using device location. | All | v1.1 |
| FR-MOSQ-09 | SA can view platform dashboard: total mosques, users, active users, pending requests. | SA | MVP |
| FR-MOSQ-10 | SA can search users and view their memberships and roles (for support). | SA | MVP |

## 3. Staff & Member Management (MEMB)

| ID | Requirement | Roles | Release |
|---|---|---|---|
| FR-MEMB-01 | A user can request to join a mosque as a member. | All | MVP |
| FR-MEMB-02 | MA can approve / reject join requests (or set mosque to auto-approve). | MA | MVP |
| FR-MEMB-03 | MA can invite a person by phone/email to a role (Imam, Treasurer, Teacher); invite expires after 7 days. | MA | MVP |
| FR-MEMB-04 | MA can assign / remove roles for an existing member. | MA | MVP |
| FR-MEMB-05 | MA can deactivate a membership (user loses access to that mosque). | MA | MVP |
| FR-MEMB-06 | MA can view, search and filter the member and staff list (by role, status). | MA (IM, TR read) | MVP |
| FR-MEMB-07 | MA can add a member record manually (for people without the app). | MA | MVP |
| FR-MEMB-08 | System prevents removing the last active Mosque Admin. | System | MVP |
| FR-MEMB-09 | User can leave a mosque. | All | MVP |
| FR-MEMB-10 | Import members from CSV. | MA | v1.1 |

## 4. Prayer Times (PRAY)

| ID | Requirement | Roles | Release |
|---|---|---|---|
| FR-PRAY-01 | System calculates daily Fajr, Sunrise, Dhuhr, Asr, Maghrib, Isha from mosque coordinates, timezone and calculation method (works offline). | System | MVP |
| FR-PRAY-02 | IM/MA can set Iqamah time per prayer: fixed time or offset (minutes after Adhan). | IM, MA | MVP |
| FR-PRAY-03 | IM/MA can apply manual adjustments (± minutes) to calculated Adhan times. | IM, MA | MVP |
| FR-PRAY-04 | IM/MA can set Jumu'ah khutbah and prayer times (supports multiple Jumu'ah sessions). | IM, MA | MVP |
| FR-PRAY-05 | IM/MA can set special prayers: Taraweeh, Eid al-Fitr, Eid al-Adha (date, time, location). | IM, MA | MVP |
| FR-PRAY-06 | Users see today's times, next prayer with countdown, Hijri and Gregorian date. | All | MVP |
| FR-PRAY-07 | Users can view monthly timetable. | All | MVP |
| FR-PRAY-08 | Users can enable local reminder notifications before Adhan / Iqamah (configurable per prayer). | All | MVP |
| FR-PRAY-09 | Members are notified when Iqamah times change. | System | MVP |
| FR-PRAY-10 | Qibla direction compass. | All | MVP |
| FR-PRAY-11 | Export / share monthly timetable as PDF / image. | IM, MA | v1.1 |
| FR-PRAY-12 | Home-screen widget showing next prayer. | All | v2 |

## 5. Donations & Sadaqah (DON)

| ID | Requirement | Roles | Release |
|---|---|---|---|
| FR-DON-01 | TR can record a donation: amount, currency, date, type (Sadaqah, Zakat, Zakat al-Fitr, Waqf, General, Fund/Campaign), payment method (Cash, EVC Plus, Zaad, Sahal, e-Dahab, Bank, Other), reference number, donor. | TR | MVP |
| FR-DON-02 | Donor can be a registered member, a non-registered named person, or **Anonymous**. | TR | MVP |
| FR-DON-03 | System generates a unique receipt number per mosque and a shareable PDF receipt. | TR | MVP |
| FR-DON-04 | TR can void a donation with a mandatory reason; voided donations are excluded from totals but remain visible in audit. | TR | MVP |
| FR-DON-05 | TR/MA can create funds / campaigns (name, description, target amount, start/end date, image) and link donations to them. | TR, MA | MVP |
| FR-DON-06 | Members can view active campaigns with progress (collected vs target). | All | MVP |
| FR-DON-07 | Members can view their own donation history and download receipts. | MM | MVP |
| FR-DON-08 | Members can view the mosque's donation payment instructions (mobile money numbers, bank account). | All | MVP |
| FR-DON-09 | Member can submit a "pledge / I have donated" notification with reference number; TR confirms it into a donation. | MM, TR | v1.1 |
| FR-DON-10 | Zakat calculator (informational). | All | v1.1 |
| FR-DON-11 | Online payment inside the app (mobile money / card) with automatic recording. | MM | v2 |
| FR-DON-12 | Recurring donation reminders (e.g., monthly pledge). | MM | v2 |

## 6. Finance — Income & Expenses (FIN)

| ID | Requirement | Roles | Release |
|---|---|---|---|
| FR-FIN-01 | TR can record income other than donations: category (Rent, Fees, Event income, Other), amount, date, method, reference, note, attachment. | TR | MVP |
| FR-FIN-02 | TR can record an expense: category (Electricity, Water, Salaries, Maintenance, Cleaning, Supplies, Education, Charity disbursement, Other), amount, date, payee, method, reference, note, receipt attachment. | TR | MVP |
| FR-FIN-03 | Expenses at or above the mosque's approval threshold get status **Pending** until MA approves or rejects (with comment). Below threshold: auto-approved. | TR, MA | MVP |
| FR-FIN-04 | MA receives a notification for each pending expense. | System | MVP |
| FR-FIN-05 | TR can void income/expense entries with reason (no hard delete). | TR | MVP |
| FR-FIN-06 | TR/MA can manage income and expense categories (add, rename, deactivate). | TR, MA | MVP |
| FR-FIN-07 | Finance dashboard: current balance, this month's income, expenses, donations, pending approvals, chart of last 6 months. | TR, MA | MVP |
| FR-FIN-08 | Transaction list with filters: date range, type, category, fund, payment method, status; text search. | TR, MA | MVP |
| FR-FIN-09 | Every create/update/void/approve action is written to the audit log. | System | MVP |
| FR-FIN-10 | Expenses can be linked to a fund/campaign (to show how restricted funds were spent). | TR | MVP |
| FR-FIN-11 | Opening balance setup when a mosque starts using the app. | TR, MA | MVP |
| FR-FIN-12 | Monthly period closing (lock a month so it can no longer be edited). | MA | v1.1 |
| FR-FIN-13 | Staff salary / payroll records. | TR | v2 |

## 7. Qur'an Education (EDU)

| ID | Requirement | Roles | Release |
|---|---|---|---|
| FR-EDU-01 | MA can create classes: name, level (e.g., Beginner, Hifz, Tajweed, Islamic Studies), gender group, age group, schedule (days & times), room, capacity, status. | MA | MVP |
| FR-EDU-02 | MA can assign one or more teachers to a class. | MA | MVP |
| FR-EDU-03 | MA/TE can create student records (name, date of birth, gender, guardian name & phone, photo, notes); linking to a user account is optional. | MA, TE | MVP |
| FR-EDU-04 | MA/TE can enroll / withdraw students in classes. | MA, TE (own) | MVP |
| FR-EDU-05 | TE can take attendance per class session: Present, Absent, Late, Excused (fast "mark all present" then exceptions). | TE | MVP |
| FR-EDU-06 | TE can edit attendance of a session within a configurable window (default 7 days); later edits need MA. | TE, MA | MVP |
| FR-EDU-07 | TE can record Qur'an progress per student: type (New memorization / Revision / Reading), surah, from ayah, to ayah (or juz/page), quality rating, notes, date. | TE | MVP |
| FR-EDU-08 | TE can record assessments / exam results (title, score, max score, date, remarks). | TE | MVP |
| FR-EDU-09 | Student profile shows attendance rate, memorization summary (surahs/juz completed), latest notes. | TE, MA, ST (own) | MVP |
| FR-EDU-10 | ST can view own schedule, attendance and progress. | ST | MVP |
| FR-EDU-11 | TE can send announcements to own class. | TE | MVP |
| FR-EDU-12 | Offline attendance taking with automatic sync when online. | TE | v1.1 |
| FR-EDU-13 | Parent/Guardian access to child's records (Decision D7). | Parent | v1.1 |
| FR-EDU-14 | Absence alert to guardian after N consecutive absences. | System | v1.1 |
| FR-EDU-15 | Certificates on completion (e.g., Juz Amma, full Hifz). | TE, MA | v2 |
| FR-EDU-16 | Tuition / class fee tracking linked to finance income. | TR | v2 |

## 8. Events (EVT)

| ID | Requirement | Roles | Release |
|---|---|---|---|
| FR-EVT-01 | MA/IM can create events: title, description, category (Lecture, Halaqa, Eid, Ramadan, Nikah, Janazah, Fundraiser, Community, Other), start/end, location, image, audience (All / Men / Women / Youth), capacity, registration required yes/no. | MA, IM | MVP |
| FR-EVT-02 | Users see upcoming and past events in list and calendar views. | All | MVP |
| FR-EVT-03 | Members can register / cancel registration for events requiring registration; capacity enforced. | MM, ST | MVP |
| FR-EVT-04 | MA/IM can view registrant list and export it. | MA, IM | MVP |
| FR-EVT-05 | Event creation can optionally send a push notification; registrants get a reminder before the event. | System | MVP |
| FR-EVT-06 | MA/IM can edit or cancel an event; registrants are notified. | MA, IM | MVP |
| FR-EVT-07 | Add event to device calendar. | All | v1.1 |
| FR-EVT-08 | QR code check-in at the event. | MA, IM | v1.1 |
| FR-EVT-09 | Recurring events (e.g., weekly halaqa). | MA, IM | v1.1 |

## 9. Announcements & Notifications (NOTI)

| ID | Requirement | Roles | Release |
|---|---|---|---|
| FR-NOTI-01 | MA/IM can create announcements: title, body, optional image/attachment, priority (Normal / Important / Urgent), audience (all members / staff / a class / a role), publish now or schedule, expiry date. | MA, IM | MVP |
| FR-NOTI-02 | TE can create announcements for own classes. | TE | MVP |
| FR-NOTI-03 | Publishing an announcement sends a push notification (FCM) to the target audience. | System | MVP |
| FR-NOTI-04 | Users see an announcement feed and an in-app notification inbox with read/unread state. | All | MVP |
| FR-NOTI-05 | Users can set notification preferences per category (prayer, announcements, events, classes, finance approvals). | All | MVP |
| FR-NOTI-06 | Urgent announcements (e.g., janazah) are pinned at the top of the feed. | System | MVP |
| FR-NOTI-07 | SA can send platform-wide announcements. | SA | MVP |
| FR-NOTI-08 | Deep links: tapping a notification opens the related screen. | System | MVP |
| FR-NOTI-09 | Rate limit on push notifications per mosque per day (configurable by SA). | System | MVP |
| FR-NOTI-10 | SMS fallback for users without smartphones. | MA | v2 |

## 10. Reports (REP)

| ID | Requirement | Roles | Release |
|---|---|---|---|
| FR-REP-01 | Income & expense statement for a period (by category, with totals and balance). | TR, MA | MVP |
| FR-REP-02 | Donations report: by type, fund, payment method, period; top-level totals (donor names hidden for anonymous). | TR, MA | MVP |
| FR-REP-03 | Fund/campaign report: collected, spent, remaining. | TR, MA | MVP |
| FR-REP-04 | Attendance report per class / student for a period. | TE (own), MA, IM | MVP |
| FR-REP-05 | Qur'an progress report per student / class. | TE (own), MA, IM | MVP |
| FR-REP-06 | Membership report: counts by role, status, new members per month. | MA, IM | MVP |
| FR-REP-07 | Export reports to **PDF** and share via the phone's share sheet. | per report | MVP |
| FR-REP-08 | Export reports to **Excel/CSV**. | per report | v1.1 |
| FR-REP-09 | Event participation report. | MA, IM | v1.1 |
| FR-REP-10 | Public transparency summary (monthly totals only, no names) that MA can choose to publish to members. | MA | v1.1 |
| FR-REP-11 | SA platform usage report. | SA | MVP |

## 11. Settings & Administration (SET)

| ID | Requirement | Roles | Release |
|---|---|---|---|
| FR-SET-01 | App language switch: Somali / English (Arabic in v1.1). | All | MVP |
| FR-SET-02 | Text size follows device accessibility settings. | All | MVP |
| FR-SET-03 | About, Terms of Use, Privacy Policy, Contact support screens. | All | MVP |
| FR-SET-04 | MA can view the mosque audit log (filter by user, module, date). | MA | MVP |
| FR-SET-05 | SA can view the global audit log. | SA | MVP |
| FR-SET-06 | SA can set minimum supported app version (force update prompt). | SA | MVP |
| FR-SET-07 | Dark mode. | All | v1.1 (D12) |
