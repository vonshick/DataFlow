library(caret)
library(tidyverse)
library(keras)

source(file.path(Sys.getenv("MODEL_DIRECTORY"), "train_model.R"))

prepare_dl_model()