-- Table access for logged-in users
grant select, insert, update, delete on orgs        to authenticated;
grant select, insert, update, delete on org_members to authenticated;
grant select, insert, update, delete on tasks       to authenticated;

grant execute on function is_org_member(uuid) to authenticated;
grant execute on function is_org_admin(uuid)  to authenticated;