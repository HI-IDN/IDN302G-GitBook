---
description: >-
  Þessi kafli er inngangur að SQL og venslagagnasöfnum með dæmum úr mismunandi 
  SQL gagnagrunnskerfum. Kaflinn útskýrir helstu skipanir og líkindin á milli SQL 
  fyrirspurnarmála, eins og PostgreSQL, MySQL, SQLite og Microsoft SQL Server. 
  Fyrir frekari upplýsingar um hvernig SELECT skipanir eru búnar til, sjá 
  [sql/quickstart.md](sql/quickstart.md).
---

# Inngangur

Markmið námskeiðsins er að kynnast fyrirspurnarmálinu SQL:

- búa til fyrirspurnir,
- skilja fyrirspurnir sem þið sjáið,
- geta notað SQL til að framkvæma gagnagreiningu.

SQL (Structured Query Language) er staðlað fyrirspurnarmál sem er notað til að hafa samskipti við venslagagnasöfn.

## Ólík SQL fyrirspurnarmál

Samkvæmt [DB-Engines Ranking](https://db-engines.com/en/ranking) eru vinsælustu gagnagrunnskerfin:

1. Oracle
2. MySQL
3. Microsoft SQL Server
4. PostgreSQL
5. MongoDB
6. Redis
7. Snowflake
8. Elasticsearch
9. IBM Db2
10. SQLite

Við munum kynnast SQLite og PostgreSQL í þessu námskeiði.

## Líkindi milli SQL fyrirspurnarmála

Flest SQL fyrirspurnarmál fylgja svipuðum grunnatriðum og setningafræði. Þau leyfa notendum að framkvæma fyrirspurnir á gagnagrunnum á einfaldan hátt. Þrátt fyrir að smávægilegur munur geti verið til staðar milli mismunandi gagnagrunnskerfa, eins og PostgreSQL og SQLite, eru grunnskipanirnar oft mjög keimlíkar og auðvelt að aðlaga sig á milli kerfa. Fyrir frekari upplýsingar um hvernig SELECT skipanir eru búnar til, sjá [sql/quickstart.md](sql/quickstart.md).

Hér eru dæmi um grunnskipanir í SQL fyrir mismunandi gagnagrunnskerfi:

### PostgreSQL
```sql
-- Select all rows from a table
SELECT * FROM tbl;

-- Select specific columns and sort by a column
SELECT col1, col2 FROM tbl ORDER BY col1 DESC;

-- Select the first 10 rows
SELECT * FROM tbl LIMIT 10;
```

### MySQL
```sql
-- Select all rows from a table
SELECT * FROM tbl;

-- Select specific columns and sort by a column
SELECT col1, col2 FROM tbl ORDER BY col1 DESC;

-- Select the first 10 rows
SELECT * FROM tbl LIMIT 10;
```

### SQLite
```sql
-- Select all rows from a table
SELECT * FROM tbl;

-- Select specific columns and sort by a column
SELECT col1, col2 FROM tbl ORDER BY col1 DESC;

-- Select the first 10 rows
SELECT * FROM tbl LIMIT 10;
```

### Microsoft SQL Server
```sql
-- Select all rows from a table
SELECT * FROM tbl;

-- Select specific columns and sort by a column
SELECT col1, col2 FROM tbl ORDER BY col1 DESC;

-- Select the first 10 rows
SELECT TOP 10 * FROM tbl;
```

