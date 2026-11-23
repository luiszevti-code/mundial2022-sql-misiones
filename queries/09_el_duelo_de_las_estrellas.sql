-- Misión 9 · El duelo de las estrellas
-- Goles + asistencias por 90 minutos (jugadores con al menos 300 minutos). Top 5.
-- Tres CTEs (minutos, goles, asistencias) unidas con LEFT JOIN; COALESCE convierte NULL en 0.
-- Solo tiempo de juego (periodo <= 4).
USE mundial2022;

WITH minutos_jugador AS (
    SELECT j.jugador_id,
           j.nombre AS jugador,
           SUM(at.hasta_min - at.desde_min) AS minutos
    FROM alineacion_tramos at
    JOIN jugadores j ON j.jugador_id = at.jugador_id
    GROUP BY j.jugador_id, j.nombre
    HAVING SUM(at.hasta_min - at.desde_min) >= 300
),
goles_jugador AS (
    SELECT e.jugador_id,
           SUM(t.es_gol) AS goles
    FROM tiros t
    JOIN eventos e ON t.evento_id = e.evento_id
    WHERE e.periodo <= 4
    GROUP BY e.jugador_id
),
asistencias_jugador AS (
    SELECT e.jugador_id,
           SUM(p.es_asistencia) AS asistencias
    FROM pases p
    JOIN eventos e ON p.evento_id = e.evento_id
    WHERE e.periodo <= 4
    GROUP BY e.jugador_id
)
SELECT m.jugador,
       m.minutos,
       COALESCE(g.goles, 0) AS goles,
       COALESCE(a.asistencias, 0) AS asistencias,
       ROUND(
           (COALESCE(g.goles, 0) + COALESCE(a.asistencias, 0)) * 90.0 / m.minutos,
           2
       ) AS g_a_por_90
FROM minutos_jugador m
LEFT JOIN goles_jugador g ON g.jugador_id = m.jugador_id
LEFT JOIN asistencias_jugador a ON a.jugador_id = m.jugador_id
ORDER BY g_a_por_90 DESC
LIMIT 5;
