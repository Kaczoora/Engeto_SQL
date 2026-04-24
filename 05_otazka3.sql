--3 otazka

WITH cte_vyvoj AS (
    SELECT
        kategorie,
        rok,
        prumerna_cena_rok,
        LAG(prumerna_cena_rok) OVER (
            PARTITION BY kategorie 
            ORDER BY rok
        ) AS predchozi_cena
    FROM t_katerina_trochtova_project_sql_primary_final tktpspf 
),
cte_rust AS (
    SELECT
        kategorie,
        rok,
        prumerna_cena_rok,
        predchozi_cena,
        (prumerna_cena_rok - predchozi_cena) 
            / predchozi_cena * 100 AS procentualni_rust
    FROM cte_vyvoj
    WHERE predchozi_cena IS NOT NULL
),
cte_prumerny_rust AS (
    SELECT
        kategorie,
        AVG(procentualni_rust) AS prumerny_rust
    FROM cte_rust
    GROUP BY kategorie
)
SELECT *
FROM cte_prumerny_rust
ORDER BY prumerny_rust ASC
LIMIT 1;