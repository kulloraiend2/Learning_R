# 
# Paketi fable kasutamise näide
# Tidyverts ökosüsteem: fable (+ tsibble, feasts)
# Rob Hyndmani meeskonna loodud kaasaegne mantlipärija legendaarsele forecast paketile.
# Rob Hyndmani aegridade õpik (Forecasting: Principles and Practice)
# 
# Andmestruktuur: Põhineb tsibble formaadil (aegrida andmeraamina / tidy data).
# 
# Mudelivalik: Klassikalised mudelid (ARIMA, ETS, NNETAR, CROSTON, TSLM) ja mudelite lihtne kombineerimine (ansamblid).
# 
# Tugevused: Töötab loomulikult dplyr-i süntaksiga; võimaldab üheainsa funktsioonikutsungiga sobitada mudeleid 
#            tuhandetele eri gruppidele/aegridadele paralleelselt; automaatne mudelite parameetrite valik.
# 
# R-i ökosüsteem on ajalooliselt üks rikkalikumaid ja küpsemaid keskkondi aegridade analüüsiks ja prognoosimiseks. 
# Paketid jagunevad laias laastus kolme põlvkonda/arhitektuuri: 
#  klassikalised statistilised paketid (forecast), 
#  moodne tidyverse-põhine ökosüsteem (Tidyverts) ning 
#  masinõppele suunatud raamistikud (tidymodels).


# # 1. Paigalda ja laadi pakett
# install.packages("installr")
# library(installr)
# 
# # 2. Käivita R uuendusviisard
# updateR()


# Veendu, et pakett on olemas
if (!require("tsibble")) install.packages("tsibble")
if (!require("fable")) install.packages("fable")
if (!require("feasts")) install.packages("feasts")
if (!require("dplyr")) install.packages("dplyr")

library(tsibble)
library(fable)
library(feasts)
library(dplyr)

# fpp3 metapakett
# Kui teed Rob Hyndmani aegridade õpiku (Forecasting: Principles and Practice) näiteid, 
# on kõige mugavam laadida kogu komplekt korraga paketiga fpp3 
# (see laadib automaatselt tsibble, tsibbledata, fable, feasts ja dplyr)
if (!require("fpp3")) install.packages("fpp3")
library(fpp3)

# 1. Näidisandmestik: Austraalia igakuine õlletootmine (tsibble formaat)
data <- aus_production |>
  select(Quarter, Beer) |>
  filter(!is.na(Beer))

# 2. Jaotame andmed treening- ja testkomplektiks (viimased 8 kvartalit testiks)
train_data <- data |> slice_head(n = nrow(data) - 8)
test_data  <- data |> slice_tail(n = 8)

# 3. Mudelite automaatne sobitamine treeningandmetel
# Auto-ETS, Auto-ARIMA ja nende kombinatsioon (kombineeritud mudel)
fits <- train_data |>
  model(
    auto_ets   = ETS(Beer),
    auto_arima = ARIMA(Beer),
    ensemble   = (ETS(Beer) + ARIMA(Beer)) / 2
  )

# 4. Prognoosime testperioodile (h = 8 kvartalit)
forecasts <- fits |>
  forecast(new_data = test_data)

# 5. Mudelite hindamine testandmestiku peal (out-of-sample accuracy)
accuracy_table <- forecasts |>
  accuracy(data) |>
  select(.model, RMSE, MAE, MAPE, MASE) |>
  arrange(RMSE)

print(accuracy_table)

# 6. Parima mudeli valik madalaima RMSE järgi ja lõplik prognoos tulevikku
best_model_name <- accuracy_table$.model[1]
cat("\nParim mudel testandmete põhjal on:", best_model_name, "\n")

# Treenime parima mudeli kogu andmestikul (train + test) ning teeme prognoosi tulevikku
final_fit <- data |>
  model(best_model = if (best_model_name == "auto_ets") ETS(Beer) else ARIMA(Beer))

future_forecast <- final_fit |>
  forecast(h = "2 years")

# Trükime tulevikuprognoosi koos 95% usaldusvahemikega
future_forecast |>
  hilo(level = 95) |>
  select(Quarter, .mean, `95%`)

# Visualiseeri tulevikuprognoos koos 95% usaldusvahemikega
future_forecast |>
  # hilo(level = 95) |>
  # select(Quarter, .mean, `95%`) |> 
  autoplot(data)
