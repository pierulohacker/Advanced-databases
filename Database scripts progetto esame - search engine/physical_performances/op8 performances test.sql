set timing on;
DECLARE
BEGIN
  TEST_LOGIN('ludovicaileniaputtilli294@mail.com',	'66ludovicaileniaputtilli1975');
END;
--create unique index email_password on user_tab u (treat(value(u) as registered_t).email, treat(value(u) as registered_t).psw);