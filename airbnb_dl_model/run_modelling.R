library(caret)
library(tidyverse)
library(keras)

source(file.path(Sys.getenv("MODEL_DIRECTORY"), "train_model.R"))

trained_model <- prepare_dl_model()

save(trained_model, file = file.path(Sys.getenv("MODEL_DIRECTORY"), "trained_model.RData"))