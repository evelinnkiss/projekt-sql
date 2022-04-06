create or replace table engeto_2022_02_03.t_dasa_kiss_project_SQL_primary_final as
    with payroll as (
		select cpib.name as industry_name, AVG(value) as average_payroll,cpu.name  as payroll_currency, cpvt.name as payroll_type  ,cp.payroll_year  from czechia_payroll cp
		join czechia_payroll_value_type cpvt 
		on cp.value_type_code=cpvt.code 
		join czechia_payroll_unit cpu 
		on cp.unit_code=cpu.code 
		join czechia_payroll_industry_branch cpib 
		on cp.industry_branch_code=cpib.code 
		where cp.value_type_code ='5958'
		and cp.calculation_code='100'
		group BY industry_name, payroll_currency, payroll_type,  payroll_year
       ),
       goods AS ( 
        select  YEAR(date_from) as year,  name as goods, price_value as goods_value, price_unit as goods_unit, ROUND(AVG(value),2) as average_goods_price 
		from czechia_price cp
		join czechia_price_category cpc
		on cp.category_code = cpc.code 
		group by  year, goods, goods_value, goods_unit		
)
select g.*, p.industry_name, p.average_payroll, p.payroll_currency, p.payroll_type
from goods g
join payroll p
on g.year = p.payroll_year 

