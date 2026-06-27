-- 1. Auth users — fixed IDs so the FK + impersonation stay stable across resets
insert into auth.users (
  instance_id, id, aud, role, email,
  encrypted_password, email_confirmed_at,
  raw_app_meta_data, raw_user_meta_data, created_at, updated_at,
  confirmation_token, email_change, email_change_token_new, recovery_token
) values
  ('00000000-0000-0000-0000-000000000000',
  '11111111-1111-4111-8111-111111111111',
  'authenticated', 'authenticated', 'jim@example.com',
  crypt('password123', gen_salt('bf')), now(),
  '{"provider":"email","providers":["email"]}', '{}', now(), now(),
  '', '', '', ''),
('00000000-0000-0000-0000-000000000000',
  '22222222-2222-4222-8222-222222222222',
  'authenticated', 'authenticated', 'dwight@example.com',
  crypt('password123', gen_salt('bf')), now(),
  '{"provider":"email","providers":["email"]}', '{}', now(), now(),
  '', '', '', ''),
('00000000-0000-0000-0000-000000000000',
  '33333333-3333-4333-8333-333333333333',
  'authenticated', 'authenticated', 'charles@example.com',
  crypt('password123', gen_salt('bf')), now(),
  '{"provider":"email","providers":["email"]}', '{}', now(), now(),
  '', '', '', ''),
('00000000-0000-0000-0000-000000000000',
  '44444444-4444-4444-8444-444444444444',
  'authenticated', 'authenticated', 'michael@example.com',
  crypt('password123', gen_salt('bf')), now(),
  '{"provider":"email","providers":["email"]}', '{}', now(), now(),
  '', '', '', ''),
('00000000-0000-0000-0000-000000000000',
  '55555555-5555-4555-8555-555555555555',
  'authenticated', 'authenticated', 'pam@example.com',
  crypt('password123', gen_salt('bf')), now(),
  '{"provider":"email","providers":["email"]}', '{}', now(), now(),
  '', '', '', ''),
('00000000-0000-0000-0000-000000000000',
  '66666666-6666-4666-8666-666666666666',
  'authenticated', 'authenticated', 'ryan@example.com',
  crypt('password123', gen_salt('bf')), now(),
  '{"provider":"email","providers":["email"]}', '{}', now(), now(),
  '', '', '', '');

-- 2. Matching identities (lets them actually log in)
insert into auth.identities (
  id, user_id, provider_id, identity_data, provider,
  last_sign_in_at, created_at, updated_at
)
select
  gen_random_uuid(), id, id::text,
  format('{"sub":"%s","email":"%s"}', id::text, email)::jsonb,
  'email', now(), now(), now()
from auth.users;

-- 3. Now your tables can reference those stable user IDs
insert into public.orgs (id, name) values
  ('00000000-0000-4000-8000-000000000001', 'Dunder Mifflin'),
  ('00000000-0000-4000-8000-000000000002', 'Michael Scott Paper Co.');

insert into public.org_members (org_id, user_id, name) values
  ('00000000-0000-4000-8000-000000000001', '11111111-1111-4111-8111-111111111111', 'Jim Halpert'),
  ('00000000-0000-4000-8000-000000000001', '22222222-2222-4222-8222-222222222222', 'Dwight Schrute'),
  ('00000000-0000-4000-8000-000000000001', '33333333-3333-4333-8333-333333333333', 'Charles Miner'),
  ('00000000-0000-4000-8000-000000000002', '44444444-4444-4444-8444-444444444444', 'Michael Scott'),
  ('00000000-0000-4000-8000-000000000002', '55555555-5555-4555-8555-555555555555', 'Pam Beesly'),
  ('00000000-0000-4000-8000-000000000002', '66666666-6666-4666-8666-666666666666', 'Ryan Howard');

insert into public.tasks
  (org_id, title)
values
  ('00000000-0000-4000-8000-000000000001', 'Task 1'),
  ('00000000-0000-4000-8000-000000000001', 'Task 2'),
  ('00000000-0000-4000-8000-000000000002', 'Task 3'),
  ('00000000-0000-4000-8000-000000000002', 'Task 4');


