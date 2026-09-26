# 
# Statistiliste näitajate usaldusväärsuse kontrollimine
# 
# Kullo Raiend 20.08.2026
# 

# 1. Vajadusel paigalda ja laadi paketid
if (!require("tidyverse")) install.packages("tidyverse")
library(tidyverse)

if (!require("tsibble")) install.packages("tsibble")
if (!require("fable")) install.packages("fable")
if (!require("fable.prophet")) install.packages("fable.prophet")
if (!require("fabletools")) install.packages("fabletools")
if (!require("feasts")) install.packages("feasts")
if (!require("ggtime")) install.packages("ggtime")

library(tsibble)
library(fable)
library(fable.prophet)
library(fabletools)
library(feasts)
# tidyverts ökosüsteemi uuenduses (alates fabletools versioonist 0.6.0) eraldati kõik aegridade ja prognooside 
# visualiseerimisfunktsioonid eraldi uude spetsiaalsesse paketti nimega ggtime.
library(ggtime)    # <-- Uus pakett kõigi autoplot() ja graafikufunktsioonide jaoks 

if (!require("openxlsx")) install.packages("openxlsx")
library(openxlsx)

# Loe andmekuup
# Eelda, et andmekuup on laaditud .csv faili

# Faili nimi ----

# PA111: KESKMINE BRUTOKUUPALK, MEDIAAN, DETSIILID JA TÖÖTAJATE ARV TEGEVUSALARÜHMA (EMTAK 2008) JÄRGI (KVARTALID)
failinimi <- "PA111_20260913-171247.csv"

# PA112: KESKMINE BRUTOTUNNIPALK TEGEVUSALARÜHMA JÄRGI (KVARTALID)
failinimi <- "PA112_20260903-084926.csv"

# PA113: KESKMINE BRUTOKUUPALK JA MEDIAAN TEGEVUSALA (EMTAK 2008) JÄRGI (KVARTALID)
failinimi <- "PA113_20260903-085631.csv"

# PA115: KESKMINE BRUTOKUUPALK, MEDIAAN JA TÖÖTAJATE ARV MAJANDUSÜKSUSE OMANIKU LIIGI JÄRGI (KVARTALID)
failinimi <- "PA115_20260903-090417.csv"

# PA117: KESKMINE BRUTOKUUPALK, MEDIAAN JA TÖÖTAJATE ARV HALDUSÜKSUSE JÄRGI (KVARTALID)
failinimi <- "PA117_20260903-090810.csv"

# PA118: KESKMINE BRUTOTUNNIPALK MAAKONNA JÄRGI (KVARTALID)
failinimi <- "PA118_20260903-091907.csv"

# PA119: KESKMINE BRUTOKUUPALK, MEDIAAN JA TÖÖTAJATE ARV MAAKONNA JÄRGI (KUUD)
failinimi <- "PA119_20260903-092838.csv"

# PA121: KESKMINE BRUTOKUUPALK, MEDIAAN JA TÖÖTAJATE ARV TEGEVUSALARÜHMA (EMTAK 2008) JÄRGI (KUUD)
failinimi <- "PA121_20260903-093258.csv"

# TO043: TÖÖSTUSTOODANG
failinimi <- "TO043_20260830-113408.csv"

# IA002: TARBIJAHINNAINDEKS
failinimi <- "IA002_20260907-104223.csv"

# IA06: EKSPORDIHINNAINDEKS
failinimi <- "IA06_20260921-091537.csv"

# IA028: ELUASEME HINNAINDEKS
failinimi <- "IA028_20260923-223536.csv"

# IA045: EKSPORDI- JA IMPORDIHINNAINDEKS, 2010 = 100 | Hinnaindeks, Tegevusala
failinimi <- "IA045_20260921-092755.csv"

# IA0230: TARBIJAHINDADE HARMONEERITUD INDEKS
failinimi <- "IA0230_20260916-125144.csv"

# IA0286: OMANIKU KASUTUSES OLEVA ELUASEME HINNAINDEKS
failinimi <- "IA0286_20260923-224021.csv"

# RR10: VALITSEMISSEKTORI FINANTSKONTO 
failinimi <- "RR10_20260923-154021.csv"

# RR027: RIIGIEELARVESSE LAEKUNUD MAKSUD (KUUD)
failinimi <- "RR027_20260922-091037.csv"

# RR055: VALITSEMISSEKTORI TULUD JA KULUD
failinimi <- "RR055_20260923-164821.csv"

# RR057: VALITSEMISSEKTORI KONSOLIDEERITUD TULUD JA KULUD
failinimi <- "RR057_20260923-152940.csv"

# RR0575: VALITSEMISSEKTORI RAHALISED SOTSIAALTOETUSED 
failinimi <- "RR0575_20260923-161812.csv"

# RR059: VALITSEMISSEKTORI KONSOLIDEERITUD VÕLG
failinimi <- "RR059_20260923-153502.csv"

# RR060: VALITSEMISSEKTORI KONSOLIDEERITUD VÕLA NÄITAJAD NIMIVÄÄRTUSES 
failinimi <- "RR060_20260923-163221.csv"

# RRI05: ELUKINDLUSTUS LIIGI JA KINDLUSTUSANDJA JÄRGI (KUUD)
failinimi <- "RRI05_20260925-110931.csv"

# TS154: RAHVUSVAHELINE LAEVALIIKLUS SADAMATE KAUDU 
failinimi <- "TS154_20260923-144547.csv"

# RR0295: MAKSUD JA SOTSIAALMAKSED RAHVAMAJANDUSE ARVEPIDAMISES
failinimi <- "RR0295_20260923-163916.csv"

# TS180: KAUBAVEDU SADAMATE KAUDU
failinimi <- "TS180_20260923-121038.csv"

# TS1420: SÕITJATE- JA KAUBAVEDU RAUDTEEL
failinimi <- "TS1420_20260830-142812.csv"

# RR026: RIIKLIKE JA KOHALIKE MAKSUDE LAEKUMINE
failinimi <- "RR026_20260830-173043.csv"

# RR022: RIIKLIKE JA KOHALIKE MAKSUDE LAEKUMINE | Aasta
failinimi <- "RR022_20260830-192319.csv"

# KM0107: KAUBANDUSETTEVÕTETE TULUD, KULUD, KAUBANDUSLIK JUURDEHINDLUS
failinimi <- "KM0107_20260831-103028.csv"

# TS060: TRANSPORDIETTEVÕTETE TULUD
failinimi <- "TS060_20260830-202338.csv"

# RAA0024: SISEMAJANDUSE KOGUPRODUKT SISSETULEKUTE MEETODIL
failinimi <- "RAA0024_20260831-172237.csv"

# RR10: VALITSEMISSEKTORI FINANTSKONTO (ESA 2010) 
failinimi <- "RR10_20260901-112120.csv"

# RAA0061: SISEMAJANDUSE KOGUPRODUKT TARBIMISE MEETODIL (ESA 2010)
failinimi <- "RAA0061_20260831-173434.csv"

# KM0104: KAUPADE JAEMÜÜK 
failinimi <- "KM0104_20260831-102022.csv"

# TE0114: TEENINDUSETTEVÕTETE TULUD JA KULUD
failinimi <- "TE0114_20260901-142936.csv"

# TE011: TEENUSTE MÜÜGI- JA MAHUINDEKSID
failinimi <- "TE011_20260901-144005.csv"

# VKK10: KAUPADE EKSPORT JA IMPORT | voog, kaup (KN), riik, näitaja ning kuu
failinimi <- "VKK10_20260909-110052.csv"

