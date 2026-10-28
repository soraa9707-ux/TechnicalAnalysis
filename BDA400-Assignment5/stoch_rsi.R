# Stochastic RSI (%K and %D).
# Requires rsi() and sma() to be loaded first.
stoch_rsi <- function(data, period, k_period, d_period) {
  rsi_values <- rsi(data, period)
  k_values <- rep(NA_real_, length(rsi_values))
  for (i in seq_along(rsi_values)) {
    start <- max(1, i - k_period + 1)
    window <- rsi_values[start:i]
    window <- window[!is.na(window)]
    if (length(window) == k_period) {
      lowest <- min(window)
      highest <- max(window)
      if (highest == lowest) {
        k_values[i] <- 0
      } else {
        k_values[i] <- (rsi_values[i] - lowest) / (highest - lowest)
      }
    }
  }
  d_values <- rep(NA_real_, length(k_values))
  for (i in seq_along(k_values)) {
    if (i >= d_period) {
      window <- k_values[(i - d_period + 1):i]
      if (all(!is.na(window))) d_values[i] <- sum(window) / d_period
    }
  }
  return(list(k_line = k_values, d_line = d_values))
}
