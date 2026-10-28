# Exponential Moving Average (EMA)
# Seeds the EMA with the first data point, as described in the assignment.
ema <- function(data, period) {
  if (!is.numeric(data) || length(data) == 0) stop("data must be a non-empty numeric vector")
  if (length(period) != 1 || !is.numeric(period) || is.na(period) ||
      period < 1 || period != as.integer(period)) stop("period must be a positive integer")
  if (anyNA(data) || any(!is.finite(data))) stop("data must contain only finite values")

  period <- as.integer(period)
  multiplier <- 2 / (period + 1)
  ema_values <- numeric(length(data))
  for (i in seq_along(data)) {
    if (i == 1) {
      ema_values[i] <- data[i]
    } else {
      ema_values[i] <- (data[i] - ema_values[i - 1]) * multiplier + ema_values[i - 1]
    }
  }
  return(ema_values)
}
