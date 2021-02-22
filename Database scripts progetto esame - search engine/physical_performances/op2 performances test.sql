set timing on;
--delete from page_tab where url='www.prova.it';
insert into page_tab(url, title) values ('www.prova.it', 'pagina_di prova'); --lancerà il trigger che indicizza i termini
