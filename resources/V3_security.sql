begin;
create extension pgcrypto;

create schema if not exists security;

create role unauthenticated;
create role authenticated;
create role admin;


create type security.jwt_token as
(
    role     text,
    exp      integer,
    user_id  integer,
    is_admin boolean,
    username varchar
);

create table security.person_account
(
    id            serial primary key,
    username      varchar not null unique,
    salt          varchar not null,
    password_hash varchar not null,
    is_admin      boolean default false
);

create or replace function public.authenticate(
    username varchar,
    password varchar
) returns security.jwt_token as
$$
declare
    account  security.person_account;
    var_role varchar;
begin
    select a.*
    into account
    from security.person_account as a
    where a.username = authenticate.username;

    if account.password_hash = crypt(password, account.salt) then
        if account.is_admin then
            var_role := 'admin';
        else
            var_role := 'authenticated';
        end if;


        return (
                var_role,
                extract(epoch from now() + interval '100 minutes'),
                account.id,
                account.is_admin,
                account.username
            )::security.jwt_token;
    else
        return null;
    end if;
end;
$$ language plpgsql strict
                    security definer;

create or replace function public.register(var_username varchar, var_password varchar) returns void as
$$
declare
    salt varchar;
begin
    select gen_salt('bf') into salt;
    insert into security.person_account(username, password_hash, salt) VALUES (var_username, crypt(var_password, salt), salt);
end
$$ language plpgsql;

create or replace function current_user_id() returns integer as
$$
begin
    return coalesce(current_setting('jwt.claims.id', true)::integer, -1)::integer;
end
$$ language plpgsql;

grant execute on all functions in schema security to unauthenticated;

grant execute on all functions in schema security to authenticated;
grant select on all tables in schema public to authenticated;
revoke all ON store FROM authenticated;

grant all on database example to admin;
grant all on all tables in schema public to admin;


alter table handler
    enable row level security;
create policy handler_policy on handler to authenticated using (id = current_setting('jwt.claims.user_id', true)::integer);

commit;


