---
description: >-
  SQL er forritunarmál hannað til að „tala við“ venslagagnasöfn og er oft borið
  fram sem SQL (Structured Query Language) eða Sequl (Structured English Query
  Language)
---

# SQL

SQL var hannað af IBM í kringum 1970 og byggir á fræðilegu líkani um vensl með smá útvíkkun. SQL var
fyrst tekið í notkun í tölvum um 1980 og er sérstaklega hannað til að vinna með gagnagrunna sem eru
samsettir úr töflum.

SQL inniheldur margar gerðir skipana, þar sem ein aðalskipunin er `SELECT`. Aðrar skipanir í
SQL vinna með töflur og gögn, til dæmis til að búa til, breyta og eyða töflum, setja inn, breyta og
eyða gögnum, og breyta skipulagi gagnanna. SQL fyrirspurnir tilgreina hvaða gögn við viljum nálgast,
en ekki hvernig þau eru fundin, sem gerir SQL mjög öflugt og sveigjanlegt.

> **Athugasemd:** Í SQL er almennt skrifað frátekin orð (t.d. `SELECT`, `FROM`, `WHERE`) í hástöfum,
> en nöfn á töflum og dálkum (t.d. `employee`, `name`) með lágstöfum. Fyrir lengri skipanir er algengt
> að setja hvert frátekið orð á nýja línu til að auka læsileika.

## SELECT skipun

`SELECT` skipunin er notuð til að ná í innihald tafla. Hér eru tvö einföld dæmi:

```sql
SELECT *
FROM patient_list;
SELECT patient_name
FROM patient_list; 
```

Munurinn á þessum tveimur fyrirspurnum er að sú fyrri nær í öll gögnin úr töflunni `patient_list`, á
meðan sú seinni nær aðeins í gögnin úr dálkinum `patient_name`.

Útkoman úr fyrirspurninni getur birtist asnalega þegar gögnin eru sýnd í einföldu formi. Til dæmis:

```
Patient_1|101|10|M|40 
Patient_2|102|50|M|50 
```

Við getum látið *SQLite* setja úttakið upp í dálka til að fá skýrari framsetningu með því að nota
eftirfarandi skipanir:

```bash
-- Set display mode to columns 
.mode columns

-- Enable headers in the output 
.headers on 

-- Show all tables in the database
.tables <- til að sjá töflurnar sem eru í boði

-- exit the program
.exit
```

Þessar stillingar munu skipuleggja úttakið í dálka og sýna nöfn dálkanna, sem gerir gögnin
aðgengilegri og auðveldari í lestri. Prófaðu núna aftur að keyra fyrirspurnina að ofan.

## Röð úttaks - ORDER BY

Úttakið úr fyrirspurnum kemur oft í „einhverri röð“, líklega eftir því hvenær gögnin voru sett inn.
Línurnar í úttakinu eru stök í mengi, og stök í mengi hafa enga sérstaka röð. Til að stjórna röð
úttaksins, notum við `ORDER BY`. Prófið eftirfarandi:

```sql
-- Select and sort by Patient_Age 
SELECT Patient_Name, Patient_Age
FROM Patient_list
ORDER BY Patient_Age; 
```

Sjálfgefið er að `ORDER BY` raðar í hækkandi röð (e. _ascending_). Til að raða í lækkandi röð (e.
_descending_), getum við notað `DESC`, og til að halda áfram í hækkandi röð, getum við notað `ASC`.
Við getum einnig raðað eftir mörgum dálkum:

```sql
SELECT *
FROM Patient_list
ORDER BY Patient_Age DESC, Patient_DaysOnWaitingList; 
```

## Takmarka/sleppa línum með LIMIT og OFFSET

Stundum viljum við ekki fá allar línur úr fyrirspurninni heldur aðeins hluta af þeim. Við getum
takmarkað fjölda lína í úttakinu með `LIMIT` skipuninni. Hér er dæmi um hvernig á að velja aðeins
þrjár efstu línurnar:

