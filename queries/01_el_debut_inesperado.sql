-- Misión 1 · El debut inesperado
-- Los 7 partidos de Argentina en orden cronológico, con rival y goles de cada lado.
USE mundial2022;

SELECT p.fecha_hora,
       p.fase,
       CASE WHEN l.nombre = 'Argentina' THEN v.nombre
            WHEN v.nombre = 'Argentina' THEN l.nombre
       END AS rival,
       CASE WHEN l.nombre = 'Argentina' THEN p.goles_local
            WHEN v.nombre = 'Argentina' THEN p.goles_visitante
       END AS goles_arg,
       CASE WHEN l.nombre = 'Argentina' THEN p.goles_visitante
            WHEN v.nombre = 'Argentina' THEN p.goles_local
       END AS goles_rival
FROM partidos p
JOIN equipos l ON l.equipo_id = p.local_id
JOIN equipos v ON v.equipo_id = p.visitante_id
WHERE l.nombre = 'Argentina' OR v.nombre = 'Argentina'
ORDER BY p.fecha_hora ASC;
