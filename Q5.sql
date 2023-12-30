-- Má výška HDP vliv na změny ve mzdách a cenách potravin? 
-- Neboli,pokud HDP vzroste výrazněji v jednom roce, 
-- projeví se to na cenách potravin či mzdách ve stejném nebo násdujícím roce výraznějším růstem?

-- pomocný view, připojení secondary tabulky samu na sebe, zisk meziročního růstu HDP v %
CREATE OR REPLACE VIEW v_Q5 AS
SELECT 
tttpssf.`year` AS previous_year, 
tttpssf1.`year`AS current_year,
tttpssf.GDP AS previous_GDP,
tttpssf1.GDP current_GDP,
concat(tttpssf.YEAR, '-', tttpssf1.YEAR) AS time_range,
round ((tttpssf1.GDP-tttpssf.GDP)/tttpssf.GDP*100,2) AS GDP_change
FROM t_tereza_trckova_project_sql_secondary_final tttpssf 
JOIN t_tereza_trckova_project_sql_secondary_final tttpssf1
ON tttpssf.year = tttpssf1.YEAR-1  
AND tttpssf.country = tttpssf1.country 
WHERE tttpssf.country = 'Czech Republic';

SELECT * FROM v_Q5;
-- spojení dat o meziročním růstu HDP s daty o meziročním růstu mezd a cen potravin, vše v % (join na view4a z minulé otázky 4)
SELECT 
vq4a.time_range,
vq5.GDP_change,
vq4a.salary_change,
vq4a.foodprice_change
FROM v_Q5 vq5
JOIN v_4Qa vq4a
ON vq4a.time_range = vq5.time_range;



