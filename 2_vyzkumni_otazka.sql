/* V privn�m obdob� je mo�n� koup�t z prumerneho platu 1262 kg chl�bu a 1409 litrov ml�ka
 *V posledn�m oddob� je mo�n� koup�t z prumerneho platu 1319 kg chl�bu a 1614 litrov ml�ka */

with  goods as (

	select distinct year, goods,average_goods_price as goods_price,goods_value, goods_unit  from t_dasa_kiss_project_sql_primary_final
	where goods  in ('Ml�ko polotu�n� pasterovan�','Chl�b konzumn� km�nov�')
	and year in ((select distinct MAX(year) from t_dasa_kiss_project_sql_primary_final),
	(select distinct MIN(year) from t_dasa_kiss_project_sql_primary_final))

), industries as(

	select distinct year, AVG(average_payroll) over (partition by year)  as payroll  from t_dasa_kiss_project_sql_primary_final
	where year in ((select distinct MAX(year) from t_dasa_kiss_project_sql_primary_final),
	(select distinct MIN(year) from t_dasa_kiss_project_sql_primary_final))

)select g.year,g.goods,ROUND((payroll/goods_price),0) as amount_of_goods,g.goods_unit  from industries i 
join goods g 
on i.year=g.year