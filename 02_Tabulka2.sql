CREATE TABLE t_katerina_trochtova_project_SQL_secondary_final AS
SELECT
    e.country AS zeme,
    e.YEAR AS rok,
    e.gdp AS HDP,
    e.gini AS GINI,
    e.population AS populace
FROM economies e
JOIN countries c
    ON e.country = c.country
WHERE c.continent = 'Europe'
  AND e."year" BETWEEN 2006 AND 2018;