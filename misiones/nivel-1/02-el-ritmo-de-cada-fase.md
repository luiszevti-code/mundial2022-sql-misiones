# Misión 2 · El ritmo de cada fase
**Nivel 1 · Escena del crimen** · Herramientas: `GROUP BY`, `COUNT`, `AVG`, `ROUND`, `MIN`

> Devi: "Algunas fases parecen más sueltas que otras. ¿Dónde se hicieron más goles por partido?"

## La pregunta
Para cada fase del torneo, muestra cuántos partidos hubo y el promedio de goles por partido, redondeado a 2 decimales, en orden cronológico.

## La consulta
```sql
USE mundial2022;

SELECT fase,
       COUNT(*) AS partidos,
       ROUND(AVG(goles_local + goles_visitante), 2) AS promedio_goles
FROM partidos
GROUP BY fase
ORDER BY MIN(fecha_hora);
```

Archivo ejecutable: [`queries/02_el_ritmo_de_cada_fase.sql`](../../queries/02_el_ritmo_de_cada_fase.sql)

## El resultado
| Fase | Partidos | Promedio de goles |
|---|---:|---:|
| Group Stage | 48 | 2.50 |
| Round of 16 | 8 | 3.50 |
| Quarter-finals | 4 | 2.50 |
| Semi-finals | 2 | 2.50 |
| 3rd Place Final | 1 | 3.00 |
| Final | 1 | 6.00 |

## Lo que descubrí
Entre las fases con más de un partido, los octavos de final fueron los más goleadores: 3.5 goles por partido, un gol más por partido que en la fase de grupos (2.5). La final, con un solo partido, tuvo 6 goles en 120 minutos, aunque el partido con más goles de todo el torneo fue Inglaterra 6–2 Irán, en la fase de grupos (8 goles).

## Lo que aprendí de SQL
`GROUP BY` agrupa filas y permite calcular algo por cada grupo con funciones como `COUNT` y `AVG`. Para ordenar por una columna que no está en el `GROUP BY`, como la fecha, hay que usar una función de agregación (`MIN`): si no, la base elige un valor al azar de cada grupo.
