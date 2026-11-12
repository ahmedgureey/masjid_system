-- 0001_mosques.sql
--
-- First backend slice: the mosque profile.
--
-- Mirrors lib/features/mosque/models/mosque.dart field for field, so the
-- existing Dart model needs no reshaping. Multi-language fields are jsonb
-- holding the same {"so": "...", "en": "...", "ar": "..."} map that
-- LocalizedText already serialises.
--
-- Run this whole file once in the Supabase SQL Editor. It is idempotent:
-- running it twice is harmless.
--
-- Everything up to COMMIT is one transaction. If the paste is cut short, or
-- any statement fails, Postgres rolls the whole thing back and nothing is
-- half-created. The last statement prints what exists afterwards — read it.

begin;

-- ---------------------------------------------------------------------------
-- 1. Tables
-- ---------------------------------------------------------------------------

create table if not exists public.mosques (
  -- Text, not uuid: the app already identifies the mosque by a readable id
  -- ('al-ikhlas'), and changing that would ripple through every repository.
  id                   text primary key,

  name                 jsonb not null default '{}'::jsonb,
  subtitle             jsonb,
  description          jsonb,

  category             text check (category in ('jamia', 'masjid', 'musalla')),
  established_year     integer check (established_year between 1 and 2200),
  registration_number  text,

  logo_url             text,
  cover_url            text,

  country              text,
  city                 text,
  district             text,
  address              text,
  latitude             double precision check (latitude between -90 and 90),
  longitude            double precision check (longitude between -180 and 180),

  phone                text,
  email                text,
  website              text,

  -- {"facebook": "https://...", ...}
  social_links         jsonb not null default '{}'::jsonb,

  imam_name            text,
  chairman_name        text,
  administrator_name   text,
  treasurer_name       text,

  -- Values of MosqueFacility: womenPrayerArea, quranRooms, ablution,
  -- parking, accessibility.
  facilities           text[] not null default '{}',

  created_at           timestamptz not null default now(),
  updated_at           timestamptz not null default now()
);

comment on table public.mosques is
  'One row per mosque. Public read; only that mosque''s admins may edit.';

-- Who may administer which mosque. Deliberately a separate table rather than
-- a flag on the user: the platform is multi-tenant, and one person can run
-- more than one mosque (docs/project-overview.md A2).
create table if not exists public.mosque_admins (
  mosque_id  text not null references public.mosques(id) on delete cascade,
  user_id    uuid not null references auth.users(id)     on delete cascade,
  role       text not null default 'admin'
               check (role in ('admin', 'super_admin')),
  created_at timestamptz not null default now(),
  primary key (mosque_id, user_id)
);

comment on table public.mosque_admins is
  'Grants edit rights on a mosque. Rows are created by an operator, never by the app.';

-- ---------------------------------------------------------------------------
-- 2. updated_at
-- ---------------------------------------------------------------------------

create or replace function public.touch_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at := now();
  return new;
end;
$$;

drop trigger if exists mosques_touch_updated_at on public.mosques;
create trigger mosques_touch_updated_at
  before update on public.mosques
  for each row execute function public.touch_updated_at();

-- ---------------------------------------------------------------------------
-- 3. Permission helper
-- ---------------------------------------------------------------------------

-- security definer so the policy can read mosque_admins without the caller
-- needing select rights on it. search_path is pinned: without that, a
-- caller-controlled search_path could point the function at another schema.
create or replace function public.is_mosque_admin(p_mosque_id text)
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists (
    select 1
    from public.mosque_admins
    where mosque_id = p_mosque_id
      and user_id = auth.uid()
  );
$$;

revoke all on function public.is_mosque_admin(text) from public;
grant execute on function public.is_mosque_admin(text) to anon, authenticated;

-- ---------------------------------------------------------------------------
-- 4. Row Level Security
-- ---------------------------------------------------------------------------

alter table public.mosques       enable row level security;
alter table public.mosque_admins enable row level security;

-- Anyone, signed in or not, may read a mosque profile: that is the point of
-- the app's visitor mode.
drop policy if exists mosques_public_read on public.mosques;
create policy mosques_public_read
  on public.mosques
  for select
  to anon, authenticated
  using (true);

-- Only an administrator of that specific mosque may change it.
drop policy if exists mosques_admin_update on public.mosques;
create policy mosques_admin_update
  on public.mosques
  for update
  to authenticated
  using (public.is_mosque_admin(id))
  with check (public.is_mosque_admin(id));

-- No insert or delete policy on purpose: creating and removing mosques is an
-- operator action through the SQL editor until the Super Admin flow exists.
-- With RLS on and no policy, the client simply cannot do it.

-- A signed-in user may see which mosques they administer, and nothing else.
drop policy if exists mosque_admins_read_own on public.mosque_admins;
create policy mosque_admins_read_own
  on public.mosque_admins
  for select
  to authenticated
  using (user_id = auth.uid());

-- ---------------------------------------------------------------------------
-- 5. Seed
-- ---------------------------------------------------------------------------

-- The same mosque the app ships as local sample data, so the switch from
-- in-memory to Postgres changes nothing a user can see. Every other column
-- stays null: the app shows "not added yet" rather than inventing details.
insert into public.mosques (id, name)
values (
  'al-ikhlas',
  '{"so": "Masjid Al-Ikhlas", "en": "Masjid Al-Ikhlas", "ar": "مسجد الإخلاص"}'::jsonb
)
on conflict (id) do nothing;

commit;

-- ---------------------------------------------------------------------------
-- 6. Proof
--
-- The grid below is the answer to "did it work?". Expect exactly two rows:
--
--   mosque_admins | 1 policy  | rls true | (no row count)
--   mosques       | 2 policies| rls true | 1 row
--
-- No rows at all means nothing was created. rls_enabled = false on either
-- table means stop: that table would be world-writable.
-- ---------------------------------------------------------------------------

select
  c.relname                                               as table_name,
  (select count(*) from pg_policies p
     where p.schemaname = 'public' and p.tablename = c.relname) as policies,
  c.relrowsecurity                                        as rls_enabled,
  case c.relname when 'mosques'
       then (select count(*) from public.mosques) end     as mosque_rows
from pg_class c
join pg_namespace n on n.oid = c.relnamespace
where n.nspname = 'public'
  and c.relname in ('mosques', 'mosque_admins')
order by c.relname;
