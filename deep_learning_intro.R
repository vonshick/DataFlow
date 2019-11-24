# Script based on the iDash deep learning workshop

library(caret)
library(tidyverse)
library(glue)
library(keras)
library(tictoc)

evalutate_model <- function(model, test_x, test_y) {
  cat("\n\n\n Model evaluation \n")
  model %>% 
    evaluate(
      x = test_x,
      y = test_y
    )
}

# Creating a baseline model predicting that the price will be equal 
# to the average price in a given neighbourhood.
check_baseline_model <- function(data) {
  baseline_df <- data %>%
    group_by(neighbourhood) %>%
    mutate(
      diff = abs(price - mean(price))
    ) %>% ungroup()
  
  mean_average_error <- round(mean(baseline_df$diff),2)
  print(paste("Average error of the dataset : ", mean_average_error, sep = ""))
  
  return(mean_average_error)
}

train_model <- function(train_x, train_y) { 
  # Defining the model structure
  model <- keras_model_sequential()
  model %>%
    layer_dense(256, input_shape = 6, 'relu') %>%
    layer_dense(128, 'relu') %>%
    layer_dense(32, 'relu') %>%
    layer_dense(1)
  
  # Defining how the model is trained
  model %>%
    compile(
      loss = 'mean_squared_error',
      optimizer = 'adam',
      metrics = 'mae'
    )
  
  # Fit the model
  results <- model %>% 
    fit(
      x = train_x,
      y = train_y,
      epochs = 5,
      validation_split = 0.1
    )
  
  return(list(model = model, results = results))
}

normalize_data <- function(train_x, test_x) {
  # Calculating of the mean and std dev.
  scaler <- preProcess(
    train_x,
    method = c("center", "scale")
  )
  # Scaling the train set
  train_x_scaled <- predict(scaler, train_x)
  
  # Scaling the test set with the scaler based on the training set
  test_x_scaled <- predict(scaler, test_x)
  
  return(list(train_x = train_x_scaled, test_x = test_x_scaled, scaler = scaler))
}

# Split data to train/ test based on specific list of columns.
# data - data frame
# x_cols - vector of column names
# y_col - output column name 
split_data <- function(data, input_columns, output_column) {
  # Create training set
  set.seed(1)
  train <- data %>% sample_frac(.9)
  
  # Create test set
  test <- setdiff(data, train)
  
  # Split predictors and labels
  train_data <- train %>% select(!! input_columns)
  test_data <- test %>% select(!! input_columns)
  train_label <- train %>% select(!! output_column)
  test_label <- test %>% select(!! output_column)
  
  list(train_data, test_data, train_label, test_label)
}

replace_na_in_dataset <- function(data) {
  mean_beds <- mean(data$beds, na.rm = TRUE)
  mean_review_scores_rating <- mean(data$review_scores_rating, na.rm = TRUE)
  
  data %>% replace_na(
    list(
      'beds' = mean_beds,
      'review_scores_rating' = mean_review_scores_rating
    )
  ) %>%
    return()
}

prepare_dl_model <- function() {
  airbnb_dataset <- readRDS("airbnb_dataset.RDS") %>%
    replace_na_in_dataset()
  
  check_baseline_model(airbnb_dataset)
  
  splitted_df <- split_data(airbnb_dataset, c('latitude', 'longitude', 'number_of_reviews', 'accommodates', 'beds', 'review_scores_rating'), 'price')
  train_x <- splitted_df[[1]] %>% as.matrix()
  test_x <- splitted_df[[2]] %>% as.matrix()
  train_y <- splitted_df[[3]] %>% as.matrix()
  test_y <- splitted_df[[4]] %>% as.matrix()
  
  normalized <- normalize_data(train_x, test_x)
  
  trained_model <- train_model(normalized$train_x, train_y)
  
  evalutate_model(trained_model$model, normalized$test_x, test_y)
  
  return(trained_model)
} 

