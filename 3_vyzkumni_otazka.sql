/* Najpomaleji zdražujou Banány žluté, mají nejnižší percentualni meziroční narůst, Cukr a jablka maji meziroční pokles */

WITH maxYear AS (
    SELECT DISTINCT  
        goods, 
        year, 
        average_goods_price AS goods_price 
    FROM t_dasa_kiss_project_sql_primary_final
    WHERE year = (
            SELECT MAX(year) 
            FROM t_dasa_kiss_project_sql_primary_final
        )
), 
minYear AS (
    SELECT DISTINCT  
        goods, 
        year, 
        average_goods_price AS goods_price 
    FROM t_dasa_kiss_project_sql_primary_final
    WHERE year = (
            SELECT MIN(year) 
            FROM t_dasa_kiss_project_sql_primary_final
        )	
) 
SELECT 
    maxYear.*, 
    minYear.year AS min_year, 
    minYear.goods_price AS min_goods_price, 
    ROUND((POWER((maxYear.goods_price / minYear.goods_price), (1/13)) - 1) * 100, 2) AS percentage_increase  
FROM maxYear
JOIN minYear ON maxYear.goods = minYear.goods
ORDER BY percentage_increase;
