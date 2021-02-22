set timing on;
insert into user_tab values (registered_t('prova', 'prova_psw', 'prova_name','provasurname'));
--delete from user_tab u where treat(value(u) as registered_t).email='prova';