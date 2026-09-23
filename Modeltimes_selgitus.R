# 
# modeltime ja timetk moodustavad R-is võimsa masinõppepõhise aegridade raamistiku (Tidymodels ökosüsteemil).
# 
# Kullo 23.08.2026
# 
# Erinevalt klassikalisest statistikast (fable/ARIMA) võimaldab see raamistik kasutada kaasaegseid masinõppe algoritme 
# (nt Random Forest, XGBoost, ElasticNet jne), genereerides ajatemplist automaatselt tunnuseid (feature engineering).
# Kogu töövoog (Modeltime 6 sammu)

# Andmete ettevalmistamine ja jagamine (timetk::time_series_split)  
# Eeltöötlus ja tunnuste inseneeria (recipes::step_timeseries_signature jne)  
# Mudelite spetsifitseerimine ja treenimine (parsnip + workflows)  
# Mudelite koondamine tabelisse (modeltime_table)  
# Kalibreerimine ja täpsuse hindamine testandmetel (modeltime_calibrate, modeltime_accuracy)  
# Uuesti treenimine täisandmetel ja tuleviku prognoos (modeltime_refit, modeltime_forecast) 

# 1. Vajalikud paketid
if (!require("tidymodels")) install.packages("tidymodels")
library(tidymodels)
if (!require("modeltime")) install.packages("modeltime")
library(modeltime)
library(timetk)
library(dplyr)
library(lubridate)
if (!require("ranger")) install.packages("ranger")
library(ranger)   # Random Forest mootor
library(xgboost)  # XGBoost mootor

# 2. Andmete laadimine (kasutame timetk kaasasolevat kuupõhist M4 andmestikku)
data_tbl <- m4_monthly |>
  filter(id == "M750") |>
  select(date, value)

# 3. Andmete jagamine treening- ja testkomplektiks (nt viimased 12 kuud testiks)
splits <- time_series_split(
  data_tbl, 
  date_var   = date, 
  assess     = "12 months", 
  cumulative = TRUE
)

# 4. Tunnuste inseneeria (Feature Engineering) timetk + recipes abil
# step_timeseries_signature genereerib kuupäevast ~30 tunnust (kuu, kvartal, aasta jne)
recipe_spec <- recipe(value ~ date, data = training(splits)) |>
  # 1. Genereerime kuupäevast tunnused (date_year, date_month jne)
  step_timeseries_signature(date) |>
  # 2. EEMALDAME algse date veeru, et XGBoost ei saaks mitte-arvulist veergu
  step_rm(date) |>
  # 3. Eemaldame üleliigsed kellaja tunnused (kui tegu on kuupõhiste andmetega)
  step_rm(contains("am.pm"), contains("hour"), contains("minute"), contains("second")) |>
  # 4. Fourier sesoonsuse tunnused (kasutades tuletatud numbrilist aega või indeksit)
  step_dummy(all_nominal_predictors(), one_hot = TRUE) |>
  step_zv(all_predictors())

# 5. Mudelite loomine ja sidumine töövoogudeks (Workflows)

# Mudel A: Random Forest (ML)
model_rf <- rand_forest(trees = 500, min_n = 5) |>
  set_engine("ranger") |>
  set_mode("regression")

workflow_rf <- workflow() |>
  add_recipe(recipe_spec) |>
  add_model(model_rf) |>
  fit(training(splits))

# Mudel B: XGBoost (Gradient Boosting)
model_xgb <- boost_tree(trees = 300, learn_rate = 0.05) |>
  set_engine("xgboost") |>
  set_mode("regression")

workflow_xgb <- workflow() |>
  add_recipe(recipe_spec) |>
  add_model(model_xgb) |>
  fit(training(splits))

# Mudel C: Auto-ARIMA (Klassikaline võrdlusbaas Modeltime kaudu)
model_arima <- arima_reg() |>
  set_engine("auto_arima") |>
  fit(value ~ date, data = training(splits))

# 6. Mudelite koondtabel (Modeltime Table)
models_tbl <- modeltime_table(
  workflow_rf,
  workflow_xgb,
  model_arima
)

# 7. Kalibreerimine testandmetel ja täpsuse arvutamine (RMSE, MAE, MAPE jne)
calibration_tbl <- models_tbl |>
  modeltime_calibrate(new_data = testing(splits))

# Kuvame mudelite täpsusmõõdikud
accuracy_table <- calibration_tbl |>
  modeltime_accuracy()

print(accuracy_table)

# 8. Testperioodi prognoosi visualiseerimine
calibration_tbl |>
  modeltime_forecast(
    new_data    = testing(splits),
    actual_data = data_tbl
  ) |>
  plot_modeltime_forecast(.interactive = FALSE)

# 9. Tulevikku prognoosimine (Refit täisandmetel + 12 kuud ette)
future_forecast_tbl <- calibration_tbl |>
  modeltime_refit(data = data_tbl) |>
  modeltime_forecast(
    h           = "12 months",
    actual_data = data_tbl
  )

# Tuleviku prognoosigraafik
future_forecast_tbl |>
  plot_modeltime_forecast(
    .title       = "Masinõppe prognoosid (Random Forest, XGBoost, ARIMA)",
    .interactive = FALSE
  )