```sql
-- Select the top 3 rows, sorted by Age in descending order
SELECT *
FROM Patient_list
ORDER BY Age DESC LIMIT 3; 
```

Ef við viljum sleppa fyrstu línunum og velja næstu línur, getum við bætt við `OFFSET` skipuninni
ásamt `LIMIT`. Hér er dæmi þar sem við sleppum fyrstu tveimur línunum og veljum næstu þrjár:

```sql
-- Skip the first 2 rows and select the next 3 
SELECT *
FROM Patient_list
ORDER BY Age DESC LIMIT 3
OFFSET 2; 
```

## Æfing

Prófið að finna SQL fyrirspurnina sem:&#x20;

* Sýna aðgerðardagsetningar eftir hækkandi röð , ID sjúklings í lækkandi
* Sýna upplýsingar um lengstu aðgerðina
* Sýna nöfn og biðtíma þeirra sem hafa beðið lengst
* Sýna biðtíma sjúkling með fjórða lengsta biðtímann

## WHERE skilyrði

Við notum `WHERE` þegar við viljum að ákveðnir dálkar í töflu uppfylli einhver skilyrði. Grunnformið
fyrir `WHERE` skipanir er:

```sql
SELECT column1, column2, ...FROM table_name
WHERE condition; 
```

Til að sýna sjúklinga sem eru 40 ára og eldri:&#x20;

```sql
SELECT *
FROM Patient_list
WHERE Patient_Age >= 40; 
```

Til að sýna sjúklinga sem eru konur:

```sql
SELECT *
FROM Patient_list
WHERE Patient_Sex = 'F'; 
```

Eða með notkun `<>` til að velja sjúklinga sem eru ekki karlar:

```sql
SELECT *
FROM Patient_list
WHERE Patient_Sex <> 'M'; 
```

### AND, OR og NOT skilyrði

Með `WHERE` skilyrðum er hægt að nota einn eða fleiri mengjavirka eins og `AND`, `OR`, og `NOT` til
að sía gögn út frá fleiri en einu skilyrði:&#x20;

* `AND`er satt ef öll skilyrði eru uppfyllt.&#x20;
* `OR` er satt ef eitt eða fleiri skilyrði eru uppfyllt.&#x20;
* `NOT` birtir gögn þar sem skilyrðið er ekki satt (öfugt sanngildi).

Sýnið alla sjúklinga sem eru á aldrinum 40 og 60 ára:&#x20;

```sql
SELECT *
FROM Patient_list
WHERE Patient_Age >= 40
  AND Patient_Age <= 60;
```

Hér má einnig nota `BETWEEN` skilyrði sem jafngilt við `>= 40 AND <= 60`.

### Útreikningar í skilyrðum

Við getum notað útreikninga í skilyrðum. Til dæmis, ef við viljum finna konur sem hafa beðið lengur
en 4 vikur á biðlista, getum við notað eftirfarandi fyrirspurn:

```sql
SELECT *
FROM Patient_list
WHERE Patient_Sex = 'F'
  AND Patient_DaysOnWaitingList / 7 > 4;
```

Ef bæði tölurnar eru heiltölur (þ.e. af taginu `INT`), þá verður útkoman sjálfkrafa heiltala vegna
sjálfgefinna reglna um ummyndun í SQL. Til að gera samanburðinn með fleytitölum (
t.d. `FLOAT`, `DECIMAL` eða `REAL`) eða þarf önnur talan að vera fleytitala, til dæmis með því að
deila með `7.0` í stað `7`.

### Forgangur mengjavirkja

Virkjar eins og `AND`, `OR` og `NOT` hafa mismunandi forgang. Til dæmis, í
útreikningnum `4 + 5 * 3`, hefur margföldun (`*`) hærri forgang en samlagning (`+`), sem leiðir til
niðurstöðunnar 19. Notum sviga til að fá rétta útkomu ef þörf krefur:

```sql
SELECT 4 + 5 * 3   AS column1, -- Result is 19 
       (4 + 5) * 3 AS column2; -- Result is 27 
```

