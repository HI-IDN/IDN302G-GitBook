---
description: >-
  SQLite er létt gagnagrunnskerfi sem hentar vel fyrir minni verkefni þar sem einfaldleiki,
  hraði og flytjanleiki eru mikilvægir þættir. Það er frjálst, sjálfstætt og krefst ekki sérstaks gagnasafnsþjóns.
---

# SQLite

_SQLite_ er létt gagnagrunnskerfi sem hentar vel fyrir minni verkefni þar sem einfaldleiki og hraði
eru mikilvægir þættir. _SQLite_ er frjálst, auðvelt í uppsetningu og þarf ekki sérstaka
gagnasafnsþjóna. Það er víða notað, meðal annars í vöfrum, símum og ýmsum forritum (sjá þekkt
dæmi [hér](https://www.sqlite.org/famous.html)).

_SQLite_ var búið til af Richard Hipp í kringum 2000 þegar hann vann hjá General Dynamics í
samstarfi við Bandaríkjaher. Hönnunarmarkmið var að þróa kerfi sem getur verið notað án þess að
þurfa gagnasafnskerfi
([sjá hér](https://thenewstack.io/the-origin-story-of-sqlite-the-worlds-most-widely-used-database-software/)).

Það eru til grafísk viðmót (GUI) fyrir _SQLite_, t.d. [SQLite Online](https://sqliteonline.com/).
Þau gefa betri yfirsýn yfir gagnasafn með mörgum töflum.

## Uppsetning

### Windows

Til að setja upp _SQLite_ á Windows:

1. Farðu á [www.sqlite.com](https://www.sqlite.com).
2. Sæktu og unzipaðu nýjustu útgáfu.
3. Settu möppuna á rót disks (t.d. `C:\SQLite`).
4. Bættu við slóðinni í _Environment Variables_ undir _system path_ (`PATH` breytan).

### Linux og macOS

_SQLite_ er oftast sjálfgefið uppsett á macOS og flestum Linux dreifingum, undir `sqlite3`.

### Aðrar uppsetningaleiðir

- **DB-Browser:** Ágætis tól til að halda utan um lítil venslagagnasöfn og byggir á
  _SQLite_: [https://sqlitebrowser.org/](https://sqlitebrowser.org/)
- **SQLITEONLINE.com:** Hægt að æfa sig online hér og m.a. loada `.db` skrám. En notið þetta
  einungis sem síðasta úrræði ef uppsetning gengur
  ekki: [https://sqliteonline.com/](https://sqliteonline.com/)
- **SQLITE í R:** Hægt að nota R til að halda utan um gagnagrunninn og framkvæma fyrirspurnir. Hér
  náið þið að slá tvær flugur í einu höggi með að gera skýrslugerð og gagnavinnslu í sama skjali.

## Notkun á skipanaskel

_SQLite_ er notað í gegnum skipanaskel sem gerir notendum kleift að framkvæma SQL fyrirspurnir
beint á gagnagrunnum.

Sækið skránna [surgeries.db](../../data/surgeries.db) og keyrið í skel (e. _terminal_) úr sömu
möppu og skráin er. Notið `cd` (stendur fyrir _change directory_) til að breyta um möppu.

Keyrið skipunina `sqlite3` í skelinni. Opnið gagnasafnið með skipuninni `.open surgeries.db`. Prófið
nokkrar skipanir sem finnast með `.help`.

```bash 
-- Open the database
.open surgeries.db

-- List all tables
.tables

-- Show the structure of a table
.schema table_name

-- Display results in column mode
.mode columns

-- Enable headers in results
.headers on
```

_SQLite_ er hannað til að vera einfalt og hratt, sem gerir það að góðu vali fyrir notendur sem þurfa
ekki flóknari eiginleika stærri gagnagrunnskerfa eins og _PostgreSQL_ eða _MySQL_.
