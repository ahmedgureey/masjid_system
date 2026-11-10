# Complete Screen List

Screen ID format: `S-<MODULE>-<NN>`. Roles: SA, MA, IM, TR, TE, ST, MM (**All** = every logged-in user). Release: MVP / v1.1 / v2.

Shared UI components (not counted as screens): bottom navigation, app bar with mosque switcher, empty/error/loading states, confirmation dialogs, filter bottom sheet, image picker sheet, share sheet, offline banner.

---

## 1. Authentication & Onboarding (AUTH)

| ID | Screen | Roles | Release |
|---|---|---|---|
| S-AUTH-01 | Splash (session & app-version check) | All | MVP |
| S-AUTH-02 | Language selection | All | MVP |
| S-AUTH-03 | Onboarding slides (3) | All | MVP |
| S-AUTH-04 | Welcome (phone / email choice) | All | MVP |
| S-AUTH-05 | Phone number entry | All | MVP |
| S-AUTH-06 | OTP verification | All | MVP |
| S-AUTH-07 | Email login | All | MVP |
| S-AUTH-08 | Email registration | All | MVP |
| S-AUTH-09 | Forgot password | All | MVP |
| S-AUTH-10 | Complete profile | All | MVP |
| S-AUTH-11 | Force update | All | MVP |
| S-AUTH-12 | No connection (full-screen) | All | MVP |

## 2. Home & Dashboards (HOME)

