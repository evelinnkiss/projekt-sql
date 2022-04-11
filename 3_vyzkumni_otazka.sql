/* Najpomaleji zdražujou Banány žluté, mají nejnižší percentualni meziroční narůst, Cukr a jablka maji meziroční pokles */
with maxYear as (
	select distinct  goods, year, average_goods_price as goods_price from t_dasa_kiss_project_sql_primary_final
	where year= (select max(year) from t_dasa_kiss_project_sql_primary_final)
), minYear as (
	select distinct  goods, year, average_goods_price as goods_price from t_dasa_kiss_project_sql_primary_final
	where year= (select min(year) from t_dasa_kiss_project_sql_primary_final)	
) 
select maxYear.*, minYear.year, minYear.goods_price, ROUND((POWER((maxYear.goods_price /minYear.goods_price),(1/13))-1)*100,2) as percentage_increase  from maxYear
join minYear
on maxYear.goods=minYear.goods
order by percentage_increase 
