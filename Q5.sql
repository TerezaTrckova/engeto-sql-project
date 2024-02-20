-- Má výška HDP vliv na změny ve mzdách a cenách potravin? 
-- Neboli, pokud HDP vzroste výrazněji v jednom roce, 
-- projeví se to na cenách potravin či mzdách ve stejném nebo následujícím roce výraznějším růstem?

-- pomocný view, připojení secondary tabulky samu na sebe, zisk meziročního růstu HDP v %
CREATE OR REPLACE VIEW rust_HDP AS
SELECT 
	tttpssf.year AS previous_year, 
	tttpssf1.year AS current_year,
	tttpssf.GDP AS previous_GDP,
	tttpssf1.GDP current_GDP,
	CONCAT (tttpssf.year, '-', tttpssf1.year) AS time_range,
	ROUND ((tttpssf1.GDP-tttpssf.GDP)/tttpssf.GDP*100,2) AS GDP_change
FROM t_tereza_trckova_project_sql_secondary_final tttpssf 
JOIN t_tereza_trckova_project_sql_secondary_final tttpssf1
ON tttpssf.year = tttpssf1.year-1  
AND tttpssf.country = tttpssf1.country 
WHERE tttpssf.country = 'Czech Republic';

SELECT * FROM rust_HDP;
-- spojení dat o meziročním růstu HDP s daty o meziročním růstu mezd a cen potravin, vše v % (join na view mezirocni_zmena z minulé otázky 4)
SELECT 
	mz.time_range,
	CONCAT (HDP.GDP_change, ' %') AS GDP_change,
	CONCAT (mz.salary_change, ' %') AS salary_change,
	CONCAT (mz.foodprice_change, ' %') AS foodprice_change
FROM rust_HDP HDP
JOIN mezirocni_zmena mz
ON mz.time_range = HDP.time_range;



