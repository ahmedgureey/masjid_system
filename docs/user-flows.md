# User Flows

Step-by-step journeys for the most important tasks. Screen IDs (e.g., `S-AUTH-01`) refer to [screen-list.md](screen-list.md).

---

## 0. Navigation Model

After login, the app opens a **role-aware home** for the user's active mosque. The bottom navigation bar adapts to the user's roles:

| Tab | Shown to | Content |
|---|---|---|
| Home | All | Next prayer, today's times, pinned announcements, upcoming events, role shortcuts |
| Prayer | All | Today, monthly timetable, Qibla |
| Community | All | Announcements, events, campaigns |
| Workspace | MA, IM, TR, TE, ST | Role tools: Admin / Finance / Classes / My Learning (tabs inside if multiple roles) |
| Profile | All | Profile, my donations, mosque switcher, settings |

Super Admin has a separate **Platform** area (mosques, requests, statistics, global settings).

```
Splash → (first launch?) Onboarding → Language → Login/Register
       → (no mosque?) Find & Join Mosque
       → Home (active mosque)
```

---

## 1. First Launch, Registration & Login

**Actor:** any new user

1. Open app → **Splash** (`S-AUTH-01`) checks session and minimum app version.
2. First launch → **Language selection** (`S-AUTH-02`: Somali / English) → **Onboarding** slides (`S-AUTH-03`).
3. **Welcome** (`S-AUTH-04`): *Continue with phone* / *Continue with email*.
4. Phone path: enter phone with country code (`S-AUTH-05`) → receive SMS → enter 6-digit OTP (`S-AUTH-06`).
   Email path: email + password (`S-AUTH-07`) or register (`S-AUTH-08`); forgot password (`S-AUTH-09`).
5. New user → **Complete profile** (`S-AUTH-10`): full name, gender, optional photo.
6. If the user has a pending invitation → show **Invitation** (`S-MEMB-07`) to accept role.
7. If the user has no mosque → **Find mosque** (`S-MOSQ-01`).
8. If the user has one or more mosques → open **Home** of last active mosque.

**Errors:** wrong OTP (3 attempts then cooldown), expired OTP (resend after 60 s), no internet (retry banner).

---

## 2. Member Joins a Mosque

**Actor:** Mosque Member

1. **Find mosque** (`S-MOSQ-01`): search by name/city (or nearby in v1.1).
2. Open **Public mosque profile** (`S-MOSQ-02`): prayer times, address, description.
3. Tap **Join** → confirmation.
4. If mosque is set to *auto-approve* → membership active → Home.
   Otherwise → status *Pending*; user can still see public info (prayer times, public events).
5. MA receives notification → **Join requests** (`S-MEMB-03`) → Approve / Reject.
6. Member receives push: "Your membership at X Mosque has been approved" → full member access.

---

## 3. Registering a New Mosque (Onboarding)

**Actors:** requester → Super Admin → Mosque Admin

1. Requester: **Find mosque** → *My mosque is not listed* → **Mosque registration form** (`S-MOSQ-03`): name, address, city, country, map pin, phone, requester's role at mosque, optional proof photo.
2. Request status = *Pending*; requester sees status screen.
3. SA: **Mosque requests** (`S-SA-03`) → review details → Approve (requester becomes Mosque Admin) or Reject with reason.
4. Requester gets notification → opens **Mosque setup wizard** (`S-MOSQ-05`):
   1. Confirm profile & logo
   2. Timezone, currency
   3. Prayer calculation method & Asr method → preview today's times
   4. Iqamah times
   5. Expense approval threshold
   6. Invite staff (optional, can skip)
5. Mosque is live → MA Home dashboard.

---

## 4. Mosque Admin Invites Staff

**Actor:** Mosque Admin

1. Workspace → Admin → **Staff** (`S-MEMB-04`) → *Invite*.
2. **Invite form** (`S-MEMB-05`): phone or email, role(s) (Imam / Treasurer / Teacher), optional message.
3. System sends invitation (push if user exists, SMS/email link otherwise). Expires in 7 days.
4. Invitee logs in / registers → sees **Invitation** (`S-MEMB-07`) → Accept / Decline.
5. On accept: role added to their membership; MA notified; action logged in audit log.

**Alternative:** MA assigns a role to an existing member from **Member detail** (`S-MEMB-02`) → *Edit roles*.

---

## 5. Imam Updates Iqamah Times

**Actor:** Imam (or MA)

1. Workspace → **Prayer settings** (`S-PRAY-04`).
2. For each prayer choose: *Fixed time* (e.g., 13:15) or *Offset* (e.g., +15 min after Adhan); optional Adhan adjustment ± minutes.
3. Choose **effective date** (default: tomorrow).
4. Preview the next 7 days → Save.
5. System records the change, updates cached timetable, and sends push "Iqamah times updated" to members (if the toggle is on).
6. Members' local reminders are rescheduled the next time the app syncs.

**Jumu'ah / special prayers:** `S-PRAY-05` → add session(s): khutbah time, prayer time, language, location (e.g., Hall 2).

---

## 6. Member Daily Use — Prayer Times & Reminders

**Actor:** Mosque Member

1. Open app → Home shows **next prayer in Gold** with countdown, today's Adhan & Iqamah list, Hijri date.
2. Prayer tab → **Today** (`S-PRAY-01`), **Monthly timetable** (`S-PRAY-02`), **Qibla** (`S-PRAY-03`).
3. Profile → **Notification settings** (`S-SET-02`) → enable reminder "10 min before Iqamah" for chosen prayers.
4. App schedules local notifications (works offline).

---

## 7. Treasurer Records a Donation

**Actor:** Treasurer

