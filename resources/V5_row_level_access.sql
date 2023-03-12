begin;

alter table handler
    enable row level security;
alter table pet
    enable row level security;

-- authenticated users can only see what is theirs
create policy handler_policy on handler to authenticated using (id = current_setting('jwt.claims.user_id', true)::integer);
create policy handler_policy on pet to authenticated using (handler_id = current_setting('jwt.claims.user_id', true)::integer);

-- policy where unauthenticated user can see pets that are not yet owned
create policy unauthenticated_pets on pet to unauthenticated using (handler_id is null);


commit;