Athugið, hér gáfum við útreiknaða dálkinum okkar ,,nafn'' með `AS`.

## Reglulegar segðir með LIKE

`LIKE` skipunin er notuð til að leita að mynstri í strengjum með hjálp algildisstafa (e. wildcards).
Algildisstafir eins og `%` og `_` leyfa okkur að framkvæma leitir með mynstrum í strengjum.

Ef við viljum finna hvort orð í dálki innihaldi ákveðið mynstur, eins og staf eða hluta af orði,
notum við táknið `%`, sem parast á móti 0 eða fleiri stöfum í streng:

```sql
-- Find rows where the column contains 'word' anywhere in the string 
SELECT col
FROM tbl
WHERE col LIKE '%word%';
```

Ef við viljum finna orð af ákveðinni lengd, notum við `_` (undirstrik) þar sem hvert undirstrik
táknar einn bókstaf. Til dæmis, ef við viljum finna orð með þremur stöfum:

```sql
-- Find rows where the column contains exactly three characters 
SELECT col
FROM tbl
WHERE col LIKE '___'; 
```

Ef við viljum finna gildi sem hafa X sem annan staf og enda á Y, notum við mynstur með `_` og `%`:

```sql
-- Find rows where the second character is 'X' and ends with 'Y' 
SELECT col
FROM tbl
WHERE col LIKE '_X%Y'; 
```

### REPLACE fallið

`REPLACE` fallið getur verið notað til að skipta út ákveðnum strengjum í gögnunum. Fallið tekur þrjú
inntök: `REPLACE(strengur, samsvörun, skipta_út)`.

### Hástafir og lágstafir

`LIKE` gerir ekki greinarmun á hástöfum og lágstöfum í _SQLite_. Þú getur breytt þessari hegðun með
því að nota skipunina:

```sql
-- Enable case sensitivity for LIKE in SQLite 
PRAGMA
case_sensitive_like = ON; 
```

`PRAGMA` er óstöðluð skipun sem hægt er að nota til að breyta hegðun _SQLite_ á ýmsa vegu.

## Tengsl við strjála stærðfræði

Hvað þýðir þetta allt saman og hvernig tengist þetta undanfarið námsefni? SQL og strjál stærðfræði
hafa ýmis tengsl sem við getum skoðað í samhengi við fyrirspurnir og mengjafræði.

SQL skipunin `SELECT x FROM A WHERE P(X);`þýðir að velja línur úr töflunni $$A$$ sem uppfylla
skilyrðið $$P(X)$$. Í strjálli stærðfræði er þetta jafngilt menginu: $$\{x \in A \mid P(x) \}$$ sem
þýðir „mengi þeirra staka $$x$$ úr $$A$$ sem uppfylla yrðinguna $$P(X)$$.“

Hér eru nokkur lykilhugtök og tengingar við strjála stærðfræði:

* **Mengi**: Tafla er mengi af línum.&#x20;
* **Vensl**: Tafla skilgreinir vensl milli staka.
* **Yrðingar**: Veljum úttakið með yrðingu (`WHERE`skilyrði).&#x20;
* **Reglulegar segðir**: Yrðingar geta notað reglulegar segðir (`LIKE`) til að sía gögn.&#x20;

### Æfing

Hér eru dæmi til að æfa tengingu SQL við strjála stærðfræði:

* Sýnið alla sjúklinga sem hafa töluna 5 í nafni sínu og hafa beðið yfir 50 daga:
* Sýnið alla sjúklinga sem uppfylla eftirfarandi skilyrði:
    * Hafa tölunina einn í nafninu sínu,
    * Eru konur (`patient_sex = 'F'`),
    * Hafa beðið í að minnsta kosti 30 daga,
    * Eru yfir 50 ára.
* Finnið aðgerð sem er með `m` sem þriðja staf og `r` sem sjötta staf:

## Setja inn gögn í töflur með INSERT

