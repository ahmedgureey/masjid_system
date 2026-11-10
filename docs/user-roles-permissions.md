# User Roles & Permissions

## 1. Role Model

- **Platform scope:** `Super Admin` — works across all mosques.
- **Mosque scope:** all other roles are assigned **per mosque** through a *membership*. A person can be, for example, a Teacher at Mosque A and a Member at Mosque B (assumption A2).
- A user may hold **more than one role in the same mosque** (e.g., Imam + Teacher). Permissions are the **union** of their roles.
- Every registered user of a mosque is at least a **Mosque Member**.
- Students who are young children may exist as **student records without a login** (assumption A9).

Abbreviations used below: **SA** Super Admin · **MA** Mosque Admin · **IM** Imam · **TR** Treasurer · **TE** Teacher · **ST** Student · **MM** Mosque Member.

---

## 2. Role Descriptions

### 2.1 Super Admin (SA)
**Who:** Platform owner / operator.
**Responsibilities:**
- Approve, create, suspend and delete mosques.
- Assign the first Mosque Admin of each mosque.
- View platform-wide statistics (number of mosques, users, activity) — **not** detailed mosque finances by default.
- Manage global settings: supported languages, prayer calculation methods, donation categories templates, app version requirements.
- Send platform-wide announcements (e.g., maintenance notices).
- Handle support issues and review audit logs.

> Privacy rule: SA can access a mosque's detailed data only for support purposes, and every such access is logged.

### 2.2 Mosque Admin (MA)
**Who:** Mosque chairman / committee manager.
**Responsibilities:**
- Edit mosque profile (name, address, location, logo, contacts, bank / mobile-money details).
- Invite staff and assign roles (Imam, Treasurer, Teacher); approve member join requests.
- Approve or reject expenses above the approval threshold.
- Full read access to all mosque modules and reports.
- Manage events and announcements.
- Configure mosque settings (currency, calculation method, approval threshold, categories).

### 2.3 Imam (IM)
**Who:** Leads prayers and religious programs.
**Responsibilities:**
- Set and update Iqamah times, Jumu'ah times and special prayers (Taraweeh, Eid).
- Adjust calculated prayer times (± minutes) when needed.
- Publish religious announcements and reminders (e.g., khutbah topic, Ramadan program).
- Create and manage religious events (lectures, Eid, nikah, janazah notices).
- View education overview (classes, teachers) — read only.

### 2.4 Treasurer (TR)
**Who:** Responsible for the mosque's money.
**Responsibilities:**
- Record donations (sadaqah, zakat, waqf, general fund, project-specific).
- Record other income (rent, fees, event income) and expenses (utilities, salaries, maintenance).
- Attach receipts / invoices; issue donation receipts to donors.
- Void (not delete) incorrect entries with a reason.
- Manage donation campaigns / funds (e.g., "New roof project" with target).
- Produce and export financial reports.

### 2.5 Teacher (TE)
**Who:** Qur'an / Islamic studies teacher (macallin).
**Responsibilities:**
- Manage **own** classes: schedule, enrolled students.
- Take attendance for own classes.
- Record memorization (hifz) and revision progress, grades, notes.
- Send messages/announcements to own class.
- View reports for own classes.

### 2.6 Student (ST)
**Who:** Learner enrolled in one or more classes.
**Responsibilities / access:**
- View own class schedule, teacher, attendance record and progress.
- Receive class announcements.
- All Member capabilities.

### 2.7 Mosque Member (MM)
**Who:** Regular worshipper / community member.
**Access:**
- View prayer times, Iqamah times, Qibla direction, Hijri date.
- View announcements and events; register for events.
- View own donation history and receipts (when the Treasurer links a donation to their account).
- View mosque profile and donation/payment details.
- Manage own profile and notification preferences.

---

## 3. Permission Matrix

Legend: **C** create · **R** read · **U** update · **D** delete/void · **A** approve · **own** = only own records/classes · **—** no access.

### 3.1 Platform & Mosque

| Resource | SA | MA | IM | TR | TE | ST | MM |
|---|---|---|---|---|---|---|---|
| Mosques (all) | CRUD | — | — | — | — | — | — |
| Own mosque profile | R U | R U | R | R | R | R | R |
| Mosque settings | R | R U | R | R | — | — | — |
| Global settings | CRUD | — | — | — | — | — | — |
| Platform statistics | R | — | — | — | — | — | — |
| Audit log | R (all) | R (own mosque) | — | — | — | — | — |

