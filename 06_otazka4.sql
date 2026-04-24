--4 OTAZKA

WITH cte_ceny AS (
    SELECT
        rok,
        AVG(prumerna_cena_rok) AS cena
    FROM t_katerina_trochtova_project_sql_primary_final tktpspf 
    GROUP BY rok
),
cte_mzdy AS (
    SELECT
        rok,
        AVG(prumerna_mzda_rok) AS mzda
    FROM t_katerina_trochtova_project_sql_primary_final tktpspf 
    GROUP BY rok
),
cte_vyvoj AS (
    SELECT
        c.rok,
        c.cena,
        m.mzda,
        LAG(c.cena) OVER (ORDER BY c.rok) AS cena_prev,
        LAG(m.mzda) OVER (ORDER BY c.rok) AS mzda_prev
    FROM cte_ceny c
    JOIN cte_mzdy m ON c.rok = m.rok
),
cte_rust AS (
    SELECT
        rok,
        (cena - cena_prev) / cena_prev * 100 AS rust_cen,
        (mzda - mzda_prev) / mzda_prev * 100 AS rust_mezd,
        ((cena - cena_prev) / cena_prev * 100)
        - ((mzda - mzda_prev) / mzda_prev * 100) AS rozdil
    FROM cte_vyvoj
    WHERE cena_prev IS NOT NULL
)
SELECT *
FROM cte_rust
WHERE rozdil > 10
ORDER BY rok;