Til að setja inn gögn í töflur í SQL notum við `INSERT` skipunina. Það eru tvær aðalleiðir til að
nota `INSERT`: með því að tilgreina dálka sem við viljum setja gögn inn í, eða með því að setja inn
gögn í alla dálka töflunnar ef öll gildi eru tilgreind.

### Notkun INSERT með dálkalista

Þegar við viljum setja inn gögn í ákveðna dálka í töflunni, tilgreinum við dálkalistann
í `INSERT INTO` skipuninni. Hér er dæmi:

```sql
 -- Insert data into specific columns of the operators table 
INSERT INTO operators (opID, opName, opSSN, opAge, opYearInit)
VALUES (1, 'Anna', '0101013010', 45, 2010); 
```

### Notkun INSERT án dálkalista

Ef öll gildi eru skilgreind fyrir alla dálka í töflunni, getum við sleppt því að tilgreina
dálkalistann og setja inn gögn beint. Þessi aðferð er aðeins nothæf ef gildi eru til staðar fyrir
alla dálka í réttri röð:

```sql
-- Insert data into all columns of the operators table 
INSERT INTO operators
VALUES (2, 'Hannes', '0102013010', 55, 2011);
```

Ef ekki eru öll gildi skilgreind í `INSERT` skipuninni, mun það valda villu (og gögnin verða þá ekki
sett inn) nema dálkurinn hafi sjálfgefna gildið (`DEFAULT`) eða leyfir `NULL`.&#x20;

Til að forðast villur er gott að tilgreina dálkalistann sérstaklega ef ekki eru öll gildi til
staðar.&#x20;

## Uppfæra gagnagrunn með UPDATE

`UPDATE` skipunin er notuð til að breyta gögnum í töflum. Hún gerir kleift að uppfæra gildi í einum
eða fleiri dálkum fyrir línur sem uppfylla tiltekin skilyrði.

Grunnformið fyrir `UPDATE` skipunina er:

```sql
UPDATE table_name
SET column1 = value1,
    column2 = value2, ...WHERE condition;
```

Ef við viljum uppfæra aldur starfsmanns með tiltekið auðkenni (`opID`), gætum við notað eftirfarandi
skipun:

```sql
-- Update the age of an operator with a specific opID 
UPDATE operators
SET opAge = 45
WHERE opID = 1;
```

Í þessu dæmi er aldur (`opAge`) uppfærður í 45 fyrir starfsmann með `opID` 1. Ef `WHERE` skilyrðið
er _ekki_ tilgreint, verður uppfært í öllum línum í töflunni, sem getur leitt til óæskilegra
breytinga.

## Að eyða gögnum úr töflum

Til að eyða gögnum úr töflum í SQL notum við `DELETE` skipunina. `DELETE` gerir kleift að fjarlægja
eina eða fleiri línur úr töflu byggt á skilyrðum sem við tilgreinum með `WHERE` klausu. Ef við
viljum eyða töflunni algjörlega, þá getum við notað `DROP` skipunina.

Grunnformið fyrir `DELETE` skipunina er:

```sql
DELETE
FROM table_name
WHERE condition; 
```

Ef `WHERE` skilyrðið er ekki tilgreint, mun `DELETE` skipunin eyða öllum línum í töflunni, en taflan
sjálf verður áfram til.

Til dæmis, ef við viljum eyða starfsmanni með tiltekið auðkenni (`opID`), notum við eftirfarandi
skipun:

```sql
-- Delete an operator with a specific opID 
DELETE
FROM operators
WHERE opID = 1; 
```

Í þessu dæmi verður aðeins lína þar sem `opID` er 1 eytt úr töflunni `operators`.

### Eyða öllum línum með DELETE eða TRUNCATE

Ef þú vilt eyða öllum línum í töflunni án þess að eyða töflunni sjálfri, getur þú keyrt `DELETE`
án `WHERE` skilyrðisins:

```sql
-- Delete all rows from the operators table 
DELETE
FROM operators;
```

