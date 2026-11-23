# Misión 8 · El goleador de cada selección
**Nivel 3 · Resolución** · Herramientas: CTEs encadenadas, `RANK() OVER (PARTITION BY ...)`

> Devi: "Todos hablan de la Bota de Oro, pero yo quiero saber quién fue el máximo goleador de **cada** equipo."

## La pregunta
Para cada selección que marcó, muestra a su goleador: el jugador con más goles con ese equipo. Si hay empate en el primer puesto, deben aparecer todos los empatados. Cuenta solo goles de tiros del tiempo de juego (`periodo <= 4`), ordenados de mayor a menor número de goles y, en empates, por selección.

## La consulta
```sql
USE mundial2022;

WITH goles_jugador AS (
    SELECT eq.nombre AS seleccion,
           j.nombre AS jugador,
           SUM(t.es_gol) AS goles
    FROM tiros t
    JOIN eventos e   ON t.evento_id = e.evento_id
    JOIN jugadores j ON j.jugador_id = e.jugador_id
    JOIN equipos eq  ON eq.equipo_id = e.equipo_id
    WHERE e.periodo <= 4
    GROUP BY eq.equipo_id, eq.nombre, j.jugador_id, j.nombre
),
ranking AS (
    SELECT seleccion, jugador, goles,
           RANK() OVER (PARTITION BY seleccion ORDER BY goles DESC) AS puesto
    FROM goles_jugador
)
SELECT seleccion, jugador, goles
FROM ranking
WHERE puesto = 1
ORDER BY goles DESC, seleccion;
```

Archivo ejecutable: [`queries/08_el_goleador_de_cada_seleccion.sql`](../../queries/08_el_goleador_de_cada_seleccion.sql)

## El resultado
Una fila por goleador de cada selección. Las primeras:

| seleccion | jugador | goles |
|---|---|---:|
| France | Kylian Mbappé Lottin | 8 |
| Argentina | Lionel Andrés Messi Cuccittini | 7 |
| Brazil | Richarlison de Andrade | 3 |
| Ecuador | Enner Remberto Valencia Lastra | 3 |
| England | Marcus Rashford | 3 |
| England | Bukayo Saka | 3 |
| Netherlands | Cody Mathès Gakpo | 3 |
| Portugal | Gonçalo Matias Ramos | 3 |
| Spain | Álvaro Borja Morata Martín | 3 |
| Cameroon | Vincent Paté Aboubakar | 2 |
| Croatia | Andrej Kramarić | 2 |
| Germany | Niclas Füllkrug | 2 |
| Germany | Kai Havertz | 2 |
| ... | | |

## Lo que descubrí
Mbappé (8) y Messi (7) lideraron la tabla con claridad: ningún otro goleador de selección pasó de 3 goles. Hubo empates en la cima de algunos equipos, y el `RANK` los muestra todos: England compartió el primer puesto entre Rashford y Saka (3 cada uno) y Germany entre Füllkrug y Havertz (2 cada uno).

## Lo que aprendí de SQL
Una función de ventana calcula sin colapsar las filas: `RANK() OVER (PARTITION BY seleccion ORDER BY goles DESC)` numera a los jugadores dentro de cada selección, reiniciando la cuenta en cada una. Como `RANK` da el mismo puesto a los empatados, filtrar `puesto = 1` devuelve a todos los goleadores empatados, algo que `LIMIT` no puede hacer. Y como no se puede filtrar una ventana en el `WHERE` donde nace, se calcula en una CTE y se filtra afuera.
