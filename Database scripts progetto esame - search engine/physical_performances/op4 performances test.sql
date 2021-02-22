set timing on;
--ricerche più comuni
select * from (select keyword, count (keyword) as total_key from search_tab group by keyword order by total_key desc) where rownum <= 50;
--create index keyword_search on search_tab(keyword);
--drop index keyword_search;