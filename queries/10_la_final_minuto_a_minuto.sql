-- Misión 10 · La final minuto a minuto
-- Los goles de la final Argentina-France con marcador acumulado (SUM OVER) y
-- minutos desde el gol anterior (LAG). Solo tiempo de juego (periodo <= 4).
USE mundial2022;

WITH goles_final AS (
    SELECT e.evento_id,
           e.minuto,
           j.nombre AS goleador,
           eq.nombre AS equipo
    FROM tiros t
    JOIN eventos e   ON t.evento_id = e.evento_id
    JOIN partidos p  ON e.partido_id = p.partido_id
    JOIN jugadores j ON e.jugador_id = j.jugador_id
    JOIN equipos eq  ON e.equipo_id = eq.equipo_id
    WHERE p.fase = 'Final'
      AND t.es_gol = 1
      AND e.periodo <= 4
),
marcador_cronologico AS (
    SELECT minuto,
           goleador,
           equipo,
           SUM(CASE WHEN equipo = 'Argentina' THEN 1 ELSE 0 END)
               OVER (ORDER BY minuto, evento_id) AS marcador_arg,
           SUM(CASE WHEN equipo = 'France' THEN 1 ELSE 0 END)
               OVER (ORDER BY minuto, evento_id) AS marcador_fra,
           minuto - LAG(minuto) OVER (ORDER BY minuto, evento_id) AS min_desde_el_anterior
    FROM goles_final
)
SELECT minuto,
       goleador,
       equipo,
       marcador_arg,
       marcador_fra,
       min_desde_el_anterior
FROM marcador_cronologico
ORDER BY minuto;
