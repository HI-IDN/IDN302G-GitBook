---
description: >-
  Venslagagnasöfn eru gagnagrunnskerfi sem byggja á venslum og mengjum. Þau eru
  notuð til að skipuleggja, geyma og sækja gögn á skilvirkan hátt með töflum.
---

# Venslagagnasöfn

Venslagagnasöfn (e. _relational databases_) eru oft notuð til að skipuleggja og geyma gögn á 
skilvirkan hátt. Þau byggja á mengjum og venslum, eins og tvístæðum venslum.

## Kostir

- Gögn eru geymd á skipulögðu formi.
- Geyma gögn á öruggan hátt.
- Hraðvirk leit að gögnum.

## Gallar

- Flókin og dýr í uppsetningu.
- Henta ekki fyrir lítið gagnamagn.
- Gögn geymd á skipulögðu formi.

## Mengi og vensl

Mengi eru oft notuð til þess að halda utan um hópa hluti sem hafa svipaða eiginleika, eins og allir
nemendur í upplýsingaverkfræði eða allir nemendur Háskóla Íslands. Mengi eru óraðað safn af hlutum,
og hlutir í mengi eru kallaðir stök. Vensl segja okkur til um samband staka milli mengja, eins og
mengi starfsmanna og mengi launa eða einstaklingar og ættingjar.

Tvístæð vensl frá $$A$$ til $$B$$ er mengið $$R$$ af röðuðum pörum þar sem fyrsta stakið af hverju röðuðu
pari kemur frá $$A$$ og það síðara frá $$B$$. Þegar $$(a,b)$$ tilheyrir $$R$$ þá er $$a$$ sagt vera með vensl
í $$b$$ með $$R$$ (skrifað $$aRb$$).

Dæmi um tvístæð vensl $$R$$ frá mengi $$A$$ til $$B$$: $$A = \{0,1,2\}$$, $$B = \{a, b\} $$. Tvístæð
vensl væru þá t.d. $$R: \{(0, a), (0, b), (1, a), (2, b)\}$$. Athugið, við þurfum ekki að hafa öll pör
af tengingum milli mengja.

Töflur eru oft notaðar til að sýna vensl. Dálkur er mengið sjálft, og hver lína í dálki er stak.
Tvístæð vensl hafa tvo dálka.

Þá væri til dæmis tvístæðu venslin: $$\{$$(Helga, Upplýsingaverkfræði), (Rögnvaldur, Tæknileg
kerfi), (Tómas, Aðgerðagreining)$$\}$$ hægt að setja fram sem:

| Kennari    | Námskeið            |
|------------|---------------------|
| Helga      | Upplýsingaverkfræði |
| Rögnvaldur | Tæknileg kerfi      |
| Tómas      | Aðgerðagreining     |

## Kostir venslalíkansins

- Einfalt og gagnsætt líkan.
- Allt er sett fram sem töflur.
- Traustar stærðfræðilegar undirstöður, eins og venslareikningur og mengi.
- Passar oftast vel við raunveruleg gögn.
- Hraðvirkar útfærslur.
