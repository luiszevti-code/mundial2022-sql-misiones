-- Misión 3 · Los más atrevidos
-- Los 5 jugadores con más tiros, con sus goles y su porcentaje de acierto.
-- Se excluye la tanda de penales (periodo 5).
USE mundial2022;

SELECT j.nombre AS jugador,
       COUNT(*) AS tiros,
       SUM(t.es_gol) AS goles,
       ROUND(100.0 * SUM(t.es_gol) / COUNT(*), 1) AS pct_acierto
FROM tiros t
JOIN eventos e   ON e.evento_id = t.evento_id
JOIN jugadores j ON j.jugador_id = e.jugador_id
WHERE e.periodo <= 4
GROUP BY j.jugador_id, j.nombre
ORDER BY tiros DESC
LIMIT 5;
