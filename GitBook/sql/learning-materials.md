# Ítarefni fyrir SQL nám

Til að dýpka skilning á SQL og tengdum gagnagrunnstækni eru hér nokkur frábær öpp og kennslubækur
sem mælt er með að nemendur skoði. Þetta efni er bæði gagnlegt til að læra grunnatriði og bæta við
þekkingu í sérhæfðari þáttum.

## 1. [W3Schools SQL kennsla](https://www.w3schools.com/sql/)

**Kostir:**

- Einföld og aðgengileg útskýring á SQL, frá grunnatriðum til flóknari fyrirspurna.
- Skýrar skref-fyrir-skref leiðbeiningar með dæmum sem nemendur geta fylgt og prófað.
- Hentar mjög vel fyrir byrjendur.

## 2. [SQLite skjölun](https://www.sqlite.org/docs.html)

**Kostir:**

- Opinber skjölun fyrir _SQLite_, sem er mjög gagnlegt fyrir þá sem vinna með _SQLite_ gagnagrunna.
- Ítarlegar upplýsingar um uppsetningu, notkun og þróun _SQLite_ gagnagrunna.
- Frábært efni fyrir þá sem vilja kafa dýpra í notkun _SQLite_.

## 3. [PostgreSQL skjölun](https://www.postgresql.org/docs/current/)

**Kostir:**

- Opinber skjölun fyrir _PostgreSQL_, sem er mikið notuð í fyrirtækjum og vefþjónustu.
- Mjög ítarlegar og tæknilegar upplýsingar um uppsetningu, stillingar, og notkun _PostgreSQL_.
- Hentar vel þeim sem vilja sérhæfa sig í _PostgreSQL_ sem gagnagrunnskerfi.

## 4. **Kennslubók:** [*SQL in a

