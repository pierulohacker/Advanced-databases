--set serveroutput on size unlimited;
declare
    page_ref ref  PAGE_T;
    actual_url page_tab.url%type;
    new_links pages_nt;
    counter number;
    cursor c is
      select ref(p) from PAGE_TAB p;
BEGIN
DBMS_OUTPUT.ENABLE (buffer_size => NULL);
  dbms_output.put_line('avvio');
  counter:=0;
  open c;
  loop
    fetch c into page_ref; --prendo la pagina in cui voglio inserire i links
    exit when c%notfound;
    select deref(page_ref).url into actual_url from dual;
    --dbms_output.put_line('inserimento link per pagina -->  ' || actual_url);
    new_links :=pages_nt(); --reinizializzo la nt per ogni page
    FOR i IN 1..2 LOOP
      new_links.extend(1);
      select *  into new_links(i) from (select ref(p) from PAGE_TAB p  where p.url <>actual_url and rownum<100  order by dbms_random.random ) where rownum=1;
      --dbms_output.put_line('inserito link numero ' || i);
      END LOOP;
    update PAGE_TAB t set t.links=new_links where t.url=actual_url;
     --dbms_output.put_line('completato aggiornamento di ' || actual_url);
     end loop;
  dbms_output.put_line('completato aggiornamento links');
  end;