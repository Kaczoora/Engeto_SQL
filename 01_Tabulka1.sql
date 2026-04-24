CREATE TABLE  t_katerina_trochtova_project_sql_primary_final AS
WITH cte_ceny AS (
	SELECT
	cpc.name AS kategorie,
	ROUND(avg(value)::numeric,2) AS prumerna_cena_rok,
	cpc.price_value AS pocet_jednotek,
	cpc.price_unit AS merna_jednotka,
	date_part('year', date_from) AS rok
	FROM czechia_price cp
	JOIN czechia_price_category cpc ON cp.category_code = cpc.code
	GROUP BY rok, cpc.name, cpc.price_value, cpc.price_unit
	ORDER BY kategorie, rok
)
,
cte_mzdy AS (
	WITH cte_tabulka_mzdy AS (
	SELECT
	cp.value,
	cp.industry_branch_code ,
	cp.payroll_year 
	FROM czechia_payroll cp
	WHERE value_type_code = 5958 AND cp.calculation_code = 200
)
SELECT
cpib.name AS odvetvi,
avg(value) AS prumerna_mzda_rok,
payroll_year AS rok
FROM cte_tabulka_mzdy ctm
JOIN czechia_payroll_industry_branch cpib ON ctm.industry_branch_code = cpib.code 
GROUP BY cpib.name, rok
)
SELECT
cc.rok,
cc.kategorie,
cc.prumerna_cena_rok,
cc.pocet_jednotek,
cc.merna_jednotka,
cm.odvetvi,
cm.prumerna_mzda_rok
FROM cte_ceny cc
JOIN cte_mzdy cm ON cc.rok = cm.rok;

