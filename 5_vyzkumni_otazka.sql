
/* Výška HDP má vliv na zmeny cen ve mzdach a cen potravin.
 * Pokud HPD vzroste vyrazneji v jednom roce, projevi se to  ve stejnem roce minimalne na mzdach a nekdy i na cenach potravin. */



with goods_increase as (

	select distinct year, AVG(( goods_price  - previous_price ) * 100 /previous_price) over (partition by year) good_increase  from (
			select distinct goods,year,goods_price, lag(goods_price,1) over (partition by goods
			order by year)  previous_price from goods	 
	) g
	where previous_price is not null

), industries_increase as (

	select distinct year, AVG(( payroll  - previous_payroll ) * 100 /previous_payroll) over (partition by year) as industry_increase  from (
		select distinct industry_name ,year,payroll , lag(payroll ,1) over (partition by industry_name 
				order by year)  previous_payroll from industries
	)i 
	where previous_payroll is not null
	
), gdp_increase as (
	
	select  country, year, ROUND(( gdp  - previous_gdp ) * 100 /previous_gdp,2) as gdp_increase  from (
			select country,year, gdp, lag(gdp,1) over ( order by year) previous_gdp from t_dasa_kiss_project_sql_secondary_final 
			where country like 'cz%'				
	) gdp
	where previous_gdp is not null	
	
), overview as (
	select g.year, ROUND(g.good_increase,2) as good_increase , ROUND(i.industry_increase,2) as industry_increase, gdp.gdp_increase  from goods_increase g
	join industries_increase i
	on g.year=i.year
	join gdp_increase gdp
	on g.year=gdp.year
	
), differences as (

	select year, good_increase - lag(good_increase,1) over ( order by year) as difference_goods,
	industry_increase  - lag(industry_increase,1) over ( order by year) as diffrence_industry,
	gdp_increase - lag(gdp_increase,1) over ( order by year) as difference_gdp
	from overview 

)select *, 
case 
	when difference_goods <0 and diffrence_industry <0 and diffrence_industry <0 then 'has effect'
	when difference_goods >0 and diffrence_industry >0 and diffrence_industry >0 then 'has effect'
	when difference_goods <0 and diffrence_industry >0 and diffrence_industry <0 then 'has effect on goods'
	when difference_goods >0 and diffrence_industry <0 and diffrence_industry <0 then 'has effect on industries'
	when difference_goods >0 and diffrence_industry <0 and diffrence_industry >0 then 'has effect on goods'
	when difference_goods <0 and diffrence_industry >0 and diffrence_industry >0 then 'has effect on industries'
	else 'doesn´t have effect'
end as gdp_effect
from differences
