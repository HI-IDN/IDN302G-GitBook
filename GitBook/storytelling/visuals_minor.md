---
description: >-
  Sérhæfð gröf geta verið gagnleg í réttum aðstæðum, en þau ætti aðeins að nota sparlega þar sem þau 
  geta flækt skilaboðin og verið erfiðari í skilningi ef þau eru notuð rangt.
---

# Minna þekktar myndrænar framsetningar

Á meðan venjuleg gröf eins og súluritin, línurit og dreifirit eru algengust í gagnamiðlun, þá eru
til fleiri sérhæfð gröf sem er mikilvægt að nota rétt. Þessi gröf geta verið mjög gagnleg í ákveðnum
aðstæðum, en ef þau eru notuð í röngum tilgangi geta þau flækt skilaboðin og verið erfiðari fyrir
lesendur að skilja. Því er mikilvægt að nota þessi minni notuðu gröf sparlega og einungis þar sem
þau bæta við gagnamiðlunina.

## Kassarit - Box Plot

Kassarit eru oft talin vera uppáhalds graf vísindamanna vegna þess hve mikið magn upplýsinga þau
geta sýnt í einni mynd. Þau eru mjög gagnleg til að sýna dreifingu gagna og draga fram mikilvæg
tölfræðileg atriði eins og miðgildi, lágmarks- og hámarksgildi, og hvernig gögn dreifast í
fjórðungum. Þrátt fyrir að vera mjög lýsandi fyrir sérfræðinga getur almennur markhópur fundist þau
óskiljanleg og því ætti að nota þau með varúð þegar aðrir en vísindamenn eru áhorfendur.

####  Hvað er kassarit?

Kassarit—stundum kallað kassar og strokur (e. box and whisker plot)—er mynd sem sýnir ýmsar
samantektartölur í einni sýn. Kassarit sýnir:

- **Lágmarksgildi**: Minnsta gildi í gagnasafni
- **Hámarksgildi**: Hæsta gildi í gagnasafni
- **Miðgildi**: Miðjan á gögnum, eða 50. prósentan
- **Neðri fjórðungur**: Miðgildi neðri helmings gagnasafnsins, eða 25. prósentan
- **Efri fjórðungur**: Miðgildi efri helmings gagnasafnsins, eða 75. prósentan

Kassinn sjálfur sýnir fjórðungana, þar sem línan í miðjum kassanum táknar miðgildið. Strokurnar
(whiskers) sýna hámarks- og lágmarksgildi, en ef það eru útlagar (e. outliers), eru þeir sýndir sem
sérstakir punktar fyrir utan strokurnar.

####  Hvenær á að nota kassarit?

Kassarit eru gagnleg þegar þú vilt bera saman dreifingu margra gagnasafna hlið við hlið, t.d.
samanburð á einkunnum eða launadreifingu. Þau eru einnig hentug til að greina frávik og sjá hvort
dreifing er breið eða þétt.

####  Hvenær á að sleppa kassaritum?

Ef markhópurinn er ekki vel þjálfaður í tölfræði getur verið betra að nota einfaldari gröf. Kassarit
sýna ekki dreifingu eins vel og dreifirit eða stuðlarit, sem getur falið mikilvægar upplýsingar.

####  Afbrigði af kassariti

- **Breytibreið kassarit - variable width boxplot**: Kassar sýna stærð hópanna.
- **Kassarit með skörðum - notched boxplot**: Sýna öryggisbil í kringum miðgildi.
- **Fiðlurit - violin plot**: Sameina kassarit og dreifilínurit til að sýna dreifingu nákvæmlega.

