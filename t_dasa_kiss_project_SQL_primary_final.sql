CREATE OR REPLACE TABLE engeto_2022_02_03.t_dasa_kiss_project_SQL_primary_final AS
WITH payroll AS (
    SELECT 
        cpib.name AS industry_name, 
        AVG(value) AS average_payroll,
        cpu.name AS payroll_currency, 
        cpvt.name AS payroll_type,  
        cp.payroll_year  
    FROM czechia_payroll cp
    JOIN czechia_payroll_value_type cpvt 				ON cp.value_type_code = cpvt.code 
    JOIN czechia_payroll_unit cpu 					ON cp.unit_code = cpu.code 
    JOIN czechia_payroll_industry_branch cpib 				ON cp.industry_branch_code = cpib.code 
    WHERE cp.value_type_code = '5958'
    AND cp.calculation_code = '100'
    GROUP BY 
	industry_name,
	payroll_currency,
	payroll_type,
	payroll_year
), 
goods AS ( 
    SELECT  
        YEAR(date_from) AS year,  
        name AS goods, 
        price_value AS goods_value, 
        price_unit AS goods_unit, 
        ROUND(AVG(value), 2) AS average_goods_price 
    FROM czechia_price cp
    JOIN czechia_price_category cpc 					ON cp.category_code = cpc.code 
    GROUP BY  
        year,
	goods,
	goods_value,
	goods_unit		
)
SELECT 
    g.*, 
    p.industry_name, 
    p.average_payroll, 
    p.payroll_currency, 
    p.payroll_type
FROM goods g
JOIN payroll p 								ON g.year = p.payroll_year;
