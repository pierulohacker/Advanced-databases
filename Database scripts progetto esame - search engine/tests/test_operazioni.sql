--test delle procedure
create or replace procedure test_uknown_user as
begin
new_unknown_user();
end;
/

create or replace procedure test_registered_user as
begin
new_registered_user('gianni','dipierri','giannino@gmail.com', 'giannino88');
end;
/

--test delle procedure
create or replace procedure test_uknown_user as
begin
new_unknown_user();
end;
/

create or replace procedure test_registered_user as
begin
new_registered_user('gianni','dipierri','giannino@gmail.com', 'giannino88');
end;
/
--implementazione in java perchè la procedura è vista come una transazione e le tabelle mutanti danno problemi
create or replace
procedure test_search_doc(search_keyword in search_tab.keyword%type, search_user_id in user_tab.user_id%type) as
result_numb number;
url page_tab.url%type;
term_ref ref term_t;
user_ref ref user_t;
cursor url_taker is 
  select deref(nt.page).url  from table(select inverted_index from term_tab where term_name=search_keyword) nt order by nt.occurrences;
begin
--troviamo il termine che matcha
select count(t.term_name) into result_numb from term_tab t where t.term_name=search_keyword;
if result_numb >0 then
  select ref(t) into term_ref from term_tab t where t.term_name= search_keyword and rownum=1;
  select ref(u) into user_ref from user_tab u where u.user_id= search_user_id and rownum=1;
  insert into search_tab(keyword, user_associated, term) 
    values (search_keyword, user_ref, term_ref);
  open url_taker;
  dbms_output.put_line('Risultati per la parola ' || search_keyword || ' UTENTE ID: ' || search_user_id);
  loop
    fetch url_taker INTO url;
    exit when url_taker%notfound;
    dbms_output.put_line(url);
  end loop;
  --se non trova nulla  comunque salva la ricerca ma senza riferimento al termine del db
end if;  
end;
/
--login utente
create or replace procedure test_login (email in VARCHAR2, pass in VARCHAR2) as
confirmation VARCHAR2(10);
user_reg user_t;
user_id user_tab.user_id%type;
name_of_user VARCHAR2(30);
begin
select treat(value(u) as registered_t).user_id, treat(value(u) as registered_t).name_user, 
rownum rw into user_id, name_of_user, confirmation 
from user_tab u 
where value(u) is of type (registered_t) and treat(value(u) as registered_t).email=email and
treat(value(u) as registered_t).psw=pass
and rownum=1;
if confirmation =0 then
dbms_output.put_line('utente inesistene');
else
dbms_output.put_line('Esiste: '|| name_of_user || user_id);
end if;
end;
/
create or replace
procedure most_searched is 
numb_key NUMBER;
keyw search_tab.keyword%type;
begin 
select keyword, count (keyword) as total_key into keyw, numb_key from search_tab where rownum <=50 group by keyword order by total_key desc;
end;
