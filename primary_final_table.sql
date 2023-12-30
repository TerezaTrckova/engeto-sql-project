-- Tvorba tabulky pro průměrné mzdy, join názvu odvětví
CREATE OR REPLACE TABLE Payroll_semifinal AS
SELECT 
	cp.industry_branch_code,
	cpib.name AS industry_name,
	cp.payroll_year,
	ROUND(AVG(cp.value),0) AS average_salary
FROM czechia_payroll cp
JOIN czechia_payroll_industry_branch cpib  
	ON cp.industry_branch_code = cpib.code
	WHERE value IS NOT NULL
	AND value_type_code = 5958
	AND unit_code = 200
	AND calculation_code = 200
GROUP BY cp.payroll_year, cpib.name
ORDER BY cp.payroll_year, cp.industry_branch_code;

 -- Tvorba tabulky cen potravin, join slovních popisků jedntolivých kódů
CREATE OR REPLACE TABLE Price_semifinal AS
SELECT
	cp.category_code AS product_code,
	cpc.name AS product,
	YEAR(cp.date_from) AS year,
	ROUND(AVG(cp.value),2) AS average_price,
	cpc.price_value AS amount,
	cpc.price_unit AS unit
FROM czechia_price cp
JOIN czechia_price_category cpc 
	ON cp.category_code = cpc.code
WHERE cp.value IS NOT NULL 
GROUP BY YEAR(cp.date_from), cpc.name 
ORDER BY cpc.name, YEAR(cp.date_from);

-- Spojení dvou pomocných tabulek do finální tabulky mezd a cen potravin za ČR sjednocených na totožné porovnatelné období 
CREATE OR REPLACE TABLE t_tereza_trckova_project_SQL_primary_final AS 
SELECT 
* FROM Payroll_semifinal pas
JOIN Price_semifinal prs
ON pas.payroll_year=prs.YEAR;

-- porovnatelné období 2006-2018 
SELECT * FROM t_tereza_trckova_project_SQL_primary_final
ORDER BY year DESC;



   