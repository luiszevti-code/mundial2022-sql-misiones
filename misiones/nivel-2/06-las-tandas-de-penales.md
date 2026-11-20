# Misión 6 · Las tandas de penales
**Nivel 2 · Interrogatorio** · Herramientas: doble `JOIN` a la misma tabla, `CONCAT`, `COUNT`, `SUM`, `ORDER BY` con condición

> Devi: "Cinco partidos de este Mundial no se resolvieron jugando, sino desde los once metros. Quiero ver cómo le fue a cada equipo en esas tandas."

## La pregunta
Para cada tanda de penales del Mundial, muestra cuántos penales lanzó y cuántos convirtió cada selección. El partido debe aparecer como "Local vs Visitante" en una sola columna y las tandas, en orden cronológico.

Hasta ahora filtrábamos con `periodo <= 4` para quedarnos con el tiempo de juego. Esta vez hacemos lo contrario: la tanda de penales es el **periodo 5**.

## La consulta
```sql
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
```

Archivo ejecutable: [`queries/06_las_tandas_de_penales.sql`](../../queries/06_las_tandas_de_penales.sql)

## El resultado

| partido | seleccion | penales_convertidos | penales_lanzados |
|---|---|---:|---:|
| Japan vs Croatia | Japan | 1 | 4 |
| Japan vs Croatia | Croatia | 3 | 4 |
| Morocco vs Spain | Morocco | 3 | 4 |
| Morocco vs Spain | Spain | 0 | 3 |
| Croatia vs Brazil | Croatia | 4 | 4 |
| Croatia vs Brazil | Brazil | 2 | 4 |
| Netherlands vs Argentina | Netherlands | 3 | 5 |
| Netherlands vs Argentina | Argentina | 4 | 5 |
| Argentina vs France | Argentina | 4 | 4 |
| Argentina vs France | France | 2 | 4 |

## Lo que descubrí
Hubo 5 tandas, y el equipo que más convirtió ganó las cinco. Croatia pasó por dos tandas seguidas (contra Japan y contra Brazil) y convirtió 7 de sus 8 penales. Spain fue el caso extremo: no convirtió ninguno de sus 3 lanzamientos contra Morocco. Argentina jugó dos tandas y convirtió 8 de 9; en la final fue perfecta, 4 de 4, frente a los 2 de 4 de France.

## Lo que aprendí de SQL
Se puede unir la misma tabla (`equipos`) tres veces con alias distintos: una para el equipo que tira (`eq`), otra para el local (`l`) y otra para el visitante (`v`). `CONCAT` arma el nombre del partido (en MariaDB no se usa `||`). Y como una comparación vale 1 si es verdadera y 0 si es falsa, `ORDER BY (eq.equipo_id = p.local_id) DESC` pone primero al equipo local dentro de cada partido.
