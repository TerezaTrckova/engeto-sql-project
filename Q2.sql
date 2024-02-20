-- Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?

-- analýza souhrnně za ČR, kolik si lze za průměrnou hrubou mzdu (průměr za všechna odvětví v ČR) lze koupit mléka a chleba
SELECT 
  	year, 
  	product,
 	average_price,
 	ROUND (AVG(average_salary),0) AS average_salary_CR,
  	ROUND (AVG(average_salary)/average_price,2) AS purchasing_power
FROM t_tereza_trckova_project_sql_primary_final tttpspf 
WHERE year IN (2006, 2018)
AND product IN ('Mléko polotučné pasterované', 'Chléb konzumní kmínový') 
GROUP BY `year`, product
ORDER BY `year`, purchasing_power DESC

-- analýza dle jednotlivých odvětví, v jakém odvětví si mohou za svou hrubou mzdu koupit nejvíce mléka a chleba
SELECT 
	year, 
	industry_name, 
	product,
	average_salary ,
	ROUND (average_salary/average_price,2) AS purchasing_power
FROM t_tereza_trckova_project_sql_primary_final tttpspf 
WHERE year IN (2006, 2018)
AND product = 'Mléko polotučné pasterované'
ORDER BY year, purchasing_power DESC

SELECT 
	year, 
	industry_name, 
	product,
	average_salary ,
	ROUND (average_salary/average_price,2) AS purchasing_power
FROM t_tereza_trckova_project_sql_primary_final tttpspf 
WHERE year IN (2006, 2018)
AND product = 'Chléb konzumní kmínový'
ORDER BY year, purchasing_power DESC
