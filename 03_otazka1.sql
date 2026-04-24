-- 1 otazka

WITH cte_pokles_rust AS (SELECT
    odvetvi,
    rok,
    prumerna_mzda_rok,
    LAG(prumerna_mzda_rok) OVER (PARTITION BY odvetvi ORDER BY rok) AS predchozi_mzda,
    prumerna_mzda_rok 
        - LAG(prumerna_mzda_rok) OVER (PARTITION BY odvetvi ORDER BY rok) AS rozdil,
    CASE 
        WHEN prumerna_mzda_rok > LAG(prumerna_mzda_rok) OVER (PARTITION BY odvetvi ORDER BY rok) THEN 'roste'
        WHEN prumerna_mzda_rok < LAG(prumerna_mzda_rok) OVER (PARTITION BY odvetvi ORDER BY rok) THEN 'klesa'
        ELSE 'beze změny'
    END AS trend
FROM t_katerina_trochtova_project_sql_primary_final tktpspf 
ORDER BY odvetvi, rok
)
SELECT *
FROM cte_pokles_rust
WHERE trend = 'klesa'
ORDER BY rozdil ASC;