# VKT18 Teenuse väärtus, miljonit eurot | voog, tegevusala, hõivatute arv ning aasta
failinimi <- "VKT18_20260921-130433.csv"

# VKT24 Teenuse väärtus, miljonit eurot | voog, partnertsoon, teenus (EBOPS) ning kvartal
failinimi <- "VKT24_20260902-094801.csv"

# TO0083: TÖÖSTUSTOODANGU MÜÜGIINDEKS | Näitaja, Tegevusala, Korrigeerimine ning Vaatlusperiood
failinimi <- "TO0083_20260904-111235.csv"

# TO031: TÖÖSTUSTOODETE TOOTMINE | Näitaja, Toode ning Vaatlusperiood
failinimi <- "TO031_20260904-112919.csv"

# TO043: TÖÖSTUSTOODANG | Näitaja, Tegevusala ning Vaatlusperiood
failinimi <- "TO043_20260905-213427.csv"

# KE032: ELEKTRIJAAMADE VÕIMSUS
failinimi <- "KE032_20260907-104928.csv"

# KE033: ELEKTRIJAAMADE TOODANG JA ENERGIA TOOTMISEKS TARBITUD KÜTUS
failinimi <- "KE033_20260907-111046.csv"

# KE034: KOOSTOOTMISJAAMADE VÕIMSUS JA TOODANG
failinimi <- "KE034_20260907-130726.csv"

# PAV011: VABAD JA HÕIVATUD AMETIKOHAD NING TÖÖJÕU LIIKUMINE
failinimi <- "PAV011_20260908-101736.csv"

# PAT21: TÖÖJÕUKULUINDEKSID, 2020 = 100
failinimi <- "PAT21_20260908-105842.csv"

# SKK01: SOTSIAALKAITSEKULUTUSED
failinimi <- "SKK01_20260910-105631.csv"

# TU121: MAJUTATUD
failinimi <- "TU121_20260910-110743.csv"

# SKK02: SOTSIAALHÜVITISED
failinimi <- "SKK02_20260910-110136.csv"

# RRI05: ELUKINDLUSTUS LIIGI JA KINDLUSTUSANDJA JÄRGI (KUUD)
failinimi <- "RRI05_20260913-133807.csv"

# RRI07: KAHJUKINDLUSTUS LIIGI JA KINDLUSTUSANDJA JÄRGI (KUUD)
failinimi <- "RRI07_20260925-123222.csv"

# PM09: LOOMAD JA LINNUD
failinimi <- "PM09_20260914-102950.csv"

# PM12: LOOMADE JA LINDUDE PRODUKTIIVSUS
failinimi <- "PM12_20260914-104024.csv"

# PM18: PIIMA KOKKUOST
failinimi <- "PM18_20260925-150022.csv"

# PM19: PIIMATOODETE TOOTMINE 
failinimi <- "PM19_20260925-151045.csv"

# TS205: LENNULIIKLUS TALLINNA LENNUJAAMA KAUDU 
failinimi <- "TS205_20260925-144751.csv"

# TT065: REGISTREERITUD TÖÖTUD
failinimi <- "TT065_20260916-125757.csv"

# TT066: REGISTREERITUD TÖÖTUD | Aasta, Kuu, Piirkond/maakond ning Haridustase
failinimi <- "TT066_20260917-105657.csv"

# NH15: MADALA HARIDUSTASEMEGA NOORED 
failinimi <- "NH15_20260922-093854.csv"

# NH16: 18-26-AASTASED MADALA HARIDUSTASEMEGA NOORED SOO JA HALDUSÜKSUSE JÄRGI
failinimi <- "NH16_20260922-095517.csv"

# Loe .csv fail vastavalt faili kodeeringule ja puhasta veerunimed ja tekstiveerud 
# Excelile sobimatutest kontrollsümbolitest
loe_ja_puhasta_csv <- function(failinimi) {

  # Tuvasta faili kodeering (võtame kõrgeima tõenäosusega variandi)
  tuvastus <- guess_encoding(failinimi)
  kodeering <- if (nrow(tuvastus) > 0 && !is.na(tuvastus$encoding[1])) {
    tuvastus$encoding[1]
  } else {
    default_locale()$encoding # "UTF-8"
  }
  
  # Andmete lugemine tibble formaati
  # skip = 2 jätab esimesed 2 rida vahele, 3. rida võetakse päiseks
  data <- read_csv(
      file = failinimi,
      skip = 2,
      col_names = TRUE,
      na = c("", "NA", "..", ".", "-"), # Määrab puuduvaks väärtuseks (NA)
      locale = locale(
        encoding = kodeering,   # tagab faili kodeeringule vastava täpitähtede korrektse lugemise
        decimal_mark = "."),
      show_col_types = FALSE  # ära näita veergude tüüpi sõnumine
    )  
  
  # Puhasta veerunimed ja tekstiveerud Excelile sobimatutest kontrollsümbolitest
  names(data) <- iconv(names(data), from = "", to = "UTF-8", sub = "")
  names(data) <- str_remove_all(names(data), "[\\x00-\\x08\\x0B\\x0C\\x0E-\\x1F]")
  
  data <- data |> 
    mutate(
      across(
        where(is.character), 
        ~ {x <- iconv(.x, from = "", to = "UTF-8", sub = "")
           str_remove_all(x, "[\\x00-\\x08\\x0B\\x0C\\x0E-\\x1F]")
          }
      )
    )
  
  return(data)

} # end loe_ja_puhasta_csv()


