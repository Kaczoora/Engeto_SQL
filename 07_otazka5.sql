-- 5 otazka

WITH cte_ceny AS (
    SELECT
        rok,
        AVG(prumerna_cena_rok) AS cena
    FROM t_katerina_trochtova_project_sql_primary_final
    GROUP BY rok
),
cte_mzdy AS (
    SELECT
        rok,
        AVG(prumerna_mzda_rok) AS mzda
    FROM t_katerina_trochtova_project_sql_primary_final
    GROUP BY rok
),
cte_hdp AS (
    SELECT
        rok,
        HDP
    FROM t_katerina_trochtova_project_sql_secondary_final
    WHERE zeme = 'Czech Republic'
),
cte_data AS (
    SELECT
        h.rok,
        h.HDP,
        m.mzda,
        c.cena
    FROM cte_hdp h
    JOIN cte_mzdy m ON h.rok = m.rok
    JOIN cte_ceny c ON h.rok = c.rok
),
cte_rust AS (
    SELECT
        rok,
        (HDP - LAG(HDP) OVER (ORDER BY rok)) / LAG(HDP) OVER (ORDER BY rok) * 100 AS rust_HDP,
        (mzda - LAG(mzda) OVER (ORDER BY rok)) / LAG(mzda) OVER (ORDER BY rok) * 100 AS rust_mezd,
        (cena - LAG(cena) OVER (ORDER BY rok)) / LAG(cena) OVER (ORDER BY rok) * 100 AS rust_cen
    FROM cte_data
)
,
cte_dalsi_rok AS (
	SELECT
   	 rok,
   	 rust_HDP,
    	LEAD(rust_mezd) OVER (ORDER BY rok) AS rust_mezd_next,
   	 LEAD(rust_cen) OVER (ORDER BY rok) AS rust_cen_next
	FROM cte_rust
)
,
cte_podklad AS (
	SELECT 
	r.rok AS rok,
	r.rust_hdp AS rust_hdp,
	r.rust_cen AS rust_cen,
	dr.rust_cen_next AS rust_cen_next,
	r.rust_mezd AS rust_mezd,
	dr.rust_mezd_next AS rust_mezd_next 
	FROM cte_dalsi_rok dr
	JOIN cte_rust r ON dr.rok = r.rok
)
SELECT 
    CORR(rust_HDP, rust_mezd ) AS korelace_mzdy,
    CORR(rust_HDP, rust_mezd_next) AS korelace_mzdy_next,
    CORR(rust_HDP, rust_cen) AS korelace_ceny,
    CORR(rust_HDP, rust_cen_next) AS korelace_ceny_next
FROM cte_podklad;
