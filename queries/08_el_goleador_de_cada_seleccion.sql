-- Misión 8 · El goleador de cada selección
-- Máximo goleador de cada equipo (con empates) usando RANK() OVER (PARTITION BY ...).
-- Solo goles de tiros en tiempo de juego (periodo <= 4).
USE mundial2022;

WITH goles_jugador AS (
    SELECT eq.nombre AS seleccion,
           j.nombre AS jugador,
           SUM(t.es_gol) AS goles
    FROM tiros t
    JOIN eventos e   ON t.evento_id = e.evento_id
    JOIN jugadores j ON j.jugador_id = e.jugador_id
    JOIN equipos eq  ON eq.equipo_id = e.equipo_id
    WHERE e.periodo <= 4
    GROUP BY eq.equipo_id, eq.nombre, j.jugador_id, j.nombre
),
ranking AS (
    SELECT seleccion, jugador, goles,
           RANK() OVER (PARTITION BY seleccion ORDER BY goles DESC) AS puesto
    FROM goles_jugador
)
SELECT seleccion, jugador, goles
FROM ranking
WHERE puesto = 1
ORDER BY goles DESC, seleccion;
