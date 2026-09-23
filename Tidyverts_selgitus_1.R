# 
# tidyverts selgitus ja näide

# tidyverts on R-i keele spetsialiseeritud pakettide ökosüsteem, mis toob kaasaegse tidyverse-i filosoofia ja tidy data (korrastatud andmete) põhimõtted aegridade analüüsi ja prognoosimisse.
# 
# Selle loojateks ja eestvedajateks on tuntud Austraalia statistik Rob J. Hyndman (Monashi Ülikool) koos oma teadustiimiga (sh Earo Wang, Mitchell O'Hara-Wild jt). tidyverts loodi selleks, et asendada ajalooline, kuid arhitektuurselt vananenud pakett forecast täielikult integreeritud ja kaasaegse tööriistakomplektiga.
# 
# 1. Miks tidyverts loodi? (Probleem vanas süsteemis)
# Varasemates R-i pakettides (nagu stats::ts või forecast) hoiti aegridasid spetsiaalsete maatriksite või vektoritena:
# 
# Puudus võimalus hoida samas tabelis mugavalt kirjeldavaid metaandmeid (nt piirkond, ettevõtte tüüp jne).
# 
# Mitme paralleelse aegrea (nt sadade või tuhandete näitajate) haldamine nõudis kohmakaid tsükleid (for, lapply).
# 
# Need objektid ei ühildunud otse populaarsete dplyr või ggplot2 funktsioonidega.
# 
# tidyverts lahendas selle, luues põhimõtte: aegrida on tavaline tabel (data.frame / tibble), millele on lisatud kindlad ajapõhised reeglid.
# 
# 2. tidyverts neli peamist alustala
# Ökosüsteem koosneb neljast tuumpaketist, mis katavad kogu aegridade töövoo:
# 
# [ Toorandmed ] 
#        │
#        ▼
#    tsibble       ──► Andmete struktureerimine (Index + Key) ja puhastamine
#        │
#        ▼
#    feasts        ──► Tunnuste eraldamine, visualiseerimine ja dekompositsioon (STL, X-13)
#        │
#        ▼
#     fable        ──► Modelleerimine ja prognoosimine (ARIMA, ETS jne)
# 
# 1. tsibble – Andmestruktuur ja korrastamine
# Pakub andmetüüpi tsibble, mis defineerib ajatelje (index) ja aegridade eraldajad (key).
# 
# Sisaldab tööriistu ajas esinevate lünkade tuvastamiseks (has_gaps()), puuduvate perioodide täitmiseks (fill_gaps()) ja sageduste muutmiseks.
# 
# 2. feasts (Feature Extraction And Statistics for Time Series) – Visualiseerimine ja diagnostika
# Vastutab aegridade analüüsi ja graafikute eest: sesoonsusgraafikud (gg_season()), autokorrelatsioon (gg_tsdisplay()).
# 
# Aegrea dekompositsioon: klassikaline, STL (Seasonal and Trend decomposition using Loess), X-11 ja SEATS.
# 
# Feature extraction: Oskab arvutada tuhandete aegridade kohta automaatselt sadu statistilisi koondtunnuseid (nt sesoonsuse tugevus, trendi järskus, spektraalne entroopia), mis teeb massandmete anomaaliate tuvastamise väga kiireks.
# 
# 3. fable – Ennustamine ja masinõpe
# Kaasaegne mantlipärija paketile forecast.
# 
# Sisaldab klassikalisi mudeleid: ARIMA(), ETS(), TSLM() (ajaseeriate lineaarne regressioon), NNETAR() (närvivõrgud), CROSTON() jne.
# 
# Tulemuseks on mudelitabel ehk mable (model table), mis võimaldab ühel real treenida mitu mudelit korraga üle tuhandete seeriate.
# 
# Prognooside väljund on fable (forecast table), kus prognoos pole mitte ainult punktväärtus, vaid täielik tõenäosusjaotus (võimaldades automaatselt arvutada suvalisi usaldusvahemikke).
# 
# 4. fabletools – Tööriistad mudelite haldamiseks
# Tegeleb mudelite hindamise, täpsusmõõdikute arvutamise (accuracy()), ristvalideerimise ja prognooside koondamisega (ansamblid).
# 
# 3. Terviklik näide: Kogu töövoog 10 reaga
# Kujutame ette olukorda, kus on vaja korraga analüüsida ja prognoosida mitut valdkonda:

if (!require("fpp3")) install.packages("fpp3")
library(fpp3) # laadib korraga tsibble, feasts, fable ja dplyr

# 1. Andmed tsibble formaadis (Austraalia turismiööd regiooniti)
tourism_data <- tourism |> 
  filter(Purpose == "Holiday")

# 2. Visuaalne analüüs ja dekompositsioon feasts abil
tourism_data |> 
  model(stl = STL(Trips)) |> 
  components() |> 
  autoplot() 

# 3. Mudelite automaatne sobitamine kõigile regioonidele korraga (fable)
models <- tourism_data |>
  model(
    ets = ETS(Trips),
    arima = ARIMA(Trips)
  )

# 4. Prognoosimine 2 aastat ette ja tulemuste kuvamine
forecasts <- models |>
  forecast(h = "2 years")

# 5. Visualiseeri kindla regiooni tulemused
forecasts |> 
  filter(Region == "Sydney") |> 
  autoplot(tourism_data)
  
  
# Kokkuvõte: Miks tidyverts on standard?
# Skaleeritavus: Sobib ideaalselt suurtele andmehulkadele (nt 50 ainevaldkonda ja tuhandeid seeriaid), sest mudeleid ja tunnuseid saab arvutada ühe käsuga üle kõigi seeriate paralleelselt.
# 
# Loetavus ja puhtus: Kood järgib %>% või |> toru loogikat ja standardseid andmetöötlusvõtteid.
# 
# Tõenäosuslik lähenemine: Prognoose ei käsitleta lihtsalt ühe arvuna, vaid jaotustena, mis teeb riskide ja kvaliteedikontrolli usalduspiiride arvutamise loomulikuks.