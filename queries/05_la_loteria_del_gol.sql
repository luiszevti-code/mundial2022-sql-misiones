-- Misión 5 · La lotería del gol (xG)
-- Por selección: goles reales, goles esperados (xG) y la diferencia entre ambos.
-- Solo tiempo de juego (periodo <= 4): no cuenta la tanda de penales.
USE mundial2022;

SELECT eq.nombre AS Equipo,
       SUM(t.es_gol) AS Goles,
       ROUND(SUM(t.xg), 1) AS xG,
       ROUND(SUM(t.es_gol) - SUM(t.xg), 1) AS Diferencia
FROM tiros t
INNER JOIN eventos ev ON t.evento_id = ev.evento_id
INNER JOIN equipos eq ON eq.equipo_id = ev.equipo_id
WHERE ev.periodo <= 4
GROUP BY eq.equipo_id, eq.nombre
ORDER BY SUM(t.es_gol) - SUM(t.xg) DESC;
