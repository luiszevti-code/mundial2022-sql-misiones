# Misión 3 · Los más atrevidos
**Nivel 1 · Escena del crimen** · Herramientas: triple `JOIN`, `COUNT`, `SUM`, `GROUP BY`, porcentajes

> Devi: "Hay jugadores que tiran a todo. ¿Quiénes patearon más veces al arco, y les sirvió?"

## La pregunta
Los 5 jugadores con más tiros en el torneo, con su cantidad de goles y el porcentaje de acierto (goles sobre tiros, con 1 decimal). No cuenta la tanda de penales.

## La consulta
```sql
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
```

Archivo ejecutable: [`queries/03_los_mas_atrevidos.sql`](../../queries/03_los_mas_atrevidos.sql)

## El resultado
| Jugador | Tiros | Goles | % acierto |
|---|---:|---:|---:|
| Lionel Andrés Messi Cuccittini | 32 | 7 | 21.9 |
| Kylian Mbappé Lottin | 31 | 8 | 25.8 |
| Olivier Giroud | 17 | 4 | 23.5 |
| Ivan Perišić | 16 | 1 | 6.3 |
| Lautaro Javier Martínez | 14 | 0 | 0.0 |

## Lo que descubrí
Messi fue quien más tiró (32 veces), pero Mbappé fue más efectivo: 8 goles con 31 tiros (25.8 %) frente a los 7 de Messi con 32 (21.9 %). Giroud marcó 4 goles con solo 17 tiros, y en el otro extremo Perišić convirtió 1 de 16 y Lautaro Martínez no marcó en ninguno de sus 14 tiros.

## Lo que aprendí de SQL
Una columna de 0 y 1 como `es_gol` se puede sumar para contar casos: `SUM(es_gol)` da los goles y `COUNT(*)` los tiros. El `WHERE` actúa antes de agrupar, y aquí era clave: sin `periodo <= 4`, Messi aparecería con 34 tiros, porque 2 son de las tandas de penales.
