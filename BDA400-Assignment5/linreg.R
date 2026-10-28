# Simple Linear Regression over a selected window.
# Returns slope, intercept, and predicted values for the selected window.
linreg <- function(regressionSource, regressionLength, regressionOffset) {
  if (!is.numeric(regressionSource) || length(regressionSource) == 0 ||
      anyNA(regressionSource) || any(!is.finite(regressionSource))) {
    stop("regressionSource must be a non-empty finite numeric vector")
  }
  n <- length(regressionSource)
  if (length(regressionLength) != 1 || !is.numeric(regressionLength) ||
      is.na(regressionLength) || regressionLength < 2 ||
      regressionLength != as.integer(regressionLength)) {
    stop("regressionLength must be an integer of at least 2")
  }
  if (regressionLength > n) stop("regressionLength cannot be greater than the number of elements in regressionSource")
  if (length(regressionOffset) != 1 || !is.numeric(regressionOffset) ||
      is.na(regressionOffset) || regressionOffset < 0 ||
      regressionOffset != as.integer(regressionOffset)) {
    stop("regressionOffset must be a non-negative integer")
  }
  if (regressionOffset >= regressionLength) stop("regressionOffset must be less than regressionLength")

  start_index <- max(1, n - as.integer(regressionLength) + as.integer(regressionOffset))
  end_index <- min(n, n - as.integer(regressionOffset))
  source_subset <- regressionSource[start_index:end_index]
  if (length(source_subset) < 2) stop("At least two points are required for regression")

  index_values <- seq_along(source_subset)
  mean_index <- mean(index_values)
  mean_source <- mean(source_subset)
  numerator <- sum((index_values - mean_index) * (source_subset - mean_source))
  denominator <- sum((index_values - mean_index)^2)
  if (denominator == 0) stop("Cannot calculate regression with zero denominator")
  slope <- numerator / denominator
  intercept <- mean_source - slope * mean_index
  predicted_values <- slope * index_values + intercept
  result <- list(slope = slope, intercept = intercept, predicted_values = predicted_values)
  return(result)
}
