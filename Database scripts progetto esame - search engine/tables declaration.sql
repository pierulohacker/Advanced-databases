--alter table user_tab drop column pages_read;
drop table user_tab force;
drop table search_tab force;
--alter table term_tab drop column inverted_index;
drop table term_tab force;
drop TABLE pages_temp_table force;
drop table page_tab force;



create table page_tab of page_t
(url PRIMARY KEY,
title NOT NULL,
is_indexed default 0) nested table links store as pages_nt_table;
/
create table user_tab of user_t
(user_id PRIMARY KEY,
searches_n DEFAULT 0) nested table pages_read store as user_history_nt;
/
create table search_tab of search_t
(search_id PRIMARY KEY,
code_session NOT NULL,
search_time NOT NULL,
keyword NOT NULL,
user_associated NOT NULL);
/
create table term_tab of term_t
(term_name PRIMARY KEY) nested table inverted_index store as inverted_index_nt_table;
/