# Teisenda Statistikaameti näitajate aruanne aegridadele sobivale pikale kujule
# Seeriate võtmemuutujad ning perioodi ja väärtuse muutujad.
# Perioodi muutuja on teisendatud aegridade tsibble formaadi indeksi moodustamise sobivaks ajaklassiks 
# (tsibble spetsiaalsed ajaklassid yearquarter, yearmonth, jne)
teisenda_aruanne_pikaks <- function(data) {
  
  data <- data |> 
    
    # Eemalda veerud, mis koosnevad eranditult ainult NA-dest (logi tüüpi veerud)
    # (kui soovid neid säilitada numbrilise NA-na, kasuta selle asemel: mutate(across(where(is.logical), as.numeric)))
    select(where(~ !all(is.na(.x)))) 
  
  # Veerunimed
  col_names <- names(data)
  
  kuude_nimed <- c("Jaanuar", "Veebruar", "Märts", "Aprill", "Mai", "Juuni", 
                   "Juuli", "August", "September", "Oktoober", "November", "Detsember")
  
  # Kuude lühikesed tähised
  short_months <- c("M01", "M02", "M03", "M04", "M05", "M06", "M07", "M08", "M09", "M10", "M11", "M12")
  
  kvartalite_nimed <- c("I kvartal", "II kvartal", "III kvartal", "IV kvartal")
  
  # Kvartalite lühikesed tähised
  short_quarters <- c("Q1", "Q2", "Q3", "Q4")
  
  # Määra, kuidas loetud andmeid tõlgendada
  
  if ("Aasta" %in% col_names) {
    
    # Leidub aasta veerg. Tegemist on Exceli failist laaditud näitajatega
    
    # Kas perioodi ühik on aasta
    # Kui periood on aasta, siis kuu, kvartali veerud puuduvad.
    # On vaid Aasta ja võtmeveerud
    pattern <- str_c(c("Kvartal", "Kuu", kuude_nimed, kvartalite_nimed), collapse = "|")
    if (setequal(col_names, setdiff(col_names, str_subset(col_names, pattern)))) {
      
      # Perioodi ühik on aasta
      data <- data |> 
        
        rename(Periood = Aasta) |> 
        
        mutate(
          Periood = as.integer(Periood)
        ) |> 
        
        # Pane aasta andmed pikka tabelisse juhuks kui on mitu näitajat
        pivot_longer(
          cols = where(is.numeric) & -c("Periood"), # võetakse kõik veerud v.a Periood
          names_to = "Lisadimensioon", # Näitajate veerupäiste koondveerg
          values_to = "value" # väärtuste veeru nimi
        )
      
      # Muuda seeriate võtmemuutuja (Peaks olema Näitaja)
      # ToDo
      col_names <- colnames(data)
      key_vars <- "Näitaja"
      key_vars <- col_names[!col_names %in% c("Periood", "value")]
      
    } else { 
      
      # Perioodi ühik ei ole aasta
    
      # Kas leidub ka eraldi kvartali või kuu veerg
      if (any(c("Kvartal", "Kuu") %in% col_names)) {
        
        # Leidub ka eraldi kvartali või kuu veerg
        
        # Millise perioodi ühiku (kvartal, kuu) veerg leidub
        per_unit_col <- intersect(c("Kvartal", "Kuu"), col_names)
        
        # Peale kvartal, kuu veergu on eraldi näitajate väärtuste veerud
        data <- data |> 
          
          # # Pane eraldi näitajate veerud pikka tabelisse
          pivot_longer(
            # Võta kõik arvulised veerud, va aasta
            cols = where(is.numeric) &  !Aasta,
            names_to = "Lisadimensioon",   # Eraldi näitejate koondveerg
            values_to = "value" # väärtuste veeru nimi
          ) |> 
          
          # Nimeta kvartali, kuu veerg ümber
          rename(Periood = !!per_unit_col)
        
        # Võtmemuutujad
        col_names <- colnames(data)
        key_vars <- col_names[!col_names %in% c("Aasta", "Periood", "value")]
        
      } else {
        
        # Perioodi ühik ei ole aasta ja ei leidu eraldi kvartali, kuu veergu
        # Perioodi väärtused on eraldi veergudes
        
        # Seeriate esialgsed võtmeveerud
        key_vars <- setdiff(col_names, c("Aasta", str_subset(col_names, pattern)))
        
        # Perioodide väärtuste muster
        pattern <- str_c(c(kuude_nimed, kvartalite_nimed), collapse = "|")
        
        # Perioodide väärtusi sisaldavad veerud 
        per_values <- col_names |> 
          # Veerud, mille nimi sisaldab perioodi väärtust
          str_subset(pattern) 
        
        # Kas leidub perioodide väärtusi sisaldavaid veerge
        if (length(per_values) > 0) {
          
          # Leidub perioodide väärtusi sisaldavaid veerge
          
          # Kas perioodide väärtusi sisaldavad veerud algavad perioodi väärtusega
          if (all(str_detect(per_values, paste0("^(", pattern, ")")))) {
            
            # Perioodide väärtusi sisaldavad veerud algavad perioodi väärtusega
            
            # Leia perioodi väärtusele järgnevad stringid perioodide veergudes
            not_period_spec <- per_values |> 
              str_remove_all(pattern) |> 
              str_trim() |> 
              # Jäta elemendid, mille pikkus on > 0, kus midagi on perioodi väärtuse järel
              str_subset(".+")
            
            # Kas perioodide väärtusi sisaldavates veerunimedes on selliseid, mis peale perioodi väärtuse spetsifitseerivad
            # mingi lisadimensiooni väärtused (ei ole vaid perioodi spetsifikatsioon)
            if (length(not_period_spec) > 0) {
              
              # perioodide väärtusi sisaldavates veerunimedes on selliseid, mis peale perioodi väärtuse spetsifitseerivad
              # mingi lisadimensiooni väärtused (ei ole vaid perioodi spetsifikatsioon)
              
              data <- data |> 
                
                # Pööra kõik ajaveerud pikka formaati
                # Eraldame veerunimest perioodi väärtuse ja lisavõtmemuuruja 
                # 
                pivot_longer(
                  cols = all_of(per_values),
                  names_to = c("Periood", "Lisadimensioon"),
                  # eralda 2 gruppi: perioodi väärtus ning kõik kuni lõpuni
                  names_pattern = paste0("^(", pattern, ")(.*)$"),
                  values_to = "value"
                ) |>
                
                # Puhasta lisatud muutujad igaks juhuks
                mutate(
                  Lisadimensioon = str_trim(Lisadimensioon), # eraldamisel jäi tühik ette
                  Periood = str_trim(Periood)
                )
              
              key_vars <- c(key_vars, "Lisadimensioon")
              
            } else {
              
              # Perioodide väärtusi sisaldavad veerunimed ei sisalda enam võtmemuutujate väärtusi (lihtsad perioodi väärtused)
              
              data <- data |> 
                
                # Teisenda kõik näitajate väärtuste veerud numbriks
                # csv-st lugemisel võivad numbritest tekkida chr tüüpi veerud
                mutate(
                  across(
                    all_of(per_values),
                    ~ parse_number(as.character(.), locale = locale(decimal_mark = "."))
                  )
                ) |> 
                
                # Pane pikka tabelisse
                pivot_longer(
                  cols = all_of(per_values),     # võetakse kõik perioodide väärtusi sisaldavad veerud
                  names_to = "Periood",    # veerupäiste (kvartalite) koondveerg
                  values_to = "value"      # väärtuste veeru nimi
                ) 
              
            } # end Perioodide väärtusi sisaldavad veerunimed ei sisalda enam võtmemuutujate väärtusi (lihtsad perioodi väärtused)
          
          } else {
            
            # Perioodide väärtusi sisaldavad veerud ei alga perioodi väärtusega.
            # Veerunimedes on kokku pandud kaks dimensiooni: võtmemuutuja väärtus ja perioodi väärtus
            # "Maanteetransport IV kvartal"
            
            data <- data |> 
              
              # Pööra kõik ajaveerud pikka formaati
              # Eraldame veerunimest lisavõtmemuuruja (kõik enne perioodi väärtust) ja perioodi 
              pivot_longer(
                cols = all_of(per_values),
                names_to = c("Lisadimensioon", "Periood"),
                # eralda 2 gruppi: kõik algusest ja tühik ning perioodi väärtus
                names_pattern = paste0("^(.*)\\s(", pattern, ")"),
                values_to = "value"
              ) |>
              
              # Puhasta lisatud muutujad igaks juhuks
              mutate(
                Lisadimensioon = str_trim(Lisadimensioon), # eraldamisel jäi tühik lõppu
                Periood = str_trim(Periood)
              )
            
            key_vars <- c(key_vars, "Lisadimensioon")
            
          } # end Perioodide väärtusi sisaldavad veerud ei alga perioodi väärtusega.
          
        } else {
          
          # Ei leidu perioodide väärtusi sisaldavaid veerge
          
          stop("Ei leidu perioodide väärtusi sisaldavaid veerge")
          
        } # end ei leidu perioodide väärtusi sisaldavaid veerge
        
              
    # ##ToDo! vanavariandi lõik Vist liine
    #     # Seeriate võtmemuutujad
    #     key_vars <- col_names[!col_names %in% c(kuude_nimed, "Aasta", kvartalite_nimed)]
    #     
    #     data <- data |> 
    #       
    #       # Teisenda kõik näitajate väärtuste veerud numbriks
    #       # csv-st lugemisel võivad numbritest tekkida chr tüüpi veerud
    #       mutate(
    #         across(
    #           -all_of(key_vars),
    #           ~ parse_number(as.character(.), locale = locale(decimal_mark = "."))
    #         )
    #       ) 
    #     
    #     data <- data |> 
    #       
    #       # Pane perioodide väärtuste veerud pikka tabelisse
    #       pivot_longer(
    #         cols = -all_of(c(key_vars, "Aasta")), # võetakse kõik veerud v.a nimetatud
    #         names_to = "Periood",   # veerupäiste (perioodide) koondveerg
    #         values_to = "value" # väärtuste veeru nimi
    #       )
        
      } # end Perioodi väärtused on eraldi veergudes
      
      # Teisenda perioodi tekst vastavalt perioodi ühikule
    
      # Unikaalsed perioodid
      unique_per <- unique(data$Periood)
      
      # Kas perioodid sisaldavad kuuude nimetusi
      if (all(unique_per %in% kuude_nimed)) {
        
        # Perioodi ühik on kuu
        data <- data |> 
          
          # Asenda perioodis kuunimed numbritega ja teisenda yearmonth objektiks 
          mutate(
            # Kuu numbrina
            Kuu_nr = match(Periood, kuude_nimed),
            # Aegrea jaoks tsibble formaat (nt "1998 Jan" / Year-Month indeks)
            # Periood = yearmonth(paste(Aasta, Kuu_nr, sep = "-"))
            Periood = make_yearmonth(year = Aasta, month = Kuu_nr)
          ) 
        
      } else {
      
        # Perioodid ei sisalda kuuude nimetusi
        
        # Kas perioodid sisaldavad kvartali nimetusi
        # if (all(str_detect(unique_per, "kvartal"))) {
        if (all(unique_per %in% kvartalite_nimed)) {  
          
          # unique_per %in%   kvartalite_nimed
          # 
          # match( unique_per, kvartalite_nimed)
          # 
          # 1:10 %in% c(1,3,5,9) 
          # c(1,3,5,9) %in% 1:10
          
          # Perioodi ühik on kvartal
          
          data <- data |> 
            
            # Teisenda tekst "IV kvartal" formaati "Q4" jne
            mutate(
              Periood = Periood |>
                str_replace("IV kvartal", "Q4") |>
                str_replace("III kvartal", "Q3") |>
                str_replace("II kvartal", "Q2") |>
                str_replace("I kvartal", "Q1") 
            ) |> 
            
            # pane aasta kvartalile ette ("2021 Q1") ja seejärel yearquarter klassiks
            mutate(
              Periood = str_c(Aasta, Periood, sep = " ") |> 
                # tsibble::yearquarter() automaatselt tunneb nüüd stringist kvartali
                # (nt "2021 Q1" muutub ajatempliks 2021 Q1)
                yearquarter()
            ) 
          
        } else {
          
          # Perioodi ühik ei ole aasta, kuu ega kvartal
          stop("Perioodi ühik ei ole aasta, kuu ega kvartal")
        }
      
      } #end Perioodid ei sisalda kuuude nimetusi
      
      # Jäta vajalikud muutujad
      data <- data |> 
        
        select(all_of(key_vars), Periood, value)
      
    } # end Perioodi ühik ei ole aasta
    
  } else {
    
    # Aasta veergu ei ole 
    # Tegemist on OPR-st laaditud näitajatega
    
    # Perioodide väärtusi sisaldavad veerud 
    per_values <- col_names |> 
      # Veerud, mille nimi sisaldab 4 numbrit (aasta)
      str_subset("\\d{4}") |> 
      # va veerud, mille nimes on mingi tähis, näiteks (EMTAK 2008), (ESA 2010 tehing) S.1313
      str_subset("\\(EMTAK|\\(ESA|S.131", negate = TRUE)
    
    # Kas leidub perioodide väärtusi sisaldavaid veerge
    if (length(per_values) > 0) {
      
      # Leidub perioodide väärtusi sisaldavaid veerge
    
      # Kas perioodide väärtusi sisaldavad veerud algavad 4 numbriga (aasta)
      if (all(str_detect(per_values, "^\\d{4}"))) {
        
        # Perioodide väärtusi sisaldavad veerud algavad 4 numbriga (aasta)
        
        # Leia aastatele järgnevad stringid perioodide veergudes
        after_years <- per_values |> 
          str_remove("\\d{4}") |> 
          str_trim() |> 
          # Jäta elemendid, mille pikkus on > 0, kus midagi on aasta järel
          str_subset(".+")
        
        # Moodusta muster kuude ja kvartalite jaoks "kuu nimetus|kvartal|Q1|Q2|Q3|Q4"
        pattern <-  c(kuude_nimed, short_months, kvartalite_nimed, "kvartal", short_quarters) |>  
          str_c(collapse = "|")
        
        # Leia aastatele järgnevates stringides (veergudes) veerud, millele aasta järel järgneb 
        # mingi muu tekst, mis ei ole aastat täpsustav periood (kuu, kvartal, ...)
        not_period_spec <- str_to_upper(after_years) |> 
          str_subset(str_to_upper(pattern), negate = TRUE)
        
        # Kas perioodide väärtusi sisaldavates veerunimedes on selliseid, mis peale aasta spetsifitseerivad
        # mingi lisadimensiooni väärtused (ei ole vaid perioodi spetsifikatsioon)
        if (length(not_period_spec) > 0) {
          
          # perioodide väärtusi sisaldavates veerunimedes on selliseid, mis peale aasta spetsifitseerivad
          # mingi lisadimensiooni väärtused (ei ole vaid perioodi spetsifikatsioon)
          
          # ToDo: Eelda, et veerunimes periood on ainult aasta täpsusega. Aasta väärtusele järgneb lisadimensiooni väärtus
          
          data <- data |> 
            
            # Pööra kõik ajaveerud pikka formaati
            # Eraldame veerunimest perioodi (aasta) ja lisavõtmemuuruja (kõik peale 4-kohalist aastat) 
            # 
            pivot_longer(
              cols = all_of(per_values),
              names_to = c("Periood", "Lisadimensioon"),
              # eralda 2 gruppi: 4 numbrit ning kõik kuni lõpuni
              names_pattern = "^(\\d{4})(.*)$",
              values_to = "value"
            ) |>
            
            # Puhasta lisatud muutujad igaks juhuks
            mutate(
              Lisadimensioon = str_trim(Lisadimensioon), # eraldamisel jäi tühik ette
              Periood = str_trim(Periood)
            )
          
        } else {
        
          # Perioodide väärtusi sisaldavad veerunimed ei sisalda enam võtmemuutujate väärtusi (lihtsad perioodi väärtused)
        
          data <- data |> 
            
            # Teisenda kõik näitajate väärtuste veerud numbriks
            # csv-st lugemisel võivad numbritest tekkida chr tüüpi veerud
            mutate(
              across(
                all_of(per_values),
                ~ parse_number(as.character(.), locale = locale(decimal_mark = "."))
              )
            ) |> 
            
            # Pane pikka tabelisse
            pivot_longer(
              cols = all_of(per_values),     # võetakse kõik perioodide väärtusi sisaldavad veerud
              names_to = "Periood",    # veerupäiste (kvartalite) koondveerg
              values_to = "value"      # väärtuste veeru nimi
            ) 
          
        } # end Perioodide väärtusi sisaldavad veerunimed ei sisalda enam võtmemuutujate väärtusi (lihtsad perioodi väärtused)
        
      } else {
        
        # Perioodide väärtusi sisaldavad veerud ei alga aasta 4 numbriga.
        # Veerunimedes on kokku pandud kaks dimensiooni: võtmemuutuja väärtus ja perioodi väärtus
        # "Maanteetransport 2020 IV kvartal"
        
        data <- data |> 
          
          # Pööra kõik ajaveerud pikka formaati
          # Eraldame veerunimest lisavõtmemuuruja (kõik enne 4-kohalist aastat) ja perioodi 
          pivot_longer(
            cols = all_of(per_values),
            names_to = c("Lisadimensioon", "Periood"),
            # eralda 2 gruppi: kõik algusest ja tühik ning 4 numbrit ja kõik kuni lõpuni
            # names_pattern = "^(.*)\\s(\\d{4}\\s.*)$",
            names_pattern = "^(.*)\\s(\\d{4}.*)$",
            values_to = "value"
          ) |>
          
          # Puhasta lisatud muutujad igaks juhuks
          mutate(
            Lisadimensioon = str_trim(Lisadimensioon), # eraldamisel jäi tühik lõppu
            Periood = str_trim(Periood)
          )
        
      } # end Perioodide väärtusi sisaldavad veerunimed ei sisalda enam võtmemuutujate väärtusi (lihtsad perioodi väärtused)
      
    } else {
      
      # Ei leidu perioodide väärtusi sisaldavaid veerge
      
      # Võimalikud perioodide väärtusi sisaldavad veerunimed
      # ToDo! Lisa siia võimalike perioodide väärtuste veerunimesid, kui neid peaks esinema
      fix_per_names <- str_c(c("Vaatlusperiood"), collapse = "|")
      
      # Perioodide väärtusi sisaldav veerg
      per_col <- str_subset(col_names, fix_per_names)
      
      # Kas leidub üks kindla nimega perioodide väärtuste veerg
      if (length(per_col) == 1) {

        # Leidub üks perioodide väärtuste veerg 
        
        data <- data |> 
          
          # Pane kõik arvulised veerud, va perioodide väärtusi sisaldav veerg, pikka tabelisse
          pivot_longer(
            cols = where(is.double) & -!!per_col[1],
            names_to = "Lisadimensioon", # arvuliste veergude koondveerg
            values_to = "value"      # väärtuste veeru nimi
          ) |> 
          
          rename(
            Periood = !!per_col[1]
          )

      } else {
        
        # Ei leidu ühte kindla nimega perioodide väärtuste veergu
        
        stop("Ei leidu ühte kindla nimega perioodide väärtuste veergu")
        
      }
      
    } # end Ei leidu perioodide väärtusi sisaldavaid veerge
    
    # Teisenda periood vastavalt perioodi ühikule
    
    # Unikaalsed perioodid
    unique_per <- unique(data$Periood)
    
    # Moodusta muster kuude jaoks "JAANUAR|DETSEMBER|M01...M12"
    pattern <-  str_to_upper(c(kuude_nimed, short_months)) |> 
      str_c(collapse = "|")
    
    # Kas perioodid sisaldavad kuuude nimetusi
    if (all(str_detect(str_to_upper(unique_per), pattern))) {
      
      # Perioodi ühik on kuu
      
      # Eestikeelsete kuunimede vastavus numbritele
      kuu_tabel <- c(
        "jaanuar"   = "01", "veebruar" = "02", "märts"    = "03", 
        "aprill"    = "04", "mai"      = "05", "juuni"    = "06",
        "juuli"     = "07", "august"   = "08", "september"= "09", 
        "oktoober"  = "10", "november" = "11", "detsember"= "12"
      )
      
      data <- data |> 
        
        # Asenda perioodis kuunimed numbritega ja teisenda yearmonth objektiks
        mutate(
          Periood = Periood |> 
            tolower() |> 
            str_replace_all(kuu_tabel) |> 
            yearmonth()
        )
      
    } else {
      
      # Perioodid ei sisalda kuuude nimetusi
      
      # Moodusta muster kvartalite jaoks "kvartal|Q1|Q2|Q3|Q4"
      pattern <-  c("kvartal", short_quarters) |>  str_c(collapse = "|")
      
      # Kas perioodid sisaldavad kvartali nimetusi
      if (all(str_detect(unique_per, pattern))) {
        
        data <- data |> 
      
          # Teisenda tekst "2021 I kvartal" formaati "2021 Q1" ja seejärel yearquarter klassiks
          mutate(
            Periood = Periood |>
              str_replace("IV kvartal", "Q4") |>
              str_replace("III kvartal", "Q3") |>
              str_replace("II kvartal", "Q2") |>
              str_replace("I kvartal", "Q1") |> 
              # tsibble::yearquarter() automaatselt tunneb nüüd stringist kvartali
              # (nt "2021 Q1" muutub ajatempliks 2021 Q1)
              yearquarter()
          ) 
        
      } else {
        
        # Perioodid ei sisalda kvartali nimetusi
        
        # Kas perioodid sisaldavad ainult aastaid
        if (all(str_detect(unique_per, "^\\s*\\d{4}\\s*$"))) {
          
          data <- data |>
            
            # Teisenda tekstilise aasta täisarvuks
            mutate(  
              Periood = as.integer(Periood)
            )
          
        } else {
          
          # Perioodid ei sisalda ka aastaid
          
          # Kas perioodid sisaldavad aastat
          stop("Tundmatu perioodi ühik")
          
        } # end Perioodid ei sisalda ka aastaid
        
      } # end Perioodid ei sisalda kvartali nimetusi
      
    } # end Perioodid ei sisalda kuuude nimetusi
      
    
  } # end Aasta veergu ei ole 
  
  # Eemalda perioodid, kus kõigi näitajate väärtused puuduvad
  # Näiteks, kui aasta ja lühem periood olid eraldi veergudes ja aasta ei ole lõppenud.
  data <- data |> 
    group_by(Periood) |> 
    filter(!all(is.na(value))) |> 
    ungroup()
  
  return(data)

} # end teisenda_aruanne_pikaks()


