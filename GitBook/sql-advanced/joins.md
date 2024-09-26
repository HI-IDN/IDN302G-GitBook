---
description: >-
  Í SQL eru tengingar (joins) notuð til að sameina gögn úr fleiri en einni töflu. Hér eru 
  útskýringar á innri, vinstri, hægri, náttúrulegri, krosstengingu og hliðstæðri tengingu.
---

# Tenging töflna í SQL

Í SQL er algengt að vinna með gögn úr fleiri en einni töflu í einu. Til að sameina upplýsingar úr
mörgum töflum notum við **tengingar** (e. joins). Hér eru nokkrar af algengustu tegundum tenginga og
hvernig þær virka:

## Innri tenging - `INNER JOIN`

`INNER JOIN` skilar aðeins þeim línum þar sem samsvörun er á milli tveggja eða fleiri taflna. Ef
gögn eru til í báðum töflunum eru þau sýnd, annars ekki.

```sql
SELECT books.name AS book_name, c.name AS character_name
FROM got.characters c
         INNER JOIN got.character_books cb ON cb.character_id = c.id AND cb.pov = true
         INNER JOIN got.books ON books.id = cb.book_id
WHERE c.name = 'Jon Snow';
```

Þessi fyrirspurn notar tengingar til að draga fram upplýsingar um bækur þar sem Jon Snow er P.O.V.
karakter (persóna sem segir söguna). Fyrirspurnin sameinar gögn úr þremur töflum: `books`,
`character_books`, og `characters`.

- `SELECT books.name as book_name, c.name as character_name`:
    - Fyrirspurnin velur bókanöfn (`books.name`) og nöfn karaktera (`c.name`).
    - Karakterinn er sérstaklega merktur sem **P.O.V.** (point-of-view) karakter, og bókin er tengd
      honum.
- `FROM got.characters c`:
    - Fyrirspurnin byrjar á töflunni `characters` sem geymir upplýsingar um allar karaktera. Til
      hægðarauka þá er hún skilgreind með `c` svo fyrirspurnin sé knappari.
- `INNER JOIN got.character_books cb ON c.id = cb.character_id and cb.pov = true`:
    - `INNER JOIN` sameinar karaktertöfluna (`characters` nú kölluð `c`) við töfluna
      `character_books` þar sem `c.id` samsvarar `cb.character_id`.
    - `cb.pov = true` tryggir að aðeins bækur þar sem karakterinn er P.O.V. eru teknar með.
      > Hér útilokum við strax bækur þar sem karakterinn er ekki P.O.V. með því að nota `cb.pov 
        = true`. Þetta hefði getað verið gert í `WHERE` setningunni, en það er gagnlegt að gera  
      það strax í `INNER JOIN` til að draga úr fjölda lína sem þarf að vinna með.

- `INNER JOIN got.books ON cb.book_id = books.id`:
    - Annað `INNER JOIN` tengir töfluna `character_books` við `books` þar sem `cb.book_id`
      samsvarar `books.id`, sem táknar ID-númerið fyrir tiltekna bók.
- `WHERE c.name = 'Jon Snow'`:
    - Skilyrðið í `WHERE` tryggir að aðeins bækur þar sem **Jon Snow** er P.O.V. karakter eru
      valdar.

Útkoman verður:

| book_name            | character_name |
|----------------------|----------------|
| A Game of Thrones    | Jon Snow       
| A Clash of Kings     | Jon Snow       
| A Storm of Swords    | Jon Snow       
| A Dance with Dragons | Jon Snow       

## Vinstri tenging - `LEFT JOIN`

`LEFT JOIN` einnig kallað `LEFT OUTER JOIN`, skilar öllum línum úr vinstri töflunni (töflunni sem
er tilgreind fyrst), jafnvel þótt engin samsvörun sé í hægri töflunni. Ef engin samsvörun finnst
verður úttakið úr hægri töflunni `NULL`.

```sql
SELECT c.name, s.name as spouse, s.culture AS spouse_culture
FROM got.characters c
         LEFT JOIN got.characters s ON c.spouse = s.id
WHERE c.culture = 'Stormlands';
```

Hér fundum við alla karaktera frá _Stormlands_, ásamt nafni maka þeirra (ef til er) og menningu
maka.

- `SELECT`: Velur nafn karaktera (`c.name`), nafn maka þeirra (`s.name`), og menningu maka (`s.
  culture`) úr töflunni `got.characters`.
  > Hér verður að tilgreina `s.name` og `s.culture` sérstaklega, því allir dálkar í `s` töflunni
  > heita það sama og í `c` töflunni, svo það er nauðsynlegt að tilgreina hvaða dálka er verið
  > að biðja um. Annars fáið þið villu vegna tvíræðni (ambiguity).

- `LEFT JOIN`: sameina upplýsingar um maka úr sömu töflu (`got.characters`) og notar `c.spouse`,
  þar sem `c.spouse = s.id`. Þetta þýðir að ef maki er til staðar fyrir ákveðinn karakter, eru
  upplýsingar um makann dregnar inn, en ef enginn maki er til, eru allir `s` dálkar fylltir með
  `NULL`.

- `WHERE c.culture = 'Stormlands'`: Fyrirspurnin takmarkast við karaktera þar sem menningin þeirra
  er _Stormlands_.

Niðurstaðan verður:

| name            | spouse          | spouse_culture |
|-----------------|-----------------|----------------|
| Aemon Estermont |                 |                |
| Eldon Estermont | Sylva Santagar  | Dornish        |
| Renly Baratheon | Margaery Tyrell | Westeros       |
| Donnel Swann    |                 |                |
| Jack Musgood    |                 |                |
| Jon Connington  |                 |                |
| Alyn Estermont  |                 |                |
| Balon Swann     |                 |                |
| Lomas Estermont |                 |                |
| Criston Cole    |                 |                |

