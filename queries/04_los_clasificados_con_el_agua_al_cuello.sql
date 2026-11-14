-- Misión 4 · Los clasificados con el agua al cuello
-- Equipos que jugaron los octavos de final tras terminar la fase de grupos con solo 4 puntos.
USE mundial2022;

WITH resultados AS (
    -- Cada partido de grupos cuenta dos veces: una por cada equipo.
    SELECT local_id AS equipo_id, goles_local AS gf, goles_visitante AS gc
    FROM partidos
    WHERE fase = 'Group Stage'
    UNION ALL
    SELECT visitante_id, goles_visitante, goles_local
    FROM partidos
    WHERE fase = 'Group Stage'
),
tabla AS (
    -- Tabla de posiciones de la fase de grupos.
    SELECT e.grupo,
           e.nombre AS equipo,
           COUNT(*) AS pj,
           SUM(CASE WHEN r.gf >  r.gc THEN 1 ELSE 0 END) AS pg,
           SUM(CASE WHEN r.gf =  r.gc THEN 1 ELSE 0 END) AS pe,
           SUM(CASE WHEN r.gf <  r.gc THEN 1 ELSE 0 END) AS pp,
           SUM(r.gf) AS gf,
           SUM(r.gc) AS gc,
           SUM(r.gf) - SUM(r.gc) AS dif_goles,
           SUM(CASE WHEN r.gf > r.gc THEN 3
                    WHEN r.gf = r.gc THEN 1
                    ELSE 0 END) AS puntos
    FROM resultados r
    JOIN equipos e ON e.equipo_id = r.equipo_id
    GROUP BY e.grupo, e.nombre
)
SELECT grupo, equipo, puntos, dif_goles
FROM tabla
WHERE puntos = 4
  AND equipo IN (
        -- Nombres de los equipos que jugaron un partido de octavos.
        SELECT eq.nombre
        FROM equipos eq
        JOIN partidos p ON eq.equipo_id IN (p.local_id, p.visitante_id)
        WHERE p.fase = 'Round of 16'
  )
ORDER BY equipo;
