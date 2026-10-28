# Simple Moving Average (SMA)
# Uses only base R functions.
sma <- function(data, period) {
  if (!is.numeric(data) || length(data) == 0) stop("data must be a non-empty numeric vector")
  if (length(period) != 1 || !is.numeric(period) || is.na(period) ||
      period < 1 || period != as.integer(period)) stop("period must be a positive integer")
  if (length(data) < period) stop("Data length should be greater than or equal to the period")
  if (anyNA(data) || any(!is.finite(data))) stop("data must contain only finite values")

  period <- as.integer(period)
  sma_values <- numeric(length(data) - period + 1)
  for (i in seq_along(sma_values)) {
    current_window <- data[i:(i + period - 1)]
    sma_values[i] <- sum(current_window) / period
  }
  return(sma_values)
}
