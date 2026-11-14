# Misión 1 · El debut inesperado
**Nivel 1 · Escena del crimen** · Herramientas: `JOIN` doble con alias, `CASE`, `ORDER BY`

> Devi: "Argentina fue campeona, pero algo no cuadra en su inicio. ¿Cómo empezó el torneo?"

## La pregunta
Lista los 7 partidos de Argentina en orden cronológico, con la fecha, la fase, el rival y los goles de cada lado.

## La consulta
```sql
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
```

Archivo ejecutable: [`queries/01_el_debut_inesperado.sql`](../../queries/01_el_debut_inesperado.sql)

## El resultado
| Fecha y hora | Fase | Rival | Goles ARG | Goles rival |
|---|---|---|---:|---:|
| 2022-11-22 10:00 | Group Stage | Saudi Arabia | 1 | 2 |
| 2022-11-26 19:00 | Group Stage | Mexico | 2 | 0 |
| 2022-11-30 19:00 | Group Stage | Poland | 2 | 0 |
| 2022-12-03 21:00 | Round of 16 | Australia | 2 | 1 |
| 2022-12-09 19:00 | Quarter-finals | Netherlands | 2 | 2 |
| 2022-12-13 21:00 | Semi-finals | Croatia | 3 | 0 |
| 2022-12-18 17:00 | Final | France | 3 | 3 |

## Lo que descubrí
Argentina empezó el torneo perdiendo 1–2 ante Arabia Saudita, pero no volvió a perder en tiempo reglamentario: ganó 4 partidos y empató 2. Esos dos empates fueron los más duros, cuartos de final y final, y los dos se resolvieron en la tanda de penales. En total hizo 15 goles y recibió 8.

## Lo que aprendí de SQL
Una misma tabla se puede unir dos veces si le pones alias distintos (`l` para el local y `v` para el visitante), y un `CASE` elige qué columna mostrar según quién es Argentina en cada partido. Las columnas que uso para decidir no tienen que aparecer en el resultado.