# Leia aegridade tsibble ts_data viimase perioodi usaldusväärsuse hinnangud
find_ts_reliability <- function(ts_data) {

  # Ajaindeksi veeru nimi
  time_var <- index_var(ts_data)
  
  ts_data <- ts_data |>
    # Jäta alles ainult need seeriad, kus mitte kõik väärtused 
    #   ei puudu (tühi seeria)
    #   ei ole nullid (st eemalda seeriad, kus kõik vaatlused on 0) 
    # ts_data on tsibble objekt, kus igal unikaalsel aegreal on oma võti
    # Funktsioon group_by_key() rühmitab andmed automaatselt kõigi tsibble võtmetunnuste järgi, ilma et peaks neid eraldi välja kirjutama.
    group_by_key() |>
    filter(!all(is.na(value))) |> 
    filter(!all(value == 0, na.rm = TRUE)) |>
    ungroup()
  
  ts_data <- ts_data |> 
    # Vajadusel filtreeri välja NA-d, kui mõnel seerial on alguses/lõpus puuduvad väärtused
    # Filtreeritakse välja ka rea vahepealsed puuduvad väärtused.
    filter(!is.na(value)) |> 
    # Seerias vahepealsed puuduvad väärtused pane tagasi, et seerias ei oleks ajateljel tühje kohti
    fill_gaps()
  
  # Maksimaalne periood
  max_period <- max(ts_data[[time_var]], na.rm = TRUE)
  
  ts_data <- ts_data |> 
    # Uurime viimase perioodi väärtuste usaldusväärsust. Kui seeria viimase perioodi 
    # väärtus puudub, pole mõtet analüüsida.
    # Eemalda seeriad, millel viimase perioodi väärtus puudub
    group_by_key() |>
    filter(max(Periood, na.rm = TRUE) == max_period) |> 
    # Väga lühikesed seeriad jäta välja
    filter(length(Periood) > 3) |> 
    ungroup()
  
  
  # Eralda andmetest viimane periood, mille väärtusi tahame kontrollida
  ts_data_new <- ts_data |> 
    filter_index(as.character(max_period))
  
  # Eralda andmetest kõik eelnevad perioodid va viimane periood
  ts_data_old <- ts_data |> 
    filter_index(~ as.character(max_period - 1))
  
  # Leia eelmevatest perioodidest mudelid
  # Mudelite sobitamine (ARIMA, ETS ja kombineeritud ansambel)
  # Tulemuseks on mable (model table), kus igal real on vastava seeria mudelid
  mudelid <- ts_data_old |>
    
    model(
      # 1. Klassikaline ARIMA
      auto_arima = ARIMA(value),
  
      # 2. Eksponentsiaalne tasandamine (ETS)
      auto_ets = ETS(value) #,
  
      # 3. Tehisnärvivõrk (Neural Network Time Series Autoregression)
      # Kasutab viiteid sisenditena ühe peidetud kihiga etteandesüsteemis (feed-forward neural network)
      # NB! Vaikimisi parameetritega väga aeglane. Vaja tuunida!
      # nnetar = NNETAR(value),
  
      # 4. Prophet mudel (tükiti lineaarne trend ja Fourier sesoonsus)
      # Prophet otsib vaikimisi trendi murdepunkte (changepoints) kuni 25 erinevast kohast aegreas (vaikimisi parameeter n_changepoints = 25).
      # Määra mudeli definitsioonis n_changepoints väiksemaks (kvartaliandmetele sobib tavaliselt 3 kuni 8)
      # changepoint_n(n = 4) või n = 6: Hoiab ära liiga sagedase trendi suunamuutuse lühikeses ajaloos.
      # season(period = 4, type = "multiplicative"): Kvartaliandmetel tasub vajadusel määrata ka sesoonsuse tüüp (kui kõikumised kasvavad koos tasemega).
  
      # Paketis fable.prophet seadistatakse sesoonsus mudelivalemis funktsiooni season() abil. Kvartaliandmete puhul on baasperiood 4.
      # Funktsioon season() võimaldab määrata nii sesoonsuse kuju (aditiivne vs multiplikatiivne) kui ka Fourier' liikmete arvu ($K$).
      # Parameetri season() argumendid
      #  period: Sesoonne tsükkel. Kvartaliandmetel 4 (või "year"), kuupõhistel andmetel 12.
      #  type: "additive" (vaikimisi) – sesoonsed kõikumised on püsiva amplituudiga.
      #           Vali type = "additive", kui kõikumiste suurus püsib läbi aastate samas suurusjärgus sõltumata trendi tasemest.
      #        "multiplicative" – sesoonsed kõikumised kasvavad/kahanevad proportsionaalselt aegrea tasemega.
      #           Vali type = "multiplicative", kui graafikul on näha, et kvartalite kõikumiste laius (näiteks Q4 müügitipud) kasvab aasta-aastalt koos ettevõtte käibe või näitaja üldise kasvuga.
      #  order: Fourier' ridade arv ($K$), mis määrab sesoonse kõvera paindlikkuse. Kvartaliandmete ($period = 4$) puhul on maksimaalne mõistlik väärtus $order = 2
  
      # prophet = prophet(value ~ changepoint_n(n = 6)),
      # Prognoosis on vaid keskväärtus, ei ole dispersiooni. 
      # prophet = prophet(
      #   value ~ growth(n_changepoints = 6) + season(period = 4, order = 2, type = "multiplicative")
      # )
    ) |> 
    
    # Lisa mudelite kombinatsioonid
    mutate(
      # Ansambel A: Kõigi mudelite võrdselt kaalutud keskmine 
      # kombineeritud = (auto_arima + auto_ets + nnetar + prophet) / 4,
      kombineeritud = (auto_arima + auto_ets) / 2 #,
  
      # Ansambel B: Kaalutud keskmine (nt suurem kaal stabiilsetel statistilistel mudelitel)
      # ansambel_kaaludega = (0.35 * auto_arima) + (0.35 * auto_ets) + (0.15 * nnetar) + (0.15 * prophet)
      # ansambel_kaaludega = (0.40 * auto_arima) + (0.40 * auto_ets) + (0.20 * prophet)
    )
  
  # Vaata sobitatud mudelite tabelit (mable)
  # print(mudelid)
  
  # Prognoosid järgmiseks 1 perioodiks 
  # Tulemuseks on fable (forecast table) koos jaotuste ja punktprognoosidega (.mean)
  prognoosid <- mudelid |>
    
    # select(-c(auto_ets, kombineeritud)) |> 
    
    forecast(h = 1) # 1 periood ette
  
  
  # Testandmeteks on viimane periood, mille väärtusi tahame kontrollida
  # Arvuta testandmete põhjal täpsused ja vali igale seeriale parima täpsusega mudel
  # Veamõõdikuks MAE (Mean Absolute Error – Keskmine absoluutne viga)
  # Sisuliselt prognoosivea absoluutne suurus, kuna on üks testperiood
  # Vali madalaima MAE-ga mudel
  parimad_mudelid <- prognoosid |> 
    
    # Võrdleb 1-sammu prognoose ts_data tegelike vastava perioodi väärtustega ja 
    # arvutab igale mudelile ja seeriale veamõõdikud (sh MAE)
    accuracy(ts_data, measures = list(MAE = MAE)) |> 
    
    # Grupeeri automaatselt seeriate võtmete järgi (nt Näitaja, Tegevusala)
    group_by(across(all_of(key_vars(ts_data)))) |> 
    
    # Jäta alles vähima MAE-ga mudel
    slice_min(MAE, n = 1, with_ties = FALSE) |>  
    
    ungroup()
  
  # Filtreeri prognoosid, jättes alles vaid parimad
  parimad_prognoosid <- prognoosid |> 
    semi_join(parimad_mudelid, by = key_vars(prognoosid))
  
  # Kasuta edaspidi iga seeria jaoks vaid parimat prognoosi
  prognoosid <- parimad_prognoosid
  
  # Arvuta 95% usaldusvahemikud
  prognoosid_vahemikega <- prognoosid |>
    hilo(level = 95) |>
    
    unpack_hilo(`95%`) |> # eraldab alumise (95%_lower) ja ülemise (95%_upper) piiri eraldi veergudeks
    
    rename(
      lower = `95%_lower`,
      upper = `95%_upper`
    )
  
  # print(prognoosid_vahemikega)
  
  # Võrdle prognoose ja tegelikku viimast perioodi
  
  # Tõenäosusega 5% (sabades kokku 5%, ühes sabas 2.5%)
  # qnorm(1 - 0.05 / 2) # Tulemus: 1.959964 (1.96 standardhälvet)
  
  # Tõenäosusega 50% (sabades kokku 50%, ühes sabas 25%)
  # qnorm(1 - 0.50 / 2) # Tulemus: 0.6744898 (~0.674 standardhälvet)
  
  # Pane viimase perioodi andmed ja prognoosid kokku ühte tabelisse
  # ts_comp <- prognoosid_vahemikega |>
  #   # as_tibble() |>
  #   left_join(
  #     ts_data_new |>  rename(tegelik = value),
  #     by = c("Näitaja", "Tegevusala", time_var)
  #   )
  # Nii saame tsibble
  
  # ts_comp_2 <- ts_data_new |> 
  #   as_tibble() |> 
  #   left_join(
  #     prognoosid_vahemikega |>  rename(prognoos = value),
  #     by = c("Näitaja", "Tegevusala", time_var)
  #   )
  # Nii saame tibble
  
  ts_comp <- prognoosid_vahemikega |>
    # as_tibble() |>
    
    # Lisa tegelikud tulemused
    left_join(
      ts_data_new |>  rename(tegelik = value),
      by = c(key_vars(ts_data), time_var)
    ) |> 
    
    mutate(
      # Prognoosi standardhälve 
      prognoosi_sd = sqrt(distributional::variance(value)),
      
      # Normaaljaotuse variatsioonikordaja (Coefficient of Variation)
      # CV = standardhälve/keskväärtus protsentides
      cv_pct =  (prognoosi_sd / .mean) * 100,
      
      # Tegeliku väärtuse viga, hälve, kõrvalekalle, erinevus prognoosist
      viga = tegelik - .mean,
      
      # Kõrvalekalde suhe tegelikku väärtusesse protsentides
      viga_pct = (viga / tegelik) * 100,
      
      # Standardiseeritud prognoosiviga ehk z-skoor
      # standardized forecast error / z-score
      # Z-skoor (ehk standardskoor) on statistiline näitaja, mis näitab, mitme standardhälbe kaugusel konkreetne väärtus keskmisest asub.
      # Näitab, mitme prognoosi standardhälbe võrra erineb tegelik tulemus mudeli oodatud keskväärtusest, võttes arvesse mudeli enda ebakindlust sel konkreetsel ajaperioodil.
      z_skoor = viga / prognoosi_sd,
      
      # Hoiatused
      hoiatus_1 = case_when(
        # Viga > 3 * standardhälve
        abs(z_skoor) > 3    ~ "KRIITILINE ANOMAALIA: väljaspool 99,7% piiri",
        # Viga > 1.96 * standardhälve
        abs(z_skoor) > 1.96 ~ "OLULINE ANOMAALIA: väljaspool 95% piiri",
        # Viga > 1 * standardhälve
        abs(z_skoor) > 1    ~ "SUUR HÄLVE: väljaspool 68% piiri",
        # Viga > 0.674 * standardhälve
        abs(z_skoor) > 0.674 ~ "MÕÕDUKAS HÄLVE: väljaspool 50% piiri",
        # Normaalne
        TRUE ~ ""
      ),
      hoiatus_2 = if_else(abs(viga_pct) > 20, "HOIATUS: Suur suhteline viga (>20%)", ""),
      hoiatus_3 = if_else(abs(cv_pct) > 30, "HOIATUS: Suur hajuvus (>30%)", ""),
      
      # Ümarda
      across(
        c(.mean:viga_pct), ~ round(.x, digits = 2) #1)
      ),
      across(
        c(z_skoor), ~ round(.x, digits = 2)
      ) 
      
    ) 
  
  # Salvesta prognooside ja tegelike väärtuste võrdlus Excelisse
  
  exceli_tabel <- ts_comp |> 
    
    # Eemalda spetsiaalse jaotuse veerg (value), et vältida Exceli vigu
    select(-value) |> 
    
    as_tibble() |> 
    
    mutate(
      # Teisenda perioodi formaat puhtaks tekstiks Exceli jaoks
      # Tegelikult ei ole vist vaja. 
      # write.xlsx oskab ise teisendada perioodi formaadi puhtaks tekstiks
      !!time_var := as.character(.data[[time_var]]),
      # Tee võtmeveergude tekstid UTF-8 vastavaks, et Excelisse kirjutamisel ei oleks jama
      # Enam ei ole vist vaja, kui .csv lugemisel loeme vastavalt faili kodeeringule ja 
      # oleme puhastanud tekstiveerud Excelile sobimatutest kontrollsümbolitest
      across(
        all_of(key_vars(ts_data)),
        # Paranda/asenda UTF-8 mitteühilduvad sümbolid mingi krõnksuga
        ~ stringi::stri_enc_toutf8(.x, validate = TRUE)
        # Jäta alles ainult kehtivad prinditavad tähemärgid. Mitteprinditavate asemel tühik
        # ~ stringi::stri_replace_all_regex(.x, "[^\\p{L}\\p{N}\\p{P}\\p{Z}]", " ")
      )
    ) |>
    
    # Korrasta veergude järjekord ja nimetused
    select(
      # Võtmeveerud ja periood
      all_of(key_vars(ts_data)),
      all_of(time_var),
      Mudel = .model,
      Prognoos = .mean,
      Prognoosi_sd = prognoosi_sd,
      `CV %` = cv_pct,
      `95% alumine` = `lower`,
      `95% ülemine` = `upper`,
      Tegelik = tegelik,
      Viga = viga,
      # Standardiseeritud prognoosiviga ehk z-skoor
      `z-skoor` = z_skoor,
      `Vea %` = viga_pct,
      hoiatus_1, 
      hoiatus_2,
      hoiatus_3
    ) 
  
  return(
    list(
      prognoosid = prognoosid,
      exceli_tabel = exceli_tabel
    )
    
  )

} # end find_ts_reliability


