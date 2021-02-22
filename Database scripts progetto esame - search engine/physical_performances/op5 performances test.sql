set timing on;
select * from(select user_id, searches_n as total_search from user_tab  order by total_search desc ) where rownum <=50;
--create index  searches_of_user_index on user_tab(searches_n desc);
--drop index searches_of_user_index;