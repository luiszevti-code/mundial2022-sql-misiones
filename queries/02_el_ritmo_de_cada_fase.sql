-- Misión 2 · El ritmo de cada fase
-- Cantidad de partidos y promedio de goles por partido en cada fase del torneo.
USE mundial2022;

SELECT fase,
       COUNT(*) AS partidos,
       ROUND(AVG(goles_local + goles_visitante), 2) AS promedio_goles
FROM partidos
GROUP BY fase
ORDER BY MIN(fecha_hora);
