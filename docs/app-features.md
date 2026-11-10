# Application Features

Feature catalogue grouped by module. Release tags follow [project-scope.md](project-scope.md): **MVP**, **v1.1**, **v2**. Each feature maps to functional requirements in [functional-requirements.md](functional-requirements.md).

---

## 1. Authentication & Profile
| Feature | Description | Release |
|---|---|---|
| Phone OTP login | Register / log in with phone number and SMS code | MVP |
| Email login | Email + password, forgot-password link | MVP |
| Profile | Name, photo, contact, preferred language | MVP |
| Mosque switcher | Switch between mosques the user belongs to | MVP |
| Account deletion | Self-service, store-compliant | MVP |
| Biometric unlock | Fingerprint / Face ID | v1.1 |

## 2. Mosque Management
| Feature | Description | Release |
|---|---|---|
| Mosque registration request | Anyone can request to add their mosque; SA approves | MVP |
| Mosque profile | Logo, cover, description, address, map location, facilities, contacts | MVP |
| Mosque settings | Currency, timezone, prayer method, approval threshold, language | MVP |
| Mosque directory | Search mosques by name / city, join | MVP |
| Nearby mosques | Location-based discovery | v1.1 |
| Platform dashboard (SA) | Mosques, users, requests, activity | MVP |

## 3. Staff & Members
| Feature | Description | Release |
|---|---|---|
| Join requests | Members request to join; MA approves | MVP |
| Staff invitations | Invite Imam / Treasurer / Teacher by phone or email | MVP |
| Role management | Multi-role per user, per mosque | MVP |
| Member directory | Search, filter by role/status (staff only) | MVP |
| Manual member records | For people without the app | MVP |
| CSV import | Bulk add members | v1.1 |

## 4. Prayer Times
| Feature | Description | Release |
|---|---|---|
| Daily prayer times | Calculated Adhan times + Iqamah, offline | MVP |
| Next-prayer countdown | Highlighted in Gold on home screen | MVP |
| Iqamah management | Fixed time or offset; manual adjustments | MVP |
| Jumu'ah & special prayers | Multiple Jumu'ah sessions, Taraweeh, Eid | MVP |
| Monthly timetable | Scrollable month view | MVP |
| Prayer reminders | Local notifications before Adhan / Iqamah | MVP |
| Qibla compass | Direction to Kaaba | MVP |
| Hijri calendar | Hijri date on home and timetable | MVP |
| Share timetable | PDF/image export | v1.1 |
| Home-screen widget | Next prayer widget | v2 |

## 5. Donations & Sadaqah
| Feature | Description | Release |
|---|---|---|
| Record donation | Type, amount, method, reference, donor/anonymous | MVP |
| Donation receipts | Auto-numbered PDF receipt, share via WhatsApp etc. | MVP |
| Funds & campaigns | Targets, progress bar, linked donations & expenses | MVP |
| My donations | Member's personal history and receipts | MVP |
| How to donate | Mosque's mobile money / bank details | MVP |
| Void with reason | Corrections without deleting history | MVP |
| Donation pledge / "I donated" | Member submits reference; TR confirms | v1.1 |
| Zakat calculator | Informational tool | v1.1 |
| Online payments | EVC Plus / Zaad / Sahal / card integration | v2 |
| Recurring donation reminders | Monthly pledges | v2 |

## 6. Finance
| Feature | Description | Release |
|---|---|---|
| Income recording | Non-donation income with categories | MVP |
| Expense recording | Categories, payee, receipt photo | MVP |
| Expense approval | Threshold-based approval by Mosque Admin | MVP |
| Finance dashboard | Balance, monthly totals, 6-month chart, pending items | MVP |
| Transactions ledger | Filter, search, detail view | MVP |
| Category management | Custom income/expense categories | MVP |
| Opening balance | Starting balance setup | MVP |
| Audit trail | Every change recorded | MVP |
| Period closing | Lock past months | v1.1 |
| Payroll | Staff salary records | v2 |

## 7. Qur'an Education
| Feature | Description | Release |
|---|---|---|
| Class management | Levels, schedule, room, capacity, teachers | MVP |
| Student records | With or without app account; guardian info | MVP |
| Enrollment | Add/withdraw students from classes | MVP |
| Attendance | Mark-all-present + exceptions; P/A/L/E | MVP |
| Qur'an progress | Memorization / revision by surah & ayah; quality rating | MVP |
| Assessments | Exam scores and remarks | MVP |
| Student profile | Attendance %, memorization summary | MVP |
| Class announcements | Teacher → class | MVP |
| Student view | Own schedule, attendance, progress | MVP |
| Offline attendance | Sync later | v1.1 |
| Parent/Guardian access | Child's records & alerts | v1.1 |
| Absence alerts | After N consecutive absences | v1.1 |
| Certificates | Completion certificates (PDF) | v2 |
| Class fees | Tuition tracking linked to finance | v2 |

## 8. Events
| Feature | Description | Release |
|---|---|---|
| Event management | Create, edit, cancel; categories; audience; capacity | MVP |
| Event list & calendar | Upcoming / past | MVP |
| Registration | Register / cancel, capacity limits | MVP |
| Registrant list | View & export | MVP |
| Event reminders | Push before event | MVP |
| Add to calendar | Device calendar | v1.1 |
| QR check-in | Attendance at events | v1.1 |
| Recurring events | Weekly halaqa etc. | v1.1 |

## 9. Announcements & Notifications
| Feature | Description | Release |
|---|---|---|
| Announcements | Text, image, priority, audience, scheduling, expiry | MVP |
| Push notifications | FCM to targeted audience | MVP |
| Notification inbox | Read/unread history | MVP |
| Preferences | Per-category on/off | MVP |
| Pinned urgent notices | E.g., janazah | MVP |
| Deep links | Open related screen | MVP |
| Platform announcements | SA → all users | MVP |
| SMS fallback | For non-smartphone members | v2 |

## 10. Reports
| Feature | Description | Release |
|---|---|---|
| Income & expense statement | Period, by category | MVP |
| Donations report | By type, fund, method | MVP |
| Fund report | Collected / spent / remaining | MVP |
| Attendance report | Per class / student | MVP |
| Progress report | Per class / student | MVP |
| Membership report | Counts, growth | MVP |
| PDF export & share | All reports | MVP |
| Excel/CSV export | All reports | v1.1 |
| Transparency summary | Public monthly totals | v1.1 |
| Platform usage report (SA) | Mosques, users, activity | MVP |

## 11. Settings
| Feature | Description | Release |
|---|---|---|
| Language | Somali / English (Arabic v1.1) | MVP |
| Notification settings | Per category, prayer reminders | MVP |
| Audit log viewer | MA (mosque), SA (global) | MVP |
| Force update | Minimum app version | MVP |
| Legal & support | Terms, privacy, contact | MVP |
| Dark mode | Theme switch | v1.1 |

---

## Feature Count Summary

| Release | Approx. features |
|---|---|
| MVP | ~70 |
| v1.1 | ~20 |
| v2 | ~10 |
