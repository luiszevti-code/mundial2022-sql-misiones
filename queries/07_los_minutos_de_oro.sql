-- Misión 7 · Los minutos de oro
-- Goles por tramo de partido (solo goles de tiros: sin autogoles ni tanda de penales).
-- Una CTE clasifica cada gol en un tramo y le asigna un orden para ordenar cronológicamente.
USE mundial2022;

WITH goles_clasificados AS (
    SELECT
        e.evento_id,
        CASE
            WHEN e.periodo IN (3, 4) THEN 'Prórroga'
            WHEN e.periodo = 1 AND e.minuto BETWEEN 0 AND 14 THEN '0–14'
            WHEN e.periodo = 1 AND e.minuto BETWEEN 15 AND 29 THEN '15–29'
            WHEN e.periodo = 1 AND e.minuto >= 30 THEN '30–45+'
            WHEN e.periodo = 2 AND e.minuto BETWEEN 45 AND 59 THEN '45–59'
            WHEN e.periodo = 2 AND e.minuto BETWEEN 60 AND 74 THEN '60–74'
            WHEN e.periodo = 2 AND e.minuto >= 75 THEN '75–90+'
        END AS tramo,
        CASE
            WHEN e.periodo IN (3, 4) THEN 7
            WHEN e.periodo = 1 AND e.minuto BETWEEN 0 AND 14 THEN 1
            WHEN e.periodo = 1 AND e.minuto BETWEEN 15 AND 29 THEN 2
            WHEN e.periodo = 1 AND e.minuto >= 30 THEN 3
            WHEN e.periodo = 2 AND e.minuto BETWEEN 45 AND 59 THEN 4
            WHEN e.periodo = 2 AND e.minuto BETWEEN 60 AND 74 THEN 5
            WHEN e.periodo = 2 AND e.minuto >= 75 THEN 6
        END AS orden_tramo
    FROM tiros t
    JOIN eventos e ON t.evento_id = e.evento_id
    WHERE t.es_gol = 1
      AND e.periodo IN (1, 2, 3, 4)
)
SELECT tramo, COUNT(*) AS goles
FROM goles_clasificados
GROUP BY tramo
ORDER BY MIN(orden_tramo) ASC;
