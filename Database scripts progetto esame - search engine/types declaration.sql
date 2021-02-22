drop type pages_nt force;
drop type page_t force;
drop type user_t force;
drop type history_nt_type force;
drop type registered_t force;
drop type unknown_t force;
drop type term_t force;
drop type search_t force;
drop type inverted_index_t force;
drop type inverted_index_nt force;
drop type word_found force;

/
create or replace type page_t as object
(url VARCHAR2(2100),
title VARCHAR2(150),
links pages_nt,
is_indexed number);
/
create or replace type pages_nt as TABLE of ref page_t;
/
create or replace type history_nt_type as TABLE of ref page_t;
/

create or replace type user_t as object
(user_id NUMBER,
searches_n NUMBER,
pages_read history_nt_type) NOT FINAL NOT INSTANTIABLE;

/
create or replace
type registered_t UNDER user_t
(Email VARCHAR2(50),
psw VARCHAR2(50),
name_user VARCHAR2(30),
Surname VARCHAR2(30),
constructor function registered_t(self in out NOCOPY registered_t, email VARCHAR2, psw VARCHAR2, name_user VARCHAR2, surname VARCHAR2)
return self as result);

/
--imlplementazione costruttore per evitare duplicati, poichè col trigger è impossibile
create or replace
TYPE BODY registered_t AS
    CONSTRUCTOR FUNCTION registered_t(self in out NOCOPY registered_t, email VARCHAR2, psw VARCHAR2, name_user VARCHAR2, surname VARCHAR2)
    return self as result is
    conflicts number;
    begin
      select count(*) into conflicts from user_tab u where value(u) is of (registered_t) and  treat(value(u) as registered_t).email=email;
      if conflicts>0 then
        raise_application_error('-20010', 'Email already exists');
      else
        self.user_id:=null;
        self.searches_n:=0;
        self.pages_read:=null;
        self.email:=email;
        self.psw:=psw;
        self.name_user:=name_user;
        self.surname:=surname;
      end if;
      return;
    end;
end;

/    

create or replace type unknown_t UNDER user_t(
constructor function unknown_t(self in out NOCOPY unknown_t)
return self as result);
/
create or replace
TYPE BODY unknown_t AS
    CONSTRUCTOR FUNCTION unknown_t(self in out NOCOPY unknown_t)
    return self as result is
    begin     
        self.user_id:=null;
        self.searches_n:=0;
        self.pages_read:=null;
      return;
    end;
end;

/    
create or replace type inverted_index_t as object
(page ref page_t,
occurrences number);
/
create or replace type inverted_index_nt is table of inverted_index_t;

/
create or replace type term_t as object
(term_name varchar(20),
inverted_index inverted_index_nt);

/
create or replace type search_t as object
(search_id NUMBER,
code_session NUMBER,
search_time TIMESTAMP,
keyword VARCHAR2(20),
user_associated ref user_t,
term ref term_t);
/
--funzionale alla procedura "searchword" per istanziare una table
create or replace TYPE word_found as object 
(term varchar2(30),
occurrences number,
MEMBER procedure increment_occurrences); --per creare la  table
/
--implementazione metodo di word_found
create or replace type body word_found as 
member procedure increment_occurrences is
begin
occurrences:=occurrences+1;
end;
end;
/
create or replace TYPE words_in_page_type is table of word_found;
