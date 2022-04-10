/* Neexistuje rok, ve kterém byl meziroèní nárùst cen potravin výraznì vyšší než rùst mezd (vìtší než 10 %) */
create view goods as (

	select distinct goods,year,average_goods_price as goods_price from t_dasa_kiss_project_sql_primary_final


)


create view industries as (

	select distinct industry_name ,year,average_payroll  as payroll from t_dasa_kiss_project_sql_primary_final


)


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
	
	) i
	where previous_payroll is not null

)select g.year, round (good_increase - industry_increase,2) as difference from goods_increase g
join industries_increase i
on g.year=i.year 
order by difference desc



	
