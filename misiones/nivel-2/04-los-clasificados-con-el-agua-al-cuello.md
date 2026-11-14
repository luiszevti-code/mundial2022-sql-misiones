# Misión 4 · Los clasificados con el agua al cuello
**Nivel 2 · Interrogatorio** · Herramientas: CTE (`WITH`), `UNION ALL`, subconsulta con `IN`

> Devi: "Pasar a octavos parecía fácil, pero algunos lo lograron por poco. ¿Quiénes avanzaron con menos puntos?"

## La pregunta
De los equipos que jugaron los octavos de final (`Round of 16`), ¿cuáles terminaron la fase de grupos con solo 4 puntos? Muestra el grupo, el equipo, los puntos y la diferencia de goles.

## La consulta
```sql
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
```

Archivo ejecutable: [`queries/04_los_clasificados_con_el_agua_al_cuello.sql`](../../queries/04_los_clasificados_con_el_agua_al_cuello.sql)

## El resultado
| Grupo | Equipo | Puntos | Dif. de goles |
|---|---|---:|---:|
| C | Poland | 4 | 0 |
| H | South Korea | 4 | 0 |
| E | Spain | 4 | 6 |

## Lo que descubrí
Tres equipos pasaron a octavos con apenas 4 puntos, el mínimo con el que se clasificó en este torneo. Polonia (empató con México, ganó a Arabia Saudita y perdió con Argentina) y Corea del Sur (empató con Uruguay, perdió con Ghana y ganó a Portugal) lo hicieron con diferencia de goles 0. España llegó con +6 gracias a su 7–0 sobre Costa Rica, aunque empató con Alemania y perdió con Japón.

## Lo que aprendí de SQL
Un CTE divide un problema en pasos con nombre: primero `resultados` (donde `UNION ALL` convierte cada partido en dos filas, una por equipo), luego `tabla`, y al final el filtro. Una subconsulta con `IN` sirve como lista de valores permitidos, y `ON equipo_id IN (local_id, visitante_id)` une una tabla con cualquiera de los dos lados de un partido.