Nutshell*](https://www.oreilly.com/library/view/sql-in-a/9781492088851/)

- **Höfundar:** Kevin Kline, Regina O. Obe, Leo S. Hsu
- **Útgefandi:** O'Reilly Media, Inc.
- **ISBN:** 9781492088868, 1492088862
- **Útgáfuár:** 2022
- **Útgáfa:** 4. útgáfa

**Kostir:**

- Frábær handbók fyrir SQL þar sem farið er yfir SQL setningar og notkun á mismunandi
  gagnagrunnskerfum (_PostgreSQL_, _Oracle_, _MySQL_, o.fl.).
- Hentar bæði byrjendum og lengra komnum með ítarlegum dæmum.
- Góð uppflettibók fyrir nemendur sem vilja skilja SQL í mismunandi gagnagrunnskerfum.

# IDE fyrir gagnagrunnskerfi

Til að auðvelda vinnu með gagnagrunan er gott að nota þróunarumhverfi (IDE) sem býður upp á
sérstakar aðgerðir fyrir gagnagrunna. Hér eru þrjú tól sem mælt er með:

### 1. [DataGrip](https://www.jetbrains.com/datagrip/)

**Kostir:**

- DataGrip er öflugt IDE frá _JetBrains_ sem styður marga gagnagrunnsþjónustu, þar á meðal
  _PostgreSQL_.
- Hægt er að tengja _GitHub CoPilot_ við DataGrip til að fá tillögur að SQL fyrirspurnum.
- Nemandar geta sótt um frítt leyfi sem gildir í eitt ár í senn, á meðan þeir eru í námi.

### 2. [DBeaver](https://dbeaver.io/)

**Kostir:**

- DBeaver er opinn hugbúnaður (e. _open source_) sem styður mörg gagnagrunnskerfi, þar á meðal
  _PostgreSQL_.
- Það býður upp á einfalt og aðgengilegt viðmót.
- DBeaver er frítt og auðvelt í notkun, sem gerir það að frábærum valkost fyrir nemendur og
  minni fyrirtæki.

### 3. [Visual Studio Code (VSCode)](https://code.visualstudio.com/)

**Kostir:**

- VSCode er mjög aðgengilegt þróunarumhverfi sem styður marga viðbótarpakka fyrir vinnu með SQL,
  eins og _PostgreSQL_.
- Með því að nota VSCode geturðu unnið með kóða og SQL í sama umhverfi, sem sparar tíma og eykur
  framleiðni.
- VSCode er opinn hugbúnaður frá Microsoft og hentar vel fyrir þá sem vilja einfalt og öflugt IDE 
  sem virkar m.a. fyrir gagnagrunnskerfi.
 
# Gagnagrunnar með R

[Gagnagrunnar og SQL í RStudio - R-bloggers](https://www.r-bloggers.com/2022/02/working-with-databases-and-sql-in-rstudio/)
útskýrir hvernig hægt er að vinna með gagnagrunna og SQL beint í _RStudio_. Hún fer yfir
helstu tól og aðferðir til að tengjast gagnagrunnum eins og _SQLite_ og _PostgreSQL_ með R.

## SQLite með R

### [RSQLite pakki](https://cran.r-project.org/web/packages/RSQLite/index.html)

**Kostir:**

- `RSQLite` gerir R notendum kleift að vinna með _SQLite_ gagnagrunna beint innan R umhverfisins.
- Auðvelt í notkun fyrir smærri gagnasöfn eða sýnidæmi þar sem ekki er þörf á stórum
  gagnagrunnskerfum.
- [Skjölun fyrir RSQLite](https://cran.r-project.org/web/packages/RSQLite/RSQLite.pdf) útskýrir
  uppsetningu og notkun.

**Dæmi um notkun:**

```r
# Hlaða inn pakkanum
library(RSQLite)

# Tengja við SQLite gagnagrunn
con <- dbConnect(RSQLite::SQLite(), "nafn_grunns.db")

# Keyra SQL fyrirspurn
res <- dbSendQuery(con, "SELECT * FROM tafla")
data <- fetch(res, n = -1)

# Loka tengingu
dbDisconnect(con)
```

## PostgreSQL með R

### [RPostgreSQL pakki](https://cran.r-project.org/web/packages/RPostgreSQL/index.html)

**Kostir:**

- `RPostgreSQL` pakkinn leyfir R notendum að tengjast _PostgreSQL_ gagnagrunnum beint og vinna með
  gögn í R.
- Gagnlegt fyrir þá sem vinna með stór gagnasöfn í _PostgreSQL_ og þurfa að framkvæma
  tölfræðigreiningu í R.
- [Skjölun fyrir RPostgreSQL](https://cran.r-project.org/web/packages/RPostgreSQL/vignettes/RPostgreSQL.pdf)
  veitir ítarlegar upplýsingar um uppsetningu og notkun.

**Dæmi um notkun:**

```r
# Hlaða inn pakkanum
library(RPostgreSQL)

# Tengja við PostgreSQL gagnagrunn
drv <- dbDriver("PostgreSQL")
con <- dbConnect(drv, dbname = "nafn_grunns", host = "localhost",
                 port = 5432, user = "notandi", password = "lykilorð")

# Keyra SQL fyrirspurn
res <- dbSendQuery(con, "SELECT * FROM tafla")
data <- fetch(res, n = -1)

# Loka tengingu
dbDisconnect(con)
```

# Gagnagrunnar í Python

## SQLite með Python

### [sqlite3 pakki](https://docs.python.org/3/library/sqlite3.html)

**Kostir:**

- `sqlite3` er innbyggður gagnagrunnspakki í Python sem gerir auðvelt að vinna með _SQLite_
  gagnagrunna án þess að setja upp auka hugbúnað.
- Hentar fyrir smærri verkefni eða þegar einföld gagnavinnsla er nauðsynleg.
- [Skjölun fyrir sqlite3](https://docs.python.org/3/library/sqlite3.html) útskýrir hvernig á að nota
  þennan pakka með einföldum dæmum.

**Dæmi um notkun:**

```python
import sqlite3

# Tengja við SQLite gagnagrunn
conn = sqlite3.connect('nafn_grunns.db')

# Búa til cursor og keyra SQL fyrirspurn
cur = conn.cursor()
cur.execute("SELECT * FROM tafla;")
results = cur.fetchall()

# Loka tengingu
cur.close()
conn.close()
```

## PostgreSQL með Python

### [psycopg2 pakki](https://www.psycopg.org/)

**Kostir:**

- `psycopg2` er vinsælasti pakkinn fyrir tengingar við _PostgreSQL_ gagnagrunna í Python.
- Styður flóknar SQL fyrirspurnir, tengingar við stór gagnasöfn, og gerir auðvelt að sækja og vinna
  með gögn.
- [Skjölun fyrir psycopg2](https://www.psycopg.org/docs/) veitir nákvæmar leiðbeiningar um
  uppsetningu og notkun.

**Dæmi um notkun:**

```python
import psycopg2

# Tengja við PostgreSQL gagnagrunn
conn = psycopg2.connect(
    host="localhost",
    database="nafn_grunns",
    user="notandi",
    password="lykilorð"
)

# Búa til cursor og keyra SQL fyrirspurn
cur = conn.cursor()
cur.execute("SELECT * FROM tafla;")
results = cur.fetchall()

# Loka tengingu
cur.close()
conn.close()
```