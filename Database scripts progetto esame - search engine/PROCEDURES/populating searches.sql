
--ogni utene ha 10 search -caso singolo di prova
declare
    term_name term_tab.term_name%type;
    term_ref ref term_t;
    user_ref ref USER_T;
    counter number; --per creare 10 ricerche per ogni utente
    CURSOR cur_user is
       select ref(u) from USER_TAB u;
begin
  open cur_user;
  loop --ciclo per ogni utente
    fetch cur_user into user_ref;
    exit when cur_user%notfound;
    counter:=0;
    for counter in 1..10 loop
        select * into term_name, term_ref from (select t.term_name, ref(t) from TERM_TAB t where ROWNUM<100 order by DBMS_RANDOM.RANDOM())where rownum=1;
        insert into SEARCH_TAB(KEYWORD, USER_ASSOCIATED, TERM) values (term_name, user_ref, term_ref);
    end loop;
end loop ;
end;