# Töötle fail ----

# Loe .csv fail
data <- loe_ja_puhasta_csv(failinimi)

# print(data)
# str(data)

# Teisenda Statistikaameti näitajate aruanne aegridadeks sobivale pikale kujule
data <- teisenda_aruanne_pikaks(data)

# print(data)
# str(data)

# Kvartaliandmete teisendamiseks tsibble formaati tuleb teisendada tekstiline kvartal (nt "2021 I kvartal") 
# spetsiaalseks ajaklassiks yearquarter ning seejärel määrata indeks ja võtmed funktsiooniga as_tsibble()

ts_data <- data |>
  
  # Teisenda tsibble objektiks
  as_tsibble(
    # Määrab ajatelje ([1Q] sagedusega).
    index = Periood,
    # Määrab tunnused, mis eristavad erinevaid aegridasid (igal näitaja ja tegevusala paaril on oma iseseisev aegrida).
    # Seeriate võtmemuutujad: jäta muutujatest välja perioodi ja väärtuse muutujad
    key = setdiff(colnames(data), c("Periood", "value"))
  )

# print(ts_data)
# str(ts_data)


# Tuvasta automaatselt aegrea sagedus: 4 kvartalite puhul, 12 kuude puhul
freq <- guess_frequency(ts_data$Periood)

