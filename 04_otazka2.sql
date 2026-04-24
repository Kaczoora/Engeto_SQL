--2 otazka

WITH cte_roky AS (
    SELECT
        MIN(rok) AS prvni_rok,
        MAX(rok) AS posledni_rok
    FROM t_katerina_trochtova_project_sql_primary_final tktpspf 
),
cte_mzdy AS (
    SELECT
        rok,
        ROUND(AVG(prumerna_mzda_rok)::NUMERIC,2) AS prumerna_mzda
    FROM t_katerina_trochtova_project_sql_primary_final tktpspf 
    GROUP BY rok
),
cte_ceny AS (
    SELECT
        rok,
        kategorie,
        prumerna_cena_rok,
        merna_jednotka
    FROM t_katerina_trochtova_project_sql_primary_final tktpspf 
    WHERE kategorie IN ('Mléko polotučné pasterované', 'Chléb konzumní kmínový')
)
SELECT distinct
    c.rok,
    c.kategorie,
    m.prumerna_mzda,
    c.prumerna_cena_rok,
    c.merna_jednotka,
   ROUND((m.prumerna_mzda / c.prumerna_cena_rok)::NUMERIC,0) AS kolik_lze_koupit
FROM cte_ceny c
JOIN cte_mzdy m ON c.rok = m.rok
JOIN cte_roky r 
    ON c.rok = r.prvni_rok 
    OR c.rok = r.posledni_rok
ORDER BY c.kategorie, c.rok;

