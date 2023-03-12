begin;

insert into store(address)
values ('address 1, City'),
       ('address 2, City'),
       ('address 3, City2'),
       ('address 4, City2'),
       ('address 5, City3'),
       ('address 6, City3'),
       ('address 7, City3');


insert into handler(name)
values ('First'),
       ('Second'),
       ('Third'),
       ('Fourth'),
       ('Fifth'),
       ('Sixth'),
       ('Seventh'),
       ('Eight'),
       ('Ninth');

insert into animal_type (name, type)
VALUES ('Cat', 'meat-lover'),
       ('Dog', 'omnivore');

insert into pet (name, age, store_id, handler_id, animal_type)
VALUES ('Catticus magnus', 1, 1, null, 'Cat'),
       ('Yiffy', 2, 2, null, 'Dog'),
       ('Sir Bark', 3, 3, 1, 'Dog'),
       ('Satan', 4, 4, 1, 'Cat'),
       ('Here boy', 5, 5, 2, 'Dog'),
       ('Fluff', 6, 6, 2, 'Cat'),
       ('Snowflake', 2, 2, 3, 'Cat'),
       ('Rex', 3, 3, 4, 'Dog'),
       ('Azor', 4, 4, null, 'Cat'),
       ('Pokealot', 5, 5, 3, 'Cat'),
       ('Cake', 6, 6, null, 'Cat'),
       ('Blackie', 2, 2, 5, 'Cat'),
       ('Evil personified', 3, 3, 6, 'Cat'),
       ('Meowcelot', 4, 4, 7, 'Cat'),
       ('Catarkus', 5, 5, 8, 'Cat'),
       ('Poker', 6, 6, 9, 'Dog');

commit;