# Aastane muutus
ts_diff <- ts_data |> 
  # 1. Veendume, et ajareal poleks puuduvaid kvartaleid (hoiab ära nihkevead)
  fill_gaps() |> 
  # 2. Tagame selgesõnalise grupeerimise iga unikaalse seeria lõikes
  group_by_key() |>
  # 3. Arvutame erinevuse ja soovi korral ka % kasvu
  mutate(
    diff_yoy = difference(value, lag = freq),
    pct_yoy  = round((value / lag(value, freq) - 1) * 100, digits = 1)
  ) |> 
  ungroup() |> 
  # Jäta ainult viimane periood
  # filter_index(as.character(max(ts_data[[index_var(ts_data)]], na.rm = TRUE)))
  # filter_index(as.character(max(ts_data$Periood, na.rm = TRUE)))
  # filter(Periood == max(Periood, na.rm = TRUE)) |> 
  
  # Et oleks mugav View-ga perioodi filtreerida
  as_tibble() |> 
  mutate(Periood = as.character(Periood))
    

# Leia aegridade usaldusväärsuse hinnangud
res <- find_ts_reliability(ts_data)

# Prognooside ja tegelike väärtuste võrdlus Excelisse sobivana
ts_rel <- res$exceli_tabel

# Prognoosid koos mudeliga
prognoosid <- res$prognoosid

