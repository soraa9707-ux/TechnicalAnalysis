# Relative Strength Index (RSI), using Wilder smoothing.
rsi <- function(data, period) {
  if (!is.numeric(data) || length(data) < 2) stop("data must be a numeric vector with at least two values")
  if (length(period) != 1 || !is.numeric(period) || is.na(period) ||
      period < 1 || period != as.integer(period)) stop("period must be a positive integer")
  if (anyNA(data) || any(!is.finite(data))) stop("data must contain only finite values")
  period <- as.integer(period)
  if (length(data) <= period) stop("data length must be greater than period + 0 to calculate RSI")

  diff_values <- diff(data)
  gains <- pmax(diff_values, 0)
  losses <- pmax(-diff_values, 0)
  rsi_values <- rep(NA_real_, length(data))

  avg_gain <- mean(gains[seq_len(period)])
  avg_loss <- mean(losses[seq_len(period)])
  idx <- period + 1
  if (avg_loss == 0 && avg_gain == 0) {
    rsi_values[idx] <- 50
  } else if (avg_loss == 0) {
    rsi_values[idx] <- 100
  } else {
    rsi_values[idx] <- 100 - (100 / (1 + avg_gain / avg_loss))
  }

  if (idx < length(data)) {
    for (i in (idx + 1):length(data)) {
      avg_gain <- (avg_gain * (period - 1) + gains[i - 1]) / period
      avg_loss <- (avg_loss * (period - 1) + losses[i - 1]) / period
      if (avg_loss == 0 && avg_gain == 0) {
        rsi_values[i] <- 50
      } else if (avg_loss == 0) {
        rsi_values[i] <- 100
      } else {
        rsi_values[i] <- 100 - (100 / (1 + avg_gain / avg_loss))
      }
    }
  }
  return(rsi_values)
}
