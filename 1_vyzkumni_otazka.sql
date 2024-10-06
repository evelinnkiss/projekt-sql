/* Mzdy v prubehu let rostou, maximalni mzda ve všech odvetvich je v poslednom zaznamenanom roku a tým je 2018*/



select distinct 
	industry_name, 
	average_payroll as max_payroll,
	year 
from t_dasa_kiss_project_SQL_primary_final
where average_payroll in ( 
	select distinct 
		MAX(average_payroll) over (partition by industry_name) as max_payroll
	from t_dasa_kiss_project_SQL_primary_final
	)
