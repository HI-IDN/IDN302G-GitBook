---
description: >-
  Við kynnum flóknari SQL aðgerðir, þar á meðal tengingar (joins) og undirfyrirspurnir.
---


Hingað til höfum við aðeins skoðað SQL fyrirspurnir sem vinna á einni töflu í einu, mögulega með
einföldum undirfyrirspurnum. En hugmyndin með gagnagrunnum er að þeir eru að reyna að vera eins
„nettir“ og hægt er, og forðast endurtekningar. Þannig er einfaldara að uppfæra gögn ef það eru fáir
staðir sem hægt er að nálgast sömu upplýsingar. Þetta tryggir heilleika gagna. Oft er talað um að
reyna að koma gagnagrunni á þriðja Boyce-Codd normal form (en það er utan efniviðar þessa
námskeiðs).

> Við notum dæmi um Postgres gagnagrunni úr Game of Thrones heiminum í sýnidæmum.
> Tengiupplýsingar eru inn á Canvas.

# Almennt form SELECT skipunar

```sql
SELECT <dálkar eða útreikningur>
FROM <tafla>
WHERE <skilyrði>
GROUP BY <dálkar>
HAVING <skilyrði>
ORDER BY <dálkar>
    LIMIT <tala>
OFFSET <tala>;
```