| ID | Screen | Roles | Release |
|---|---|---|---|
| S-HOME-01 | Member home (next prayer, today's times, pinned notices, events, campaigns) | All | MVP |
| S-HOME-02 | Mosque Admin dashboard (members, finance summary, pending approvals, classes) | MA | MVP |
| S-HOME-03 | Imam dashboard (prayer settings shortcut, events, announcements) | IM | MVP |
| S-HOME-04 | Treasurer dashboard → see S-FIN-01 | TR | MVP |
| S-HOME-05 | Teacher dashboard (today's classes, take attendance) | TE | MVP |
| S-HOME-06 | Student dashboard (schedule, attendance %, last lesson) | ST | MVP |
| S-HOME-07 | Workspace hub (role tabs when user has several roles) | MA, IM, TR, TE, ST | MVP |

## 3. Mosque (MOSQ)

| ID | Screen | Roles | Release |
|---|---|---|---|
| S-MOSQ-01 | Find mosque (search / list) | All | MVP |
| S-MOSQ-02 | Public mosque profile | All | MVP |
| S-MOSQ-03 | Mosque registration request form | All | MVP |
| S-MOSQ-04 | Registration request status | Requester | MVP |
| S-MOSQ-05 | Mosque setup wizard (6 steps) | MA | MVP |
| S-MOSQ-06 | Edit mosque profile | MA | MVP |
| S-MOSQ-07 | Mosque settings (currency, timezone, threshold, auto-approve) | MA | MVP |
| S-MOSQ-08 | Donation payment details (edit) | MA | MVP |
| S-MOSQ-09 | Nearby mosques map | All | v1.1 |

## 4. Members & Staff (MEMB)

| ID | Screen | Roles | Release |
|---|---|---|---|
| S-MEMB-01 | Member list (search, filters) | MA (IM, TR read) | MVP |
| S-MEMB-02 | Member detail (roles, status, actions) | MA | MVP |
| S-MEMB-03 | Join requests | MA | MVP |
| S-MEMB-04 | Staff list | MA | MVP |
| S-MEMB-05 | Invite staff form | MA | MVP |
| S-MEMB-06 | Add member manually | MA | MVP |
| S-MEMB-07 | Invitation received (accept / decline) | Invitee | MVP |
| S-MEMB-08 | Edit roles | MA | MVP |
| S-MEMB-09 | CSV import | MA | v1.1 |

## 5. Prayer Times (PRAY)

| ID | Screen | Roles | Release |
|---|---|---|---|
| S-PRAY-01 | Today's prayer times | All | MVP |
| S-PRAY-02 | Monthly timetable | All | MVP |
| S-PRAY-03 | Qibla compass | All | MVP |
| S-PRAY-04 | Prayer & Iqamah settings | IM, MA | MVP |
| S-PRAY-05 | Jumu'ah sessions | IM, MA | MVP |
| S-PRAY-06 | Special prayers (Taraweeh, Eid) | IM, MA | MVP |
| S-PRAY-07 | Calculation method settings | IM, MA | MVP |
| S-PRAY-08 | Share timetable | IM, MA | v1.1 |

## 6. Donations (DON)

| ID | Screen | Roles | Release |
|---|---|---|---|
| S-DON-01 | Donations list | TR, MA | MVP |
| S-DON-02 | Record donation form | TR | MVP |
| S-DON-03 | Donation detail (void action) | TR, MA | MVP |
| S-DON-04 | Donation receipt (PDF preview / share) | TR, MM (own) | MVP |
| S-DON-05 | How to donate (payment details) | All | MVP |
| S-DON-06 | My donations | MM | MVP |
| S-DON-07 | Campaigns / funds list | All | MVP |
| S-DON-08 | Campaign detail (progress, linked donations & expenses) | All (finance detail TR/MA) | MVP |
| S-DON-09 | Create / edit campaign | TR, MA | MVP |
| S-DON-10 | "I have donated" pledge form | MM | v1.1 |
| S-DON-11 | Pledge confirmations queue | TR | v1.1 |
| S-DON-12 | Zakat calculator | All | v1.1 |
| S-DON-13 | Online payment checkout | MM | v2 |

## 7. Finance (FIN)

| ID | Screen | Roles | Release |
|---|---|---|---|
| S-FIN-01 | Finance dashboard | TR, MA | MVP |
| S-FIN-02 | Transactions ledger (all types, filters) | TR, MA | MVP |
| S-FIN-03 | Record expense form | TR | MVP |
| S-FIN-04 | Record income form | TR | MVP |
| S-FIN-05 | Transaction detail (receipt, history, void/approve) | TR, MA | MVP |
| S-FIN-06 | Pending approvals | MA | MVP |
| S-FIN-07 | Categories management | TR, MA | MVP |
| S-FIN-08 | Opening balance setup | TR, MA | MVP |
| S-FIN-09 | Receipt image viewer | TR, MA | MVP |
| S-FIN-10 | Period closing | MA | v1.1 |

## 8. Education (EDU)

| ID | Screen | Roles | Release |
|---|---|---|---|
| S-EDU-01 | Classes list (all for MA/IM; own for TE) | MA, IM, TE | MVP |
| S-EDU-02 | Class detail (schedule, teachers, students, stats) | MA, IM, TE | MVP |
| S-EDU-03 | Create / edit class | MA | MVP |
| S-EDU-04 | Student profile (attendance %, progress, assessments) | MA, IM, TE, ST (own) | MVP |
| S-EDU-05 | Add / edit student | MA, TE | MVP |
| S-EDU-06 | Take attendance | TE | MVP |
| S-EDU-07 | Attendance history (class calendar) | MA, TE | MVP |
| S-EDU-08 | Add Qur'an progress entry | TE | MVP |
| S-EDU-09 | Progress history | MA, IM, TE, ST (own) | MVP |
| S-EDU-10 | Add assessment | TE | MVP |
| S-EDU-11 | Enroll / withdraw students | MA, TE | MVP |
| S-EDU-12 | My learning (student: schedule, attendance, progress) | ST | MVP |
| S-EDU-13 | Students list (all students of mosque) | MA | MVP |
| S-EDU-14 | Guardian view of child | Parent | v1.1 |
| S-EDU-15 | Certificate generator | TE, MA | v2 |

## 9. Events (EVT)

| ID | Screen | Roles | Release |
|---|---|---|---|
| S-EVT-01 | Events list (upcoming / past) | All | MVP |
| S-EVT-02 | Event detail (register / cancel) | All | MVP |
| S-EVT-03 | Events calendar view | All | MVP |
| S-EVT-04 | Create / edit event | MA, IM | MVP |
| S-EVT-05 | Registrants list | MA, IM | MVP |
| S-EVT-06 | My registrations | All | MVP |
| S-EVT-07 | QR check-in scanner | MA, IM | v1.1 |

## 10. Announcements & Notifications (NOTI)

| ID | Screen | Roles | Release |
|---|---|---|---|
| S-NOTI-01 | Announcements feed | All | MVP |
| S-NOTI-02 | Create / edit announcement | MA, IM, TE (class) | MVP |
| S-NOTI-03 | Announcement detail | All | MVP |
| S-NOTI-04 | Notification inbox | All | MVP |
| S-NOTI-05 | Scheduled announcements (manage) | MA, IM | MVP |

## 11. Reports (REP)

| ID | Screen | Roles | Release |
|---|---|---|---|
| S-REP-01 | Reports hub (role-filtered) | MA, IM, TR, TE | MVP |
| S-REP-02 | Report filters | MA, IM, TR, TE | MVP |
| S-REP-03 | Report preview & export | MA, IM, TR, TE | MVP |

## 12. Profile (PROF)

| ID | Screen | Roles | Release |
|---|---|---|---|
| S-PROF-01 | My profile | All | MVP |
| S-PROF-02 | Edit profile | All | MVP |
| S-PROF-03 | Mosque switcher / my mosques | All | MVP |

## 13. Settings (SET)

| ID | Screen | Roles | Release |
|---|---|---|---|
| S-SET-01 | Settings | All | MVP |
| S-SET-02 | Notification & prayer reminder settings | All | MVP |
| S-SET-03 | Language | All | MVP |
| S-SET-04 | Audit log | MA (mosque), SA (global) | MVP |
| S-SET-05 | About / Terms / Privacy / Support | All | MVP |
| S-SET-06 | Delete account | All | MVP |
| S-SET-07 | Theme (light / dark) | All | v1.1 |

## 14. Super Admin (SA)

| ID | Screen | Roles | Release |
|---|---|---|---|
| S-SA-01 | Platform dashboard | SA | MVP |
| S-SA-02 | Mosques list | SA | MVP |
| S-SA-03 | Mosque registration requests | SA | MVP |
| S-SA-04 | Mosque detail (suspend, assign admin) | SA | MVP |
| S-SA-05 | Users list / search | SA | MVP |
| S-SA-06 | Platform announcement | SA | MVP |
| S-SA-07 | Global settings (min app version, methods, notification limits) | SA | MVP |
| S-SA-08 | Create mosque directly | SA | MVP |

---

## Screen Count

| Module | MVP | v1.1 | v2 | Total |
|---|---|---|---|---|
| Auth | 12 | 0 | 0 | 12 |
| Home | 7 | 0 | 0 | 7 |
| Mosque | 8 | 1 | 0 | 9 |
| Members | 8 | 1 | 0 | 9 |
| Prayer | 7 | 1 | 0 | 8 |
| Donations | 9 | 3 | 1 | 13 |
| Finance | 9 | 1 | 0 | 10 |
| Education | 13 | 1 | 1 | 15 |
| Events | 6 | 1 | 0 | 7 |
| Notifications | 5 | 0 | 0 | 5 |
| Reports | 3 | 0 | 0 | 3 |
| Profile | 3 | 0 | 0 | 3 |
| Settings | 6 | 1 | 0 | 7 |
| Super Admin | 8 | 0 | 0 | 8 |
| **Total** | **104** | **10** | **2** | **116** |

> S-HOME-04 reuses S-FIN-01, so the number of unique MVP screens to design is ~103.
