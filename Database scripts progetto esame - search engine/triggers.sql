drop trigger new_user_insertion;
drop trigger search_tab_null_values;
drop trigger pages_term_indexing;
drop trigger pages_to_temp;
drop trigger increment_searches;
--drop sequence search_id_seq;
--drop sequence user_id_seq;
--drop sequence codesession_seq;

create sequence codesession_seq start with 1; -- per il codice sessione
/
create sequence search_id_seq start with 1; -- per l'identificativo della ricerca
/
--autoincrement for the code session
create trigger search_tab_null_values
before insert on search_tab
for each row
begin
--inserimento di un nuovo search_id
  select search_id_seq.NEXTVAL
  into   :new.search_id
  from   dual;
--nuova code session se non si tratta di una session pre esistente e quindi inserita dall'utente
if :new.code_session is NULL then
  select codesession_seq.nextval
  into   :new.code_session
  from   dual;
  end if;
--gestione della data
if :new.search_time is NULL THEN
  select sysdate
  into :new.search_time
  from dual;
  end if;
end;
/
create trigger increment_searches
after insert on search_tab
for each row
declare
PRAGMA autonomous_transaction;
begin 
--incremento della 
update user_tab u set u.searches_n=u.searches_n+1 where u.user_id=deref(:new.user_associated).user_id;
commit;
end;
/
create sequence user_id_seq start with 1;
/
--autoincrement for the user id
create or replace
trigger new_user_insertion
before insert on user_tab
for each row
begin
  select user_id_seq.NEXTVAL
  into   :new.user_id
  from   dual;
if :new.searches_n is null then 
  :new.searches_n:=0; --per rispettare il default value, fondamentale
end if;
:new.pages_read:=history_nt_type();
end;
/

--funzione ausiliaria per la gestione dei nuovi documenti e dei termini in essi contenuti
create or replace function searchword(text in VARCHAR2) return words_in_page_type as
numb_words NUMBER;
word VARCHAR2(30);
words_counter NUMBER;
words_in_page_table words_in_page_type;
table_length NUMBER; --utile a ospitare le dimensioni crescenti della table che ospita termine-occorrenze; evitiamo di usare la count sulla table per risparmiare calcolo, incrementiamo invece a ogni inserimento
table_counter NUMBER; 
found number; --flag PER IL RITROVAMENTO DEI DUPLICATI
BEGIN
words_in_page_table := words_in_page_type();
--conteggio del numero di parole nella frase
Select  length(text) - length(replace(text, ' ', '')) + 1 into numb_words  from dual ;
table_length :=0;
for words_counter in 1..numb_words loop
  SELECT  REGEXP_SUBSTR (text, '(\S*)(\s)|(\S*)$', 1, words_counter)into word FROM dual ; --il trattino verticale è un or per prednere una stringa non seguita da spazio qualora siano finite quelle seguite da spazio ref: https://www.techonthenet.com/oracle/functions/regexp_substr.php
  word := replace(word, ' ', ''); --rimozione degli spazi
  word:= lower(word);
  dbms_output.put_line('parola ' || words_counter|| ': ' || word);
  --dobbiamo controllare ogni volta se la parola si stia ripetendo
  found:=0;
  if table_length > 1 then -- non possiamo fare il ciclo con la lunghezza 0
    for table_counter in  1..table_length LOOP
      if words_in_page_table(table_counter).term= word THEN 
        words_in_page_table(table_counter).increment_occurrences;
        found:=1;
        exit; -- esco perchè l'ho trovato
      end if;
    end loop;
  end if;
  if found=0 then
    words_in_page_table.extend(1); --bisogna estendere la tabella
    table_length:= table_length+1;
    words_in_page_table(table_length) := word_found(word,1);
  end if; 
end loop;
return words_in_page_table;
end;
/
create or replace
trigger pages_terms_indexing 
after insert on page_tab
declare
page_ref ref page_t;
words_in_doc words_in_page_type;
tab_len NUMBER;
counter number;
word_exist number; --flag per vedere se esiste la parola
word varchar2(30);
occurrences number;
urls_counter number;
--variabili per operazioni temporanee nei cicli
current_title page_tab.title%type;
current_url page_tab.url%type;
cursor u is select url from page_tab where is_indexed=0; --prendo le pages non indicizzate
begin

urls_counter:=0;
open u;
loop
fetch u into current_url;
exit when u%notfound;
	select ref(T), T.title into page_ref, current_title from page_tab T where T.url=current_url;
	words_in_doc:=searchword(current_title); --assumendo che il testo è solo il title
	tab_len:= words_in_doc.count; --prendo la lunghezza della table per iterare
	for counter in 1..tab_len loop
	  word:= words_in_doc(counter).term;
	  occurrences:= words_in_doc(counter).occurrences;
    dbms_output.put_line(to_char(word) || '  ' || to_char(occurrences));
    
	  --proviamo a inserire la nuova occorrenza per la parola se è già e esistente, ma grazie a rowcount saprò se è andata a buon fine
    select count(term_name) into word_exist from term_tab where term_name=word;
    if word_exist=0 then --se non era già presente nel db
      insert into term_tab values(word, inverted_index_nt(inverted_index_t(page_ref,occurrences)));
	  else
	  insert into TABLE(select t.inverted_index from term_tab t where t.term_name=word) 
		values (inverted_index_t(page_ref, occurrences));
	  end if;
	  update page_tab T set T.is_indexed=1 where T.url=current_url; 

	end loop;
end loop;
END;
