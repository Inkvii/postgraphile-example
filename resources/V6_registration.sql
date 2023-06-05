begin;

select registration.register('admin', 'asd123ASD!');
select registration.register('guest', 'asd123ASD!');

update security.person_account
set is_admin = true
where username = 'admin';

commit;