# print(ts_rel)
# str(ts_rel)

# Kirjuta Exceli faili
# Võta kõik sümbolid stringi algusest kuni esimese alakriipsuni (alakriipsu kaasamata)
# str_extract(failinimi, "^[^_]+")
# str_split_i(failinimi, "_", 1)
write.xlsx(ts_rel, file = paste(str_split_i(failinimi, "_", 1), "näitajate analüüs.xlsx"))


# Illustreeri graafiliselt

# Filtreeri välja üks konkreetse näitaja ja joonista prognoosi koos ajalooga
unique(ts_data$Näitaja)
unique(ts_data$Tegevusala)
unique(ts_data$Lisadimensioon)
unique(prognoosid$.model)

naitaja_valik = "Tuuleelektrijaamade kasutatud võimsus, MW"
tegevusala_valik = "Info ja side"
lisadimensiooni_valik <- "Majad"
mudeli_valik <- unique(prognoosid$.model) # "auto_arima"

prognoosid |>
  filter(
    Näitaja == naitaja_valik, 
    Tegevusala == tegevusala_valik,
    .model %in% mudeli_valik
    ) |>
  autoplot(ts_data, level = c(80, 95)) +
  labs(
    title = paste0("Kvartaliandmete prognoos (", mudeli_valik, ")"),
    subtitle = paste(naitaja_valik, tegevusala_valik, sep = " ja "),
    x = "Kvartal",
    y = "Väärtus"
  ) +
  theme_minimal()


