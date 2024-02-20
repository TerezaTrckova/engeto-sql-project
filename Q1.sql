-- Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?

-- pomocný view, join primary tabulky sama na sebe k porovnání meziročního růstu mezd
CREATE OR REPLACE VIEW mezirocni_zmena_mezd AS 
SELECT DISTINCT 
	t.year AS previous_year,
	t.average_salary AS previous_salary,
	t1.year AS current_year,
	t1.average_salary AS current_salary,
	t.industry_name, 
	ROUND ((t1.average_salary-t.average_salary)/t.average_salary*100,2) AS change_
FROM t_tereza_trckova_project_SQL_primary_final t
JOIN t_tereza_trckova_project_SQL_primary_final t1
ON t.year = t1.year -1
AND t.industry_name=t1.industry_name
GROUP BY t.year, t.industry_name
ORDER BY t.industry_name;

SELECT * FROM mezirocni_zmena_mezd;
-- procentuální růst mezd všech odvětví za celé období 2006-2018
SELECT  
	CONCAT (ROUND(AVG(change_),2), ' %') AS total_growth,
	industry_name
FROM mezirocni_zmena_mezd
GROUP BY industry_name
ORDER BY total_growth DESC;

-- Odvětví, u kterých se objevil alespoň v jednom roce meziroční pokles mezd 
CREATE OR REPLACE VIEW mezirocni_pokles_mezd AS 
SELECT DISTINCT 
	t.year AS previous_year,
	t.average_salary AS previous_salary,
	t1.year AS current_year,
	t1.average_salary AS current_salary,
	t.industry_name, 
	ROUND ((t1.average_salary-t.average_salary)/t.average_salary*100,2) AS decline,
	CONCAT (t.year, '-', t1.year) AS time_range
FROM t_tereza_trckova_project_SQL_primary_final t
JOIN t_tereza_trckova_project_SQL_primary_final t1
ON t.year = t1.year -1
AND t.industry_name=t1.industry_name
WHERE t1.average_salary < t.average_salary
GROUP BY t.year, t.industry_name
ORDER BY t.industry_name;

-- Po zaokrouhlení jedna z hodnot proměnné decline vychází 0 ('Doprava a skladování'), nutno ji odfiltrovat 
-- kdy a jak velký se objevil meziroční pokles mezd u daných odvětví (v %)
SELECT * FROM mezirocni_pokles_mezd;

SELECT 
	time_range,		
	CONCAT (decline,' %') AS decline,
	industry_name
FROM mezirocni_pokles_mezd
having decline < 0
ORDER BY decline DESC;
 
-- Odvětví, u kterých se objevil alespoň v jednom roce meziroční růst mezd 
CREATE OR REPLACE VIEW mezirocni_rust_mezd AS 
SELECT DISTINCT 
	t.year AS previous_year,
	t.average_salary AS previous_salary,
	t1.year AS current_year,
	t1.average_salary AS current_salary,
	t.industry_name, 
	ROUND ((t1.average_salary-t.average_salary)/t.average_salary*100,2) AS growth,
	CONCAT (t.year, '-', t1.year) AS time_range
FROM t_tereza_trckova_project_SQL_primary_final t
JOIN t_tereza_trckova_project_SQL_primary_final t1
ON t.year = t1.year -1
AND t.industry_name=t1.industry_name
WHERE t1.average_salary > t.average_salary
GROUP BY t.year, t.industry_name
ORDER BY growth DESC;

-- 5 nejvyšších meziročních růstů mzdy napříč odvětvími 
SELECT * FROM mezirocni_rust_mezd;

SELECT 
	time_range,		
	CONCAT (growth,'%') AS growth,
	industry_name
FROM mezirocni_rust_mezd
LIMIT 5; 