Í sumum öðrum gagnagrunnskerfum, eins og _PostgreSQL_, er hægt að nota `TRUNCATE` skipunina til að
eyða öllum línum í töflunni. `TRUNCATE` er oft hraðvirkari en `DELETE` vegna þess að hún fjarlægir
gögnin án þess að rekja hverja eyðingu fyrir sig.

```sql
-- Truncate the operators table, removing all rows 
TRUNCATE TABLE operators;
```

`TRUNCATE` hefur einnig þann kost að endurstilla sjálfvirka númerara (`AUTO_INCREMENT`) í sumum
gagnagrunnum.

### Eyða töflu með DROP

Ef þú vilt eyða töflu sjálfri og öllum gögnum sem hún inniheldur, notum við `DROP TABLE` skipunina:

```sql
-- Drop the operators table, removing the table and all its data 
DROP TABLE operators;
```

`DROP TABLE` eyðir töflunni ásamt öllum gögnum sem hún inniheldur. Athugaðu að þetta er óafturkræft
og taflan verður alveg fjarlægð úr gagnagrunninum.

### Athugasemdir

* Notkun `WHERE` er mikilvægt til að forðast óæskilegar eyðingar á gögnum.&#x20;
* Ef taflan hefur tengdar færslur í öðrum töflum (með `FOREIGN KEY`), gæti `DELETE` skipunin haft
  áhrif á þær, sérstaklega ef `ON DELETE CASCADE` er skilgreint.&#x20;

## Töflur

Töflur eru grundvallareiningar í gagnagrunnum, þar sem gögnin eru geymd í röðum og dálkum. Hver
tafla inniheldur ákveðna gerð gagna og er skipulögð þannig að hver röð (e. _row_) samsvarar einu
staki, og hver dálkur (e. _column_) samsvarar tilteknum eiginleikum gagna. Dálkar skilgreina hvaða
tegund gagna er geymd, til dæmis heiltölur, texti eða tvíundargögn.

### Búa til töflu

Til að búa til töflu notum við `CREATE TABLE` skipunina. Hér er dæmi um hvernig á að búa til töflu
sem heitir `operators`:

```sql
CREATE TABLE operators
(
    opID       INTEGER,
    opName     CHAR(30),
    opSSN      CHAR(10),
    opAge      INTEGER,
    opYearInit INTEGER
); 
```

Í þessu dæmi er taflan `operators` búin til með fimm dálkum:&#x20;

* `opID`: Heiltala (`INTEGER`) sem gæti verið notuð sem auðkenni.&#x20;
* `opName`: Stafastrengur (`CHAR(30)`) sem geymir nafn.&#x20;
* `opSSN`: Stafastrengur (`CHAR(10)`) sem geymir kennitölu.&#x20;
* `opAge`: Heiltala (`INTEGER`) fyrir aldur.
* `opYearInit`: Heiltala (`INTEGER`) fyrir ártal upphafs.&#x20;

### Gerðir dálka

Í _SQLite_ eru til ýmsar tegundir dálka sem skilgreina hvernig gögn eru geymd í gagnagrunninum. Hér
eru nokkrar algengar gerðir:

* `INTEGER`: Heiltölur.&#x20;
* `REAL`: Fleytitölur.&#x20;
* `TEXT`: Stafir og strengir.
* `BLOB`: Tvíundargögn (Binary Large Object).&#x20;