1. Workspace → Finance → **+ Donation** (`S-DON-02`).
2. Enter: amount, date (default today), type (Sadaqah / Zakat / Zakat al-Fitr / Waqf / General / Fund), fund/campaign (optional), payment method, reference number (required for mobile money / bank).
3. Donor: search registered member **or** enter name & phone **or** toggle *Anonymous*.
4. Save → confirmation dialog shows summary → Confirm.
5. System assigns receipt number (e.g., `MSQ12-2026-000154`), writes audit log, updates fund progress and dashboard.
6. **Receipt** screen (`S-DON-04`) → Share PDF (WhatsApp, SMS, etc.).
7. If donor is a registered member → member receives notification and sees it in **My donations** (`S-DON-06`).

**Correction:** Donation detail → *Void* → reason (required) → confirm → entry marked *Voided*, totals recalculated, audit logged. A new correct entry is recorded if needed.

---

## 8. Treasurer Records an Expense & Approval

**Actors:** Treasurer, Mosque Admin

1. Treasurer: Finance → **+ Expense** (`S-FIN-03`): category, amount, date, payee, method, reference, note, receipt photo (camera / gallery), optional fund.
2. Save.
   - Amount < threshold → status **Approved** automatically.
   - Amount ≥ threshold → status **Pending**; MA gets push notification.
3. MA: notification → **Pending approvals** (`S-FIN-06`) → **Expense detail** (`S-FIN-05`) → view receipt → *Approve* or *Reject* (comment required on reject).
4. Treasurer is notified of the decision. Only **Approved** expenses count in balance and reports; Pending is shown separately on the dashboard.
5. Separation of duties: if the recorder is also an MA, they cannot approve their own expense (another MA must approve — see Open Decision D10).

---

## 9. Teacher Takes Attendance

**Actor:** Teacher

1. Workspace → Classes → **My classes** (`S-EDU-01`) → today's class shows *Take attendance*.
2. **Attendance session** (`S-EDU-06`): date & session pre-filled, student list with photos; all marked **Present** by default.
3. Tap a student to cycle: Present → Absent → Late → Excused (icon + label, not color only). Optional note.
4. Save → summary (e.g., 18 present, 2 absent) → Confirm.
5. Attendance stored; student profiles update attendance %.
6. Edits allowed for 7 days; after that MA must edit.
7. (v1.1) Offline: saved locally, synced automatically; guardian alert after N consecutive absences.

---

## 10. Teacher Records Qur'an Progress

**Actor:** Teacher

1. Class → student → **Student profile** (`S-EDU-04`) → *+ Progress*.
2. **Progress entry** (`S-EDU-08`): type (New / Revision / Reading), surah (searchable list of 114), from ayah → to ayah (validated against surah length) or juz/page, quality (Excellent / Good / Needs work / Repeat), notes.
3. Save → student's memorization summary updates (surahs/juz completed, last lesson).
4. Student (if they have an account) sees it in **My progress** (`S-EDU-12`).

---

## 11. Imam / Admin Publishes an Announcement

**Actor:** MA or IM (Teacher for own class)

1. Community → Announcements → **+ New** (`S-NOTI-02`).
2. Title, body, optional image/PDF, priority (Normal / Important / Urgent), audience (all members / staff / specific role / class), schedule (now or later), expiry date, *Send push* toggle.
3. Preview → Publish.
4. System stores announcement; at publish time an Edge Function sends FCM push to the audience (respecting user preferences and daily rate limit). Urgent ones are pinned.
5. Members tap notification → deep link → **Announcement detail** (`S-NOTI-03`).

---

## 12. Event Creation & Registration

**Actors:** MA/IM, Members

1. MA/IM: Community → Events → **+ Event** (`S-EVT-04`): title, category, description, date/time, location, image, audience, registration required?, capacity, *Notify members* toggle → Publish.
2. Member: event in list/calendar (`S-EVT-01`) → **Event detail** (`S-EVT-02`) → *Register*.
3. If capacity full → "Event full" (waitlist in a later release).
4. Registered member receives reminder (e.g., 1 day and 1 hour before).
5. MA/IM: **Registrants** (`S-EVT-05`) → view count & list → export PDF.
6. Event cancelled/changed → all registrants notified.

---

## 13. Generating a Report

**Actor:** Treasurer / Mosque Admin (Teacher for own classes)

1. Workspace → **Reports** (`S-REP-01`) → choose report type (only types allowed for the role are shown).
2. **Report filters** (`S-REP-02`): period (this month, last month, this year, custom), category/fund/class.
3. Generate → **Report preview** (`S-REP-03`) with totals and charts.
4. Export PDF → share sheet (WhatsApp, email, save to files). (Excel in v1.1.)

---

## 14. Switching Mosque

**Actor:** user with several memberships

1. Profile → **Mosque switcher** (`S-PROF-03`) → list of my mosques with my role(s).
2. Select → app reloads data and navigation for that mosque and role.

---

## 15. Super Admin Daily Flow

1. Login → **Platform dashboard** (`S-SA-01`): total mosques, users, pending requests, alerts.
2. **Mosque requests** (`S-SA-03`) → approve/reject.
3. **Mosques list** (`S-SA-02`) → mosque detail (`S-SA-04`) → suspend / reactivate / change Mosque Admin.
4. **Platform announcement** (`S-SA-06`) → send to all users.
5. **Global settings** (`S-SA-07`) and **Audit log** (`S-SET-04`).

---

## 16. Account Deletion

1. Profile → Settings → **Delete account** (`S-SET-06`).
2. Explanation of what is deleted and what is kept (financial records kept anonymized for mosque accounting).
3. Re-authenticate (OTP / password) → confirm.
4. If user is the **last Mosque Admin** of a mosque → blocked until another admin is assigned.
5. Account deleted → logout → Welcome screen.
