# Devi y el caso del Mundial · Misiones de SQL

<img src="docs/devi.png" align="right" width="200" alt="Devi, la mascota de MentDev">
Diez misiones de análisis en SQL sobre el Mundial de Qatar 2022. Devi, la mascota de MentDev, investiga cómo se jugó el torneo, y cada misión es una pregunta que se responde con una consulta: desde un `JOIN` sencillo hasta funciones de ventana.

Es el **Proyecto 2** de mi serie de SQL. El [Proyecto 1](https://github.com/TU-USUARIO/mundial2022-sql-database) construye la base de datos; este la usa.

> Diseño y análisis: Luis Zevallos · MentDev

---

## Antes de empezar

Necesitas la base `mundial2022` del Proyecto 1 ya cargada (MySQL 8 o MariaDB 10.4+). Sigue las instrucciones de ese repositorio y vuelve aquí.

Todas las consultas empiezan con:

```sql
USE mundial2022;
```

## El caso

El Mundial de Qatar 2022 tuvo de todo: el campeón perdió su debut, hubo cinco tandas de penales y la final se decidió en una de ellas. Devi quiere entender cómo pasó, y lo hace por etapas.

## Las misiones

| # | Misión | Herramientas | Estado |
|---|---|---|---|
| **Nivel 1 · Escena del crimen** | | | |
| 1 | [El debut inesperado](misiones/nivel-1/01-el-debut-inesperado.md) | `JOIN`, `CASE`, `ORDER BY` | ✅ |
| 2 | [El ritmo de cada fase](misiones/nivel-1/02-el-ritmo-de-cada-fase.md) | `GROUP BY`, `AVG` | ✅ |
| 3 | [Los más atrevidos](misiones/nivel-1/03-los-mas-atrevidos.md) | `JOIN`, `GROUP BY`, porcentajes | ✅ |
| **Nivel 2 · Interrogatorio** | | | |
| 4 | [Los clasificados con el agua al cuello](misiones/nivel-2/04-los-clasificados-con-el-agua-al-cuello.md) | CTE, subconsultas | ✅ |
| 5 | [La lotería del gol (xG)](misiones/nivel-2/05-la-loteria-del-gol.md) | agregaciones, comparaciones | ✅ |
| 6 | Las tandas de penales | filtros por periodo, `GROUP BY` | ⬜ |
| 7 | Los minutos de oro | `CASE` en agrupaciones | ⬜ |
| **Nivel 3 · Resolución** | | | |
| 8 | El goleador de cada selección | `RANK() OVER (PARTITION BY …)` | ⬜ |
| 9 | El duelo de las estrellas | varias CTEs, `LEFT JOIN`, `COALESCE` | ⬜ |
| 10 | La final minuto a minuto | `COUNT() OVER`, `LAG` | ⬜ |

## Estructura del repositorio

```
├── misiones/    Una ficha por misión: pregunta, consulta, resultado y hallazgo
├── queries/     Las consultas en archivos .sql, listas para ejecutar
├── docs/        Capturas de pantalla
└── README.md
```

## Datos y créditos

Datos: **StatsBomb Open Data** (FIFA World Cup 2022), cargados en el Proyecto 1.

<img src="docs/statsbomb-logo.png" alt="StatsBomb" width="180">
