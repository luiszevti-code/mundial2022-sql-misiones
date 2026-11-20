-- Misión 6 · Las tandas de penales
-- Por cada tanda del Mundial: penales lanzados y convertidos por selección.
-- La tanda es el periodo 5; hasta ahora lo excluíamos (periodo <= 4).
USE mundial2022;

SELECT
    CONCAT(l.nombre, ' vs ', v.nombre) AS partido,
    eq.nombre AS seleccion,
    SUM(t.es_gol) AS penales_convertidos,
    COUNT(*) AS penales_lanzados
FROM tiros t
JOIN eventos e ON t.evento_id = e.evento_id
JOIN equipos eq ON e.equipo_id = eq.equipo_id
JOIN partidos p ON e.partido_id = p.partido_id
JOIN equipos l ON p.local_id = l.equipo_id
JOIN equipos v ON p.visitante_id = v.equipo_id
WHERE e.periodo = 5
GROUP BY
    p.partido_id,
    p.fecha_hora,
    l.nombre,
    v.nombre,
    eq.equipo_id,
    eq.nombre
ORDER BY
    p.fecha_hora ASC,
    (eq.equipo_id = p.local_id) DESC;
