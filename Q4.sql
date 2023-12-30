-- Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?

-- výpočet průměrné mzdy a potravinového koše (souhrn cen potravin) za jednotlivé roky
CREATE OR REPLACE VIEW v_4Q AS 
SELECT 
`year`,
round (avg(average_salary),0) AS avg_salary_CR,
round (avg(average_price),2) AS food_price
FROM t_tereza_trckova_project_sql_primary_final tttpspf 
GROUP BY `year`
ORDER BY `year`; 

-- pomocný view, připojený view z minulého kroku sama na sebe, výpočet procentuální meziroční změny 
CREATE OR REPLACE VIEW v_4Qa AS 
SELECT 
v4.YEAR AS previous_year,
v4.avg_salary_CR AS previous_salary,
v4.food_price AS previuous_food_price,
v41.YEAR AS current_year,
v41.avg_salary_CR AS current_salary,
v41.food_price AS current_food_price,
concat(v4.YEAR, '-', v41.YEAR) AS time_range,
round ((v41.avg_salary_CR-v4.avg_salary_CR)/v4.avg_salary_CR*100,2) AS 'salary_change',
round((v41.food_price-v4.food_price)/v4.food_price*100,2) AS 'foodprice_change'
FROM v_4Q v4
JOIN v_4Q v41
ON v4.YEAR=v41.YEAR-1;

-- uspořádání dat, konečný výsledek 
SELECT 
time_range, concat ( salary_change,' %'),
concat ( foodprice_change,' %')
FROM v_4Qa;