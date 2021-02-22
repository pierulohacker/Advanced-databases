--OP.2 - aggiunta pagina al database
create or replace procedure new_page(new_url in page_tab.url%type, new_title page_tab.title%type) as 
begin
insert into page_tab(url, title) values (new_url, new_title); --lancerà il trigger che indicizza i termini
end;
