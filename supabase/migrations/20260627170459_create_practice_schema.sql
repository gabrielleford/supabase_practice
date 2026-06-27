  create table orgs (
    id uuid primary key default gen_random_uuid(),
    name text not null,
    created_at timestamptz not null default now()
  );

    create table org_members (
    org_id  uuid references orgs(id) on delete cascade,
    user_id uuid references auth.users(id) on delete cascade,
    role    text not null default 'member',   -- 'admin' | 'member'
    primary key (org_id, user_id)
  );

  create table tasks (
    id      uuid primary key default gen_random_uuid(),
    org_id  uuid not null references orgs(id) on delete cascade,
    title   text not null,
    done    boolean not null default false
  );