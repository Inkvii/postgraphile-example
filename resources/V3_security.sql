begin;
create extension pgcrypto with schema public;


create type registration.jwt_token as
(
    role     text,
    exp      integer,
    user_id  integer,
    is_admin boolean,
    username varchar
);

create schema if not exists security;
create table security.person_account
(
    id            serial primary key,
    username      varchar not null unique,
    salt          varchar not null,
    password_hash varchar not null,
    is_admin      boolean default false
);

create or replace function registration.authenticate(
    username varchar,
    password varchar
) returns registration.jwt_token as
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
            )::registration.jwt_token;
    else
        return null;
    end if;
end;
$$ language plpgsql strict
                    security definer;

create or replace function registration.register(var_username varchar, var_password varchar) returns void as
$$
declare
    salt varchar;
begin
    select gen_salt('bf') into salt;
    insert into security.person_account(username, password_hash, salt) VALUES (var_username, crypt(var_password, salt), salt);
end
$$ language plpgsql;

commit;


