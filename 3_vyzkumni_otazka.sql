/* Najpomaleji zdražujou Banány žluté, mají nejnižší percentualni meziroèní narùst, Cukr a jablka maji meziroèní pokles */
with 2018y as (
	select distinct goods,year,average_goods_price  from t_dasa_kiss_project_sql_primary_final 
	where year in ('2018')
), 2006y as (
	select distinct goods,year,average_goods_price  from t_dasa_kiss_project_sql_primary_final
	where year in ('2006')	
) 
select 2018y.*, 2006y.year, 2006y.average_goods_price, ROUND((POWER((2018y.average_goods_price /2006y.average_goods_price),(1/13))-1)*100,2) as percentage_increase  from 2018y
join 2006y
on 2018y.goods=2006y.goods
order by percentage_increase 

