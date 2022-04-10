create or replace table engeto_2022_02_03.t_dasa_kiss_project_SQL_secondary_final as (
	select c.country, c.continent,e.year,e.GDP,e.gini,e.population,e.taxes  from countries c 
	join economies e 
	on c.country =e.country 
	where year >2005
	and year <2019
	and continent ='Europe'
)

