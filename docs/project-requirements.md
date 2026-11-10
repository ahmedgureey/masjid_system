# Project Requirements

Business-level requirements: what the project must achieve, for whom, and under which constraints. Detailed system behaviour is in [functional-requirements.md](functional-requirements.md) and quality attributes in [non-functional-requirements.md](non-functional-requirements.md).

---

## 1. Stakeholders

| Stakeholder | Interest |
|---|---|
| Project owner | Delivers a sellable, reliable product to mosques |
| Mosque committees | Transparent finance, easy administration |
| Imams & teachers | Less paperwork, organized programs |
| Community members & donors | Accurate prayer times, trust in how donations are used |
| Students & parents | Visibility into attendance and progress |
| Developers (incl. Claude Code) | Clear, consistent, testable requirements |

## 2. Business Requirements (BR)

| ID | Requirement | Priority |
|---|---|---|
| BR-01 | The system shall support many mosques on one platform, with strict data isolation between mosques. | Must |
| BR-02 | Each mosque shall manage its own staff, members, finances, classes and events. | Must |
| BR-03 | Every financial transaction shall be traceable (who, when, what, receipt) and not silently deletable. | Must |
| BR-04 | Community members shall receive accurate prayer times and Iqamah times for their mosque. | Must |
| BR-05 | Mosques shall be able to broadcast announcements to their community by push notification. | Must |
| BR-06 | Teachers shall record attendance and Qur'an progress for their students. | Must |
| BR-07 | Leadership shall get financial and educational reports, exportable as PDF/Excel. | Must |
| BR-08 | Access to data shall be controlled by role (7 roles). | Must |
| BR-09 | The app shall be usable by non-technical users, in Somali and English. | Must |
| BR-10 | The app shall be published on Google Play and Apple App Store. | Must |
| BR-11 | Mosques shall be able to organize events and track registrations. | Should |
| BR-12 | Members shall be able to see their own donation history and receipts. | Should |
| BR-13 | The system should allow online donations in a later release. | Could (v2) |
| BR-14 | The system should support a web dashboard for admins in a later release. | Could (v2) |

## 3. User Requirements (summary by role)

| Role | Needs |
|---|---|
| Super Admin | Create/approve mosques, assign Mosque Admins, monitor platform usage, suspend mosques |
| Mosque Admin | Configure the mosque, manage staff and members, approve expenses, see all reports |
| Imam | Set Iqamah & Jumu'ah times, publish religious announcements, manage religious events |
| Treasurer | Record donations/income/expenses, issue receipts, produce financial reports |
| Teacher | Manage own classes, take attendance, record memorization progress |
| Student | See schedule, attendance and progress |
| Mosque Member | See prayer times, announcements, events; register for events; see own donations |

## 4. Constraints

| ID | Constraint |
|---|---|
| C-01 | Technology is fixed: Flutter, Dart, Supabase (PostgreSQL, Auth, Storage), Firebase FCM, GitHub. |
| C-02 | Must run on Android 7.0 (API 24)+ and iOS 13+ (to be confirmed against Flutter/FCM minimums at setup time). |
| C-03 | Many users have low-end Android phones and unstable / expensive mobile data. |
| C-04 | Budget-conscious: use Supabase and Firebase free/low tiers during pilot. |
| C-05 | iOS builds require an Apple Developer account (annual fee) and a macOS build machine or CI service. |
| C-06 | SMS OTP has a per-message cost (via Supabase-supported SMS provider such as Twilio). |
| C-07 | Islamic content (prayer times, Hijri dates, terms) must be accurate and respectful. |

## 5. Assumptions

See [project-overview.md §10](project-overview.md#10-working-assumptions-to-be-confirmed). Key ones: multi-tenant, Somali + English, manual donation recording in MVP, calculated prayer times with manual Iqamah, mobile-only MVP.

## 6. Dependencies

| Dependency | Used for | Risk |
|---|---|---|
| Supabase | DB, Auth, Storage, Edge Functions | Vendor outage; free-tier project pausing after inactivity |
| Firebase (FCM) | Push notifications | Requires APNs key for iOS |
| SMS provider | Phone OTP | Cost, delivery reliability in the region |
| Prayer-time calculation library (e.g., `adhan` Dart package) | Offline prayer calculation | Accuracy depends on correct method/coordinates |
| Google Play / App Store | Distribution | Review times, policy compliance |

## 7. Risks

| ID | Risk | Impact | Mitigation |
|---|---|---|---|
| R-01 | Data leak between mosques | High | RLS on every table, automated RLS tests |
| R-02 | Financial records altered or deleted | High | No hard delete; void/reversal entries; audit log |
| R-03 | Wrong prayer times | High | Configurable method, manual adjustment, Imam verification |
| R-04 | Low adoption by older users | Medium | Simple UI, Somali language, large text support |
| R-05 | Scope creep | Medium | Strict MVP boundary in [project-scope.md](project-scope.md) |
| R-06 | Poor connectivity | Medium | Local caching, lightweight payloads |
| R-07 | Push notification abuse (spam) | Low | Only authorized roles can send; rate limits |

## 8. Success Criteria for the Project

- MVP released on both stores.
- At least one pilot mosque using finance, prayer times, announcements and education modules for 4 consecutive weeks.
- Zero cross-mosque data access in security tests.
- Crash-free sessions ≥ 99%.
