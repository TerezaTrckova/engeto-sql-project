-- secondary tabulka
CREATE OR REPLACE TABLE t_tereza_trckova_project_SQL_secondary_final AS 
SELECT  
	e.`year`,
	c2.country,
	round(e.GDP,2) AS GDP
FROM countries c2 
JOIN economies e 
ON e.country = c2.country 
	WHERE c2.continent = 'Europe'
	AND e.`year` BETWEEN 2006 AND 2018
ORDER BY e.`year`, e.country;