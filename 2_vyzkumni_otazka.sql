/* V privním období je možné koupít z prumerneho platu 1262 kg chlébu a 1409 litrov mléka
 * V posledním oddobí je možné koupít z prumerneho platu 1319 kg chlébu a 1614 litrov mléka */

WITH goods AS (
    SELECT DISTINCT 
        year, 
        goods,
        average_goods_price AS goods_price,
        goods_value,
        goods_unit 
    FROM t_dasa_kiss_project_sql_primary_final
    WHERE goods IN ('Mléko polotuèné pasterované', 'Chléb konzumní kmínový')
	AND year IN (
            (SELECT DISTINCT MAX(year) FROM t_dasa_kiss_project_sql_primary_final),
            (SELECT DISTINCT MIN(year) FROM t_dasa_kiss_project_sql_primary_final)
        )
), 
industries AS (
    SELECT DISTINCT 
        year, 
        AVG(average_payroll) OVER (PARTITION BY year) AS payroll
    FROM t_dasa_kiss_project_sql_primary_final
    WHERE year IN (
            (SELECT DISTINCT MAX(year) FROM t_dasa_kiss_project_sql_primary_final),
            (SELECT DISTINCT MIN(year) FROM t_dasa_kiss_project_sql_primary_final)
        )
)
SELECT 
    g.year,
    g.goods,
    ROUND((payroll / goods_price), 0) AS amount_of_goods,
    g.goods_unit  
FROM  industries i 
JOIN goods g 						ON i.year = g.year;
