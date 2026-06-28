create or replace function public.is_org_member(target_org uuid)
returns boolean
language sql
security definer
set search_path = ''
stable
as $$
  select exists (
    select 1 from public.org_members
    where org_id = target_org and user_id = auth.uid()
  );
$$;

create or replace function public.is_org_admin(target_org uuid)
returns boolean
language sql
security definer
set search_path = ''
stable
as $$
  select exists (
    select 1 from public.org_members
    where org_id = target_org
      and user_id = auth.uid()
      and role = 'admin'
  );
$$;

-- create function is_org_member(target_org uuid)
-- returns boolean language sql security definer stable as $$
--   select exists (
--     select 1 from org_members
--     where org_id = target_org and user_id = auth.uid()
--   );
-- $$;

-- create function is_org_admin(target_org uuid)
-- returns boolean language sql security definer stable as $$
--   select exists (
--     select 1 from org_members
--     where org_id = target_org
--       and user_id = auth.uid()
--       and role = 'admin'
--   );
-- $$;

-- create function is_org_admin(user_role)
-- returns boolean language sql security definer stable as $$
--   select exists (
--     select 1 from org_members
--     where user_role = 'admin' and user_id = auth.uid()
--   );
-- $$;

create policy "members read their org tasks"
on tasks for select
using ( is_org_member(org_id) );

create policy "members insert into their org"
on tasks for insert
with check ( is_org_member(org_id) );

create policy "members can update tasks"
on tasks for update
with check ( is_org_member(org_id) );

create policy "admins delete tasks"
on tasks for delete
using ( is_org_admin(org_id) );

-- create policy 'admins delete tasks'
-- on tasks with delete
-- with check add 
--   constraint ( is_org_member(org_id) )
--   constraint ( is_org_admin(role) );