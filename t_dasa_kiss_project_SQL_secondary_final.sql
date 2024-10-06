CREATE OR REPLACE TABLE engeto_2022_02_03.t_dasa_kiss_project_SQL_secondary_final AS (
    SELECT 
        c.country, 
        c.continent, 
        e.year, 
        e.GDP, 
        e.gini, 
        e.population, 
        e.taxes  
    FROM countries c 
    JOIN economies e ON c.country = e.country 
    WHERE year > 2005
    AND year < 2019
    AND continent = 'Europe'
)
