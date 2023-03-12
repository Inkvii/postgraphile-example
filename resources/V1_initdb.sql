begin;
create schema if not exists registration;

create table if not exists handler
(
    id   serial primary key,
    name varchar not null
);

create table if not exists store
(
    id      serial primary key,
    address varchar not null
);

create table animal_type
(
    name varchar primary key,
    type varchar not null
);

create table if not exists pet
(
    id          serial primary key,
    name        varchar                               not null,
    age         smallint,
    store_id    int references store (id)             not null,
    handler_id  int references handler (id),
    animal_type varchar references animal_type (name) not null
);


commit;
