# Backend (Supabase)

Project: `masjidsystem` — `https://shujpessldyxbtneacpa.supabase.co` (eu-central-1).

Migrations in `migrations/` are run **in filename order** in the Supabase
**SQL Editor**. Each one is idempotent, so re-running it is harmless.

## Applying a migration

1. Open the project → **SQL Editor** → **New query**.
2. Paste the whole file.
3. **Run**, and read the result before moving on.

## 0001_mosques.sql

Creates `mosques` and `mosque_admins`, the `updated_at` trigger, the
`is_mosque_admin()` helper, the Row Level Security policies, and seeds the
one mosque the app already shows.

### Check it worked

Run this afterwards and keep the output:

```sql
select table_name,
       (select count(*) from pg_policies p
         where p.schemaname = 'public' and p.tablename = t.table_name) as policies,
       (select relrowsecurity from pg_class c
         where c.relname = t.table_name) as rls_on
from information_schema.tables t
where table_schema = 'public'
  and table_name in ('mosques', 'mosque_admins')
order by table_name;

select id, name->>'en' as name_en from public.mosques;
```

Expected:

| table_name | policies | rls_on |
|---|---|---|
| mosque_admins | 1 | true |
| mosques | 2 | true |

and one mosque row, `al-ikhlas` / `Masjid Al-Ikhlas`.

If `rls_on` is ever `false`, stop — the table is world-writable until it is
fixed.

## Granting yourself admin

Editing a mosque requires a row in `mosque_admins`, and that needs a real
auth user. So **sign up in the app first**, then run:

```sql
insert into public.mosque_admins (mosque_id, user_id, role)
select 'al-ikhlas', id, 'super_admin'
from auth.users
where email = 'you@example.com'   -- the address you signed up with
on conflict (mosque_id, user_id) do nothing;
```

Confirm:

```sql
select m.mosque_id, m.role, u.email
from public.mosque_admins m
join auth.users u on u.id = m.user_id;
```

Without that row you can read the profile but not change it — which is the
policy working, not a bug.

## Design notes

- `mosques.id` is `text`, not `uuid`. The app already identifies the mosque by
  a readable id (`al-ikhlas`), and changing the type would ripple through
  every repository for no benefit at this stage.
- Multi-language fields are `jsonb` holding the same map `LocalizedText`
  already serialises — no translation table yet, because nothing needs to
  query by translated text.
- There is **no insert or delete policy** on `mosques`. With RLS enabled and
  no policy, clients cannot create or remove mosques at all; that stays an
  operator action until the Super Admin flow exists.
- `is_mosque_admin()` is `security definer` with a pinned `search_path`.
  Without the pin, a caller-controlled `search_path` could point it at a
  different schema.

## Keys

The app reads the project URL and the **publishable** key from
`--dart-define` (see `lib/core/config/supabase_config.dart`). The key is kept
in `.env.local`, which is gitignored. A `service_role` or `sb_secret_…` key
must never appear in the app, this repo, or a build.
