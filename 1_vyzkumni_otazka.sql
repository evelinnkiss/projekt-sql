/* Mzdy v prubehu let rostou, maximalni mzda ve všech odvetvich je v poslednom zaznamenanom roku a tým je 2018*/



SELECT DISTINCT 
    industry_name, 
    average_payroll AS max_payroll,
    year 
FROM t_dasa_kiss_project_SQL_primary_final
WHERE 
    average_payroll IN ( 
        SELECT DISTINCT 
            MAX(average_payroll) OVER (PARTITION BY industry_name) AS max_payroll
        FROM t_dasa_kiss_project_SQL_primary_final
	)
