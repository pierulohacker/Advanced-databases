create or replace function login (email in VARCHAR2, pass in VARCHAR2) return user_tab.user_id%type as
confirmation number;
user_reg user_t;
user_id user_tab.user_id%type;
name_of_user VARCHAR2(30);
begin
select u.user_id, treat(value(u) as registered_t).name_user, 
rownum rw into user_id, name_of_user, confirmation from user_tab u 
where value(u) is of type (registered_t) and treat(value(u) as registered_t).email=email and
treat(value(u) as registered_t).psw=pass
and rownum=1;
return user_id;
end;
/

create or replace function new_registered_user(name_user in VARCHAR2, surname in VARCHAR2, email in VARCHAR2, psw in VARCHAR2) return user_tab.user_id%type as 
u_id user_tab.user_id%type;
begin
if (name_user is null) or (surname is null) or (email is null) or (psw is null) then
  raise_application_error('-20099', 'some input values are null');
else 
insert into user_tab values (registered_t(email, psw, name_user,surname))RETURNING user_id into u_id;
return u_id;
end if;
end;

/

create or replace function new_unknown_user return user_tab.user_id%type as
u_id user_tab.user_id%type;
begin
insert into user_tab  values(unknown_t())RETURNING user_id into u_id;
return u_id;
end;
/
--aggiornamento cronologia più restituzione testo
create or replace
function retrieve_text(u_id in number, input_url in varchar2) return page_tab.title%type as
text_retrieved page_tab.title%type;
begin
--aggiornamento cronologia
insert into table(select u.pages_read from user_tab u where u.user_id=u_id) values ((select ref(p) from page_tab p where p.url=input_url));
--restituzione testo
select title into text_retrieved from page_tab where url=input_url;
return text_retrieved;
end;

/