Nánar um [Box Plot](https://www.storytellingwithdata.com/blog/what-is-a-boxplot) á *Storytelling
with data.*

## Skífurit - Pie Chart

Skífurit (eða kökurit) eru ein algengasta gerð gagnaframsetningar, en einnig ein sú mest
gagnrýnda og misnotaða. Ástæðan er einföld: augað á erfitt með að greina hlutföll á skífuritum,
sérstaklega þegar sneiðar eru svipaðar að stærð. Þrátt fyrir þetta geta skífurit verið nytsamleg í
ákveðnum tilvikum, sérstaklega þegar markmiðið er að sýna hlutfallslega skiptingu á einfaldan hátt.

####  Hvað er skífurit?

Skífurit sýnir samband hluta og heildar með því að skipta gögnum niður í sneiðar sem samsvara
hlutföllum hverrar breytu af heildinni. Allar sneiðar samanlagt mynda 100%. Þó fólk laðist að
hringforminu, sem táknar heildina, er erfitt fyrir okkur að bera saman sneiðar, sérstaklega þegar
þær eru nálægt því að vera jafnstórar.

####  Hvenær á að nota skífurit?

Skífurit hentar vel þegar þú vilt sýna hlutfall einstakra flokka í samanburði við heildina. Það er
hentugt til að sýna að einn hluti af gögnunum sé tiltölulega stærri eða minni en aðrir.

####  Hvenær á ekki að nota skífurit?

Þegar gögn þurfa nákvæman samanburð eða eru fleiri en fáir flokkar, ætti að forðast skífurit. Augað
á erfitt með að meta hlutföll af heild þegar sneiðar eru líkar að stærð. Í slíkum tilvikum er betra
að nota stöplarit eða línurit.

####  Hönnun ráðleggingar fyrir skífurit

- Forðastu 3D og sprengiskífurit (exploding pie chart) sem rugla lestur gagna.
- Notaðu ekki of margar sneiðar; samræmdu smærri flokka í „Allir aðrir.“
- Raðaðu sneiðunum eftir stærð til að auðvelda lestur.
- Settu merkingar beint á sneiðarnar í stað þess að nota skýringarlista.

![Fjöldi sögumanna eftir bókum í GOT sem skífurit og stöplarit](figures/piechart_vs_barchart.png)

Í þessum myndum er fjöldi sögupersóna með sjónarhorn (POV characters) eftir bók í _Game of Thrones_
sýndur bæði sem stöplarit og sem skífurit. Stöplarit býður upp á skýran samanburð þar sem auðvelt er
að sjá nákvæman fjölda fyrir hverja bók, sem er sérstaklega gagnlegt þegar áherslan er á nákvæmar
tölur. Skífurit dregur fram hlutfallslegan samanburð og sýnir hversu mikið hver flokkur leggur til
heildarinnar, en getur verið óljóst þegar skífurnar eru svipaðar að stærð. Þó stöplarit taki meira
pláss og sé betra til nákvæms samanburðar, getur skífurit verið meira sjónrænt aðlaðandi þegar
hlutföll skipta máli.

Nánar um [Pie Chart](http://www.storytellingwithdata.com/blog/2020/5/14/what-is-a-pie-chart) á
*Storytelling with data.*

## Flatarmyndrit - Area Graph

Nánar um [Area Graph](https://www.storytellingwithdata.com/blog/2020/4/9/what-is-an-area-graph) á
*Storytelling with data.*

## Kúlurit - Bubble Chart

Nánar um [Bubble Chart](https://www.storytellingwithdata.com/blog/2021/5/11/what-is-a-bubble-chart)
á *Storytelling with data.*

## Skotmarkarit - Bullet Graph

Nánar um [Bullet Graph](https://www.storytellingwithdata.com/blog/what-is-a-bullet-graph) á
*Storytelling with data.*

## Punktarit - Dot Plot

Nánar um [Dot Plot](http://www.storytellingwithdata.com/blog/2020/12/9/what-is-a-dot-plot) á
*Storytelling with data.*

## Flæðirit - Flowchart

Nánar um [Flowchart](https://www.storytellingwithdata.com/blog/what-is-a-flowchart) á *Storytelling
with data.*

## Sankey-rit - Sankey Diagram

Nánar um [Sankey Diagram](https://www.storytellingwithdata.com/blog/what-is-a-sankey-diagram) á
*Storytelling with data.*

## Köngulórit - Spider Chart

Nánar um [Spider Chart](https://www.storytellingwithdata.com/blog/2021/8/31/what-is-a-spider-chart)
á *Storytelling with data.*

## Flatarmálsrit - Square Area Chart

Nánar um [Square Area Chart](https://www.storytellingwithdata.com/blog/what-is-a-square-area-chart)
á *Storytelling with data.*

## Trémynd - Treemap

Nánar um [Treemap](https://www.storytellingwithdata.com/blog/what-is-a-treemap) á *Storytelling with
data.*

## Einingarit - Unit Chart

Nánar um [Unit Chart](https://www.storytellingwithdata.com/blog/what-is-a-unit-chart) á
*Storytelling with data.