begin;
-- create user types
create role unauthenticated;
create role authenticated;
create role admin;


-- create user groups
create role all_users;
grant usage on schema public to all_users;
grant usage on schema registration to all_users;
grant execute on all functions in schema registration to all_users;

-- unauthenticated - basically should be able only to log in. No private data should be visible by default
grant all_users to unauthenticated;
grant select on table animal_type to unauthenticated;
grant select on table pet to unauthenticated;


-- authenticated - regular user, should view only globally public data and their own only
grant all_users to authenticated;
grant select on all tables in schema public to authenticated;
-- revoked store table as a test to see that authenticated user can access all but store
revoke all ON store FROM authenticated;

-- admin - should be able to do anything except for deleting user data
grant all_users to admin;
grant all on database example to admin;
grant all on all tables in schema public to admin;
grant select, insert on all tables in schema security to admin;



commit;
