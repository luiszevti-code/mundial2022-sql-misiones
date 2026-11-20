# Misión 7 · Los minutos de oro
**Nivel 2 · Interrogatorio** · Herramientas: CTE, `CASE` sobre rangos, `COUNT`, `ORDER BY MIN()`

> Devi: "¿Cuándo se marcan los goles? Quiero saber si el Mundial se decide al comienzo, en el medio o sobre el final."

## La pregunta
Divide el partido en tramos y cuenta cuántos goles se marcaron en cada uno: 0–14, 15–29, 30–45+ (primer tiempo con adición), 45–59, 60–74, 75–90+ (segundo tiempo con adición) y prórroga. Solo cuentan los goles de tiros: no los autogoles ni la tanda de penales.

## La consulta
```sql
USE mundial2022;

WITH goles_clasificados AS (
    SELECT
        e.evento_id,
        CASE
            WHEN e.periodo IN (3, 4) THEN 'Prórroga'
            WHEN e.periodo = 1 AND e.minuto BETWEEN 0 AND 14 THEN '0–14'
            WHEN e.periodo = 1 AND e.minuto BETWEEN 15 AND 29 THEN '15–29'
            WHEN e.periodo = 1 AND e.minuto >= 30 THEN '30–45+'
            WHEN e.periodo = 2 AND e.minuto BETWEEN 45 AND 59 THEN '45–59'
            WHEN e.periodo = 2 AND e.minuto BETWEEN 60 AND 74 THEN '60–74'
            WHEN e.periodo = 2 AND e.minuto >= 75 THEN '75–90+'
        END AS tramo,
        CASE
            WHEN e.periodo IN (3, 4) THEN 7
            WHEN e.periodo = 1 AND e.minuto BETWEEN 0 AND 14 THEN 1
            WHEN e.periodo = 1 AND e.minuto BETWEEN 15 AND 29 THEN 2
            WHEN e.periodo = 1 AND e.minuto >= 30 THEN 3
            WHEN e.periodo = 2 AND e.minuto BETWEEN 45 AND 59 THEN 4
            WHEN e.periodo = 2 AND e.minuto BETWEEN 60 AND 74 THEN 5
            WHEN e.periodo = 2 AND e.minuto >= 75 THEN 6
        END AS orden_tramo
    FROM tiros t
    JOIN eventos e ON t.evento_id = e.evento_id
    WHERE t.es_gol = 1
      AND e.periodo IN (1, 2, 3, 4)
)
SELECT tramo, COUNT(*) AS goles
FROM goles_clasificados
GROUP BY tramo
ORDER BY MIN(orden_tramo) ASC;
```

Archivo ejecutable: [`queries/07_los_minutos_de_oro.sql`](../../queries/07_los_minutos_de_oro.sql)

## El resultado

| tramo | goles |
|---|---:|
| 0–14 | 15 |
| 15–29 | 16 |
| 30–45+ | 35 |
| 45–59 | 28 |
| 60–74 | 30 |
| 75–90+ | 41 |
| Prórroga | 4 |

Suman 169 goles: los 172 del torneo menos 3 autogoles, que no nacen de un tiro.

## Lo que descubrí
Los goles se acumulan hacia el final de cada tiempo. El tramo más goleador fue 75–90+ con 41 goles (cerca de uno de cada cuatro), seguido de 30–45+ con 35. El arranque, en cambio, es cauteloso: solo 15 goles en los primeros 15 minutos. El segundo tiempo (99 goles) produjo bastante más que el primero (66), y la prórroga apenas sumó 4.

## Lo que aprendí de SQL
Un `CASE` puede clasificar filas en rangos, y el orden de sus condiciones importa porque gana la primera que se cumple. Para ordenar los tramos cronológicamente (y no alfabéticamente) se les asigna un número de orden y se usa `ORDER BY MIN(orden_tramo)`. Una CTE deja la clasificación separada del conteo, y así la consulta final queda corta y legible.