### 3.2 People

| Resource | SA | MA | IM | TR | TE | ST | MM |
|---|---|---|---|---|---|---|---|
| Assign Mosque Admin | C D | — | — | — | — | — | — |
| Staff roles (IM/TR/TE) | R | C R U D | R | R | R | — | — |
| Member list | R | C R U D | R | R | R (own students) | — | — |
| Member join requests | — | A | — | — | — | — | — |
| Own profile | R U | R U | R U | R U | R U | R U | R U |

### 3.3 Prayer Times

| Resource | SA | MA | IM | TR | TE | ST | MM |
|---|---|---|---|---|---|---|---|
| Prayer times / Iqamah | R | C R U | C R U | R | R | R | R |
| Jumu'ah & special prayers | R | C R U | C R U | R | R | R | R |
| Calculation method | R | R U | R U | R | R | R | R |

### 3.4 Finance

| Resource | SA | MA | IM | TR | TE | ST | MM |
|---|---|---|---|---|---|---|---|
| Donations | — * | R | — | C R U D(void) | — | — | R (own) |
| Income | — * | R | — | C R U D(void) | — | — | — |
| Expenses | — * | R A | — | C R U D(void) | — | — | — |
| Funds / campaigns | — * | C R U | R | C R U | R | R | R (public progress) |
| Categories | — | C R U | — | C R U | — | — | — |
| Financial reports | — * | R | — | R | — | — | — (optional public summary) |

\* SA has no routine access to mosque finances; temporary support access is logged.

### 3.5 Education

| Resource | SA | MA | IM | TR | TE | ST | MM |
|---|---|---|---|---|---|---|---|
| Classes | — | C R U D | R | — | R U (own) | R (own) | — |
| Assign teacher to class | — | C U | — | — | — | — | — |
| Student records | — | C R U D | R | — | C R U (own class) | R (own) | — |
| Enroll students | — | C R U D | — | — | C R U (own class) | — | — |
| Attendance | — | R U (after edit window) | R | — | C R U (own class, within edit window) | R (own) | — |
| Qur'an progress | — | R | R | — | C R U (own class) | R (own) | — |
| Education reports | — | R | R | — | R (own class) | — | — |

### 3.6 Events, Announcements, Notifications

| Resource | SA | MA | IM | TR | TE | ST | MM |
|---|---|---|---|---|---|---|---|
| Events | — | C R U D | C R U D | R | R | R | R |
| Event registration | — | R (list) | R (list) | R | R | C (self) | C (self) |
| Announcements (mosque-wide) | C (platform-wide) | C R U D | C R U D | R | R | R | R |
| Class announcements | — | C R | — | — | C R (own class) | R (own) | — |
| Send push notification | C (platform) | C | C | — | C (own class) | — | — |

### 3.7 Reports

| Report | SA | MA | IM | TR | TE | ST | MM |
|---|---|---|---|---|---|---|---|
| Platform usage | R | — | — | — | — | — | — |
| Financial (income/expense/donations) | — | R | — | R | — | — | — |
| Membership | — | R | R | — | — | — | — |
| Attendance & progress | — | R | R | — | R (own) | R (own) | — |
| Events participation | — | R | R | — | — | — | — |
| Export PDF / Excel | R | R | R | R | R (own) | — | — |

---

## 4. Key Permission Rules

1. **Tenant isolation:** a user only sees data of mosques where they have an active membership (enforced by database RLS, not only by the app UI).
2. **Least privilege:** each role sees only what it needs; Treasurer cannot manage classes, Teacher cannot see finances.
3. **Separation of duties:** the person who records an expense above the threshold cannot be the one who approves it (Treasurer records, Mosque Admin approves). If MA is also TR, a second MA or the threshold rule must be configured (see Open Decision D10).
4. **No hard delete of financial data:** "delete" means *void with reason*; the original stays in the audit trail.
5. **Role changes are logged** (who changed which role, when).
6. **Last admin protection:** a mosque must always have at least one active Mosque Admin.
7. **Suspended mosque:** when SA suspends a mosque, all non-SA access to its data is blocked; users see a "mosque suspended" message (matches SEC-AUTHZ-09).

## 5. Future Role (recommended)

| Role | Purpose | Release |
|---|---|---|
| Parent / Guardian | View child's attendance & progress, receive class notices | v1.1 (Decision D7) |
| Committee Member / Auditor | Read-only finance access for transparency | v2 |