## Hægri tenging - `RIGHT JOIN`

`RIGHT JOIN` einnig kallað `RIGHT OUTER JOIN`, virkar eins og `LEFT JOIN`, nema nú eru allar
línur úr hægri töflunni sýndar, jafnvel þótt engin samsvörun sé í vinstri töflunni. Ef engin
samsvörun finnst í vinstri töflunni verður úttakið úr henni `NULL`.

```sql
SELECT books.name AS book_name, c.name AS character_name, pov
FROM got.characters c
         INNER JOIN got.character_books cb ON cb.character_id = c.id AND c.name = 'Jon Snow'
         RIGHT JOIN got.books ON books.id = cb.book_id;
```

Fyrirspurnin skilar lista af öllum bókum og tengir þær við _Jon Snow_ ef hann er til staðar sem
karakter. Ef engin tenging er til (þ.e. _Jon Snow_ kemur ekki fyrir í bókinni), þá verða dálkarnir
`character_name` og `pov` NULL.

- `INNER JOIN` með `got.character_books`: Þetta skilar aðeins þeim niðurstöðum þar sem _Jon Snow_ er
  karakter í tiltekinni bók. Þessi tenging takmarkar upplýsingar úr `got.character_books` við _Jon
  Snow_.
- `RIGHT JOIN`: Þetta tryggir að allar bækur úr `got.books` séu í niðurstöðunum, jafnvel þótt þær
  tengist ekki karakterum eins og _Jon Snow_. Ef bókin er ekki tengd við _Jon Snow_, munu dálkarnir
  fyrir nafn karaktera og POV vera NULL.

Niðurstaðan verður:

| book_name                      | character_Name | pov   |
|--------------------------------|----------------|-------|
| A Game of Thrones              | Jon Snow       | true  |
| A Clash of Kings               | Jon Snow       | true  |
| A Storm of Swords              | Jon Snow       | true  |
| The Hedge Knight               |                |       |
| A Feast for Crows              | Jon Snow       | false |
| The Sworn Sword                |                |       |
| The Mystery Knight             |                |       |
| A Dance with Dragons           | Jon Snow       | true  |
| The Princess and the Queen     |                |       |
| The Rogue Prince               |                |       |
| The World of Ice and Fire      |                |       |
| A Knight of the Seven Kingdoms |                |       |

> Athugið að `RIGHT JOIN` er mjög sjaldan notað, víðtæk venja er að vinna SQL fyrirspurnir frá
> vinstri til hægri, og því er eðlilegra að nota `LEFT JOIN` í stað `RIGHT JOIN` og víxla
> frekar töflunum. Það eru þó til tilvik þegar `RIGHT JOIN` er skynsamlegt.

## Náttúruleg tenging - `NATURAL JOIN`

`NATURAL JOIN` sameinar tvær töflur á sjálfgefnum dálkum með sama nafni, og þarf því ekki að
tilgreina á hvaða dálkum tengingin er byggð. Þetta getur sparað tíma, en getur líka verið óskýrt ef
dálkar með sama nafni tákna ekki sama hlutinn.

```sql 
SELECT books.name
FROM got.books
         NATURAL JOIN got.character_books
         NATURAL JOIN got.characters
```

Fyrirspurnin reynir að tengja allar bækur við karaktera með tengitöflunni `character_books`. Þar
sem `books` og `characters` hafa bæði dálkinn `id` og `name` þá gengur þetta ekki upp.

Ef við hefðum skilgreint töfluna `books` með `book_id` og `book_name` í staðinn fyrir `id` og
`name` og sambærilega skilgreint `characters` með `character_id` og `character_name` þá myndi
þetta virka.

> Í praxís er þetta mjög hættulegt og er mikið ráðlagt að nota ekki `NATURAL JOIN` vegna þess að
> það er óskýrt hvaða dálkar eru notuð í tengingunni. Ef svo óheppilega vill til að ólíkar
> töflur deili saman nafni þá getur það valdið óvæntum niðurstöðum.

## Krosstenging - `CROSS JOIN`

`CROSS JOIN` skilar kartesísku margfeldi af línunum í töflunum, sem þýðir að hver lína úr einni
töflu er tengd við allar línur í hinni töflunni. 
> **Athugið**: `CROSS JOIN` getur myndað mjög stórar úttakstaflur ef töflurnar eru stórar. Sem 
> getur komið niður á vinnslutíma og minni.

`CROSS JOIN` er gagnlegt þegar þú vilt fá allar mögulegar samsetningar tveggja gagnasetta. Í
flóknari fyrirspurnum er hægt að nota það til að para gögn við alla mögulega valkosti til að kalla á
föll eða framkvæma útreikninga fyrir hverja samsetningu. Oftast notum við `INNER JOIN` eða
`LEFT JOIN` þegar við viljum tengja gögn með skilyrðum, en stundum viljum við fá öll möguleg tengsl
á milli gagnasetta, sem er nákvæmlega það sem `CROSS JOIN` gerir.

```sql
SELECT books.name, location_type
FROM got.books
         CROSS JOIN (SELECT UNNEST(enum_range(NULL::location_type)) AS location_type) tbl
WHERE books.id = 1
```

Hér er hver tegund staðsetningar parað við bók með `id = 1`, jafnvel þó engin bein tenging sé á
milli bóka og staðsetningartegunda.

## Hliðstæð tenging - `LATERAL JOIN`

`LATERAL JOIN` gerir kleift að tengja töflur með fyrirspurn sem fer yfir hverja línu úr vinstri
töflu. Þetta er gagnlegt þegar útreikningar í hægri töflu þurfa að nota gögn úr hverri línu í
vinstri töflu.

**TODO: Setja dæmi hér**