Frekari upplýsingar um dálkagerðir í SQLite má finna
á: [https://www.sqlite.org/datatype3.html](https://www.sqlite.org/datatype3.html).

### Að breyta töflum

SQLite styður nokkrar breytingar á töflum með `ALTER TABLE` skipuninni.

#### Bæta við dálki

Þú getur bætt við nýjum dálki með `ALTER TABLE ... ADD COLUMN`:

```sql
ALTER TABLE operators
    ADD COLUMN opAddress TEXT; 
```

#### Eyða dálki

Þú getur eytt dálki með `ALTER TABLE ... DROP COLUMN`:

```sql
ALTER TABLE operators DROP COLUMN opAddress; 
```

#### Endurnefna dálk

Þú getur endurnefnt dálk með því að nota `ALTER TABLE ... RENAME COLUMN`:

```sql
ALTER TABLE operators RENAME COLUMN opName TO operatorName; 
```

Takmarkanir á breytingum á dálkagerð

Það er ekki hægt að breyta gerð dálks beint með `ALTER TABLE` í SQLite. Til að breyta gerð dálks
þarf að fylgja eftirfarandi ferli:

* Búa nýjan dálk með réttu dálkagerðinni.&#x20;
* Afrita gögnin úr gamla dálkinn yfir í nýja dálkinn með `UPDATE`.
* Eyða gamla dálkinn.&#x20;
* Endurnefna nýju dálkinn með gamla nafninu.&#x20;

## Innflutningur gagna

Til að setja inn stór gagnasöfn í töflur í _SQLite_ er hægt að nota `.import` skipunina. Þessi
aðferð gerir það auðveldara að flytja inn gögn úr CSV skjölum í stað þess að nota `INSERT` skipanir
trekk í trekk.

`.import` skipunin í _SQLite_ les inn gögn úr tiltekinni skrá og býr til töflu með þeim gögnum.
Dæmi:

```bash
-- Import data from skra.csv into a table called Nafn 
.import skra.csv Nafn 
```

Það er mikilvægt að passa að nota rétt aðskilnaðartákn. Sjálfgefið er aðskilnaðartáknið `|`, en það
er hægt að breyta því með `.separator` skipuninni:

```bash
-- Set the separator to semicolon 
.separator ;
-- Import data with the new separator 
.import skra.csv Nafn 
```

## Útflutningur gagna

_SQLite_ gerir einnig auðvelt að flytja út gögn með notkun á `.output` og öðrum skipunum til að
skrifa gögn út í skrár, til dæmis á CSV formi.

### Útflutningur á CSV skjali

Til að flytja út gögn á CSV formi, notum við eftirfarandi skipanir:

```
-- Include headers in the output 
.headers on
-- Set the mode to CSV 
.mode csv
-- Set the separator to semicolon 
.separator ;
-- Specify the output file 
.output test.csv
-- Export data from the operators table 
SELECT * FROM operators;
-- Stop writing to the output 
file .output 
```

`.output` skipunin stýrir hvert úttak fyrirspurnar fer, og í þessu tilviki skrifar gögnin út í
skrána `test.csv`.

## Skipanaskrár

Algengt er að búa til skrár sem innihalda SQL skipanir til að skilgreina og setja upp töflur.&#x20;

### Innlestur SQL skipana

`.read` skipunin gerir það mögulegt að keyra allar skipanir úr tiltekinni skrá:

```
-- Read and execute commands from a file 
.read skipanir.sql 
```

### Útflutningur SQL skipana

Til að búa til skrá með öllum skipunum sem skilgreina núverandi gagnagrunn, notum við `.dump`
skipunina:

```
-- Dump all SQL commands to a file 
.dump > skipanir.sql
-- Export commands for a specific table, for example, operators 
.dump operators 
```

`.dump` skipunin skrifar SQL skipanir sem endurskapa núverandi töflur og gögn, sem er gagnlegt fyrir
afritun og flutning gagnagrunns.

### Æfing

Þessi æfing hjálpar ykkur að skilja hvernig á að flytja inn og út gögn í SQLite, og hvernig á að
vinna með gögnin til að sía þau og skoða í öðrum forritum.

* Náið í
  skránna [lung_cancer_number_of_male_deaths.csv](../../data/lung_cancer_number_of_male_deaths.csv).
* Flytjið skránna inn í _SQLite_ með því að nota `.import` skipunina. Passið að stilla rétt
  aðskilnaðartákn ef þörf krefur með `.separator` skipuninni.
* Síðan síum við gögnin þannig að einungis gögn frá Króatíu og Íslandi eru valin.
* Setjið innihald síuðu töflunnar í nýja CSV skrá.
* Opnið CSV skránna og skoðið innihaldið, til dæmis með Excel eða öðru forriti sem styður CSV skjöl.
