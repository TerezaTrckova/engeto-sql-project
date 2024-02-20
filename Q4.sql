-- Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?

-- výpočet průměrné mzdy a potravinového koše (souhrn cen potravin) za jednotlivé roky
CREATE OR REPLACE VIEW rocni_prumery AS 
SELECT 
  	year,
  	ROUND (AVG(average_salary),0) AS avg_salary_CR,
  	ROUND (AVG(average_price),2) AS food_price
FROM t_tereza_trckova_project_sql_primary_final tttpspf 
GROUP BY year
ORDER BY year; 

-- pomocný view, připojený view z minulého kroku sama na sebe, výpočet procentuální meziroční změny 
CREATE OR REPLACE VIEW mezirocni_zmena AS 
SELECT 
	rp.YEAR AS previous_year,
 	rp.avg_salary_CR AS previous_salary,
	rp.food_price AS previuous_food_price,
	rp1.year AS current_year,
	rp1.avg_salary_CR AS current_salary,
	rp1.food_price AS current_food_price,
CONCAT (rp.year, '-', rp1.year) AS time_range,
ROUND ((rp1.avg_salary_CR-rp.avg_salary_CR)/rp.avg_salary_CR*100,2) AS 'salary_change',
ROUND ((rp1.food_price-rp.food_price)/rp.food_price*100,2) AS 'foodprice_change'
FROM rocni_prumery rp
JOIN rocni_prumery rp1
ON rp.year=rp1.year-1;

-- uspořádání dat, konečný výsledek 
SELECT 
	time_range, 
	CONCAT (salary_change,' %') AS salary_change,
	CONCAT (foodprice_change,' %') AS foodprice_change,
	salary_change-foodprice_change AS salary_food_difference
FROM mezirocni_zmena;