# Kuva ühe näitaja mitu tegevusala korraga
prognoosid |>
  filter(
    Näitaja == naitaja_valik, 
    .model %in% mudeli_valik
    ) |>
  # Funktsioonis autoplot() (pakett feasts / fabletools) värvitakse usaldusvahemike taustad (fill) ja 
  # prognoosijooned (colour) vaikimisi mudeli (.model) alusel.
  # Tahan kõik usaldusvahemikud sama värvi.
  mutate(.model = mudeli_valik[1]) |> 
  
  autoplot(ts_data, # |> filter(Näitaja == naitaja_valik), 
           level = c(80, 95)) +
  facet_wrap(~ Tegevusala, scales = "free_y") +
  labs(
    title = paste0("Prognoosid tegevusalade lõikes: ", naitaja_valik),
    x = "Kvartal",
    y = "Väärtus"
  ) +
  theme_minimal() +
  theme(legend.position = "none")


# Kuva ühe tegevusala mitu näitajat korraga
prognoosid |>
  filter(
    Tegevusala == tegevusala_valik, 
    .model %in% mudeli_valik
  ) |>
  # Funktsioonis autoplot() (pakett feasts / fabletools) värvitakse usaldusvahemike taustad (fill) ja 
  # prognoosijooned (colour) vaikimisi mudeli (.model) alusel.
  # Tahan kõik usaldusvahemikud sama värvi.
  mutate(.model = mudeli_valik[1]) |> 
  
  autoplot(ts_data, 
           level = c(80, 95)) +
  facet_wrap(~ Näitaja, scales = "free_y") +
  labs(
    title = paste0("Prognoosid näitajate lõikes: ", tegevusala_valik),
    x = "Kvartal",
    y = "Väärtus"
  ) +
  theme_minimal() +
  theme(legend.position = "none")


# Kuva mitu kaubagruppi korraga
prognoosid |>
  filter(
    # Tegevusala == tegevusala_valik, 
    .model %in% mudeli_valik
  ) |>
  # Funktsioonis autoplot() (pakett feasts / fabletools) värvitakse usaldusvahemike taustad (fill) ja 
  # prognoosijooned (colour) vaikimisi mudeli (.model) alusel.
  # Tahan kõik usaldusvahemikud sama värvi.
  mutate(.model = mudeli_valik[1]) |> 
  
  autoplot(ts_data, 
           level = c(80, 95)) +
  facet_wrap(~ Kaubagrupp, scales = "free_y") +
  labs(
    title = paste0("Prognoosid kaubagruppide lõikes"),
    x = "Periood",
    y = "Väärtus"
  ) +
  theme_minimal() +
  theme(legend.position = "none") 


# Kuva ühe näitaja mitu toodet korraga
prognoosid |>
  filter(
    Näitaja == naitaja_valik, 
    Toode %in% c("Jäätis, t", "Puidust uksed, ukseraamid, -piidad, lävepakud, tk", 
                 "Põlevkivikütteõli jm kütteõli väävlisisaldusega mitte rohkem kui 1 massiprotsent, tuhat t",
                 "Vaibad ja vaipkatted, m²"),
    .model %in% mudeli_valik
  ) |>
  # Funktsioonis autoplot() (pakett feasts / fabletools) värvitakse usaldusvahemike taustad (fill) ja 
  # prognoosijooned (colour) vaikimisi mudeli (.model) alusel.
  # Tahan kõik usaldusvahemikud sama värvi.
  mutate(.model = mudeli_valik[1]) |> 
  
  autoplot(ts_data, 
           level = c(80, 95)) +
  facet_wrap(~ Toode, scales = "free_y") +
  labs(
    title = paste0("Prognoosid näitajate lõikes: ", naitaja_valik),
    x = "Kvartal",
    y = "Väärtus"
  ) +
  theme_minimal() +
  theme(legend.position = "none")

# Kuva ühe näitaja mitu elektritootja liiki korraga
prognoosid |>
  filter(
    Näitaja == naitaja_valik, 
    # Toode %in% c("Jäätis, t", "Puidust uksed, ukseraamid, -piidad, lävepakud, tk", 
    #              "Põlevkivikütteõli jm kütteõli väävlisisaldusega mitte rohkem kui 1 massiprotsent, tuhat t",
    #              "Vaibad ja vaipkatted, m²"),
    .model %in% mudeli_valik
  ) |>
  # Funktsioonis autoplot() (pakett feasts / fabletools) värvitakse usaldusvahemike taustad (fill) ja 
  # prognoosijooned (colour) vaikimisi mudeli (.model) alusel.
  # Tahan kõik usaldusvahemikud sama värvi.
  mutate(.model = mudeli_valik[1]) |> 
  
  autoplot(ts_data, 
           level = c(80, 95)) +
  facet_wrap(~ `Elektritootja liik`, scales = "free_y") +
  labs(
    title = paste0("Prognoosid näitajate lõikes: ", naitaja_valik),
    x = "Kvartal",
    y = "Väärtus"
  ) +
  theme_minimal() +
  theme(legend.position = "none")


# Kuva ühe lisadimensiooni graafik
prognoosid |>
  filter(
    Lisadimensioon == lisadimensiooni_valik
  ) |>
  # Funktsioonis autoplot() (pakett feasts / fabletools) värvitakse usaldusvahemike taustad (fill) ja 
  # prognoosijooned (colour) vaikimisi mudeli (.model) alusel.
  # Tahan kõik usaldusvahemikud sama värvi.
  mutate(.model = mudeli_valik[1]) |> 
  
  autoplot(ts_data, level = c(80, 95)) +
  labs(
    title = paste0("Kvartaliandmete prognoos (", mudeli_valik, ")"),
    subtitle = paste(lisadimensiooni_valik),
    x = "Kvartal",
    y = "Väärtus"
  ) +
  theme_minimal()
  
