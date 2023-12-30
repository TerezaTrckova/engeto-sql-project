-- Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?
CREATE OR REPLACE VIEW view_Q3 AS 
SELECT DISTINCT 
	t.YEAR AS previous_year,
	t.average_price AS previous_price,
	t1.YEAR AS current_year,
	t1.average_price AS current_price,
	t.product,
	ROUND ((t1.average_price-t.average_price)/t.average_price*100,2) AS price_change,
	concat(t.YEAR, '-', t1.YEAR) AS time_range
FROM t_tereza_trckova_project_SQL_primary_final t
JOIN t_tereza_trckova_project_SQL_primary_final t1
ON t.year = t1.year -1
AND t.product=t1.product 
GROUP BY t.YEAR, t.product
ORDER BY t.YEAR, t.product;

-- nejvyšší a nejnižší meziroční nárůst cen 
SELECT 
	concat (price_change,' %'),
	product,
	time_range
FROM view_Q3
GROUP BY time_range, product
ORDER BY price_change DESC 
LIMIT 5;

SELECT 
	concat (price_change,' %'),
	product,
	time_range
FROM view_Q3
GROUP BY time_range, product
ORDER BY price_change ASC 
LIMIT 5;
-- celkový průměr změny ceny za celé sledované období 2006-2008
SELECT 
	concat (round(avg (price_change),2), ' %') AS total_avg, 
	product
FROM view_Q3
GROUP BY product
ORDER BY total_avg;  
