# Calculate basic statistics for a stock data object returned by quantmod.
# Uses Adjusted close when available; otherwise uses Close.
calculate_statistics <- function(stock_data, moving_average_window = 20) {
  if (is.null(stock_data) || NROW(stock_data) == 0) stop("stock_data is empty.")
  if (!requireNamespace("quantmod", quietly = TRUE)) {
    stop("Package 'quantmod' is required to identify price columns.")
  }

  column_names <- colnames(stock_data)
  adjusted_col <- grep("Adjusted$", column_names, value = TRUE)
  close_col <- grep("Close$", column_names, value = TRUE)
  price_col <- if (length(adjusted_col)) adjusted_col[1] else if (length(close_col)) close_col[1] else NA_character_
  if (is.na(price_col)) stop("Could not find Close or Adjusted price column.")

  prices <- as.numeric(stock_data[, price_col])
  prices <- prices[is.finite(prices)]
  if (!length(prices)) stop("No valid prices were found.")

  mode_value <- function(x) {
    ux <- unique(x)
    ux[which.max(tabulate(match(x, ux)))]
  }
  window <- max(1L, as.integer(moving_average_window))
  moving_average <- if (length(prices) >= window) {
    mean(tail(prices, window))
  } else {
    mean(prices)
  }

  list(
    price_column = price_col,
    observations = length(prices),
    moving_average = moving_average,
    mean = mean(prices),
    mode = mode_value(prices),
    median = median(prices),
    standard_deviation = if (length(prices) > 1) stats::sd(prices) else NA_real_
  )
}

calculate_all_statistics <- function(stock_data_list, moving_average_window = 20) {
  if (!length(stock_data_list)) return(data.frame())
  rows <- lapply(names(stock_data_list), function(symbol) {
    stats <- calculate_statistics(stock_data_list[[symbol]], moving_average_window)
    data.frame(
      Symbol = symbol,
      PriceColumn = stats$price_column,
      Observations = stats$observations,
      MovingAverage = stats$moving_average,
      Mean = stats$mean,
      Mode = stats$mode,
      Median = stats$median,
      StandardDeviation = stats$standard_deviation,
      row.names = NULL
    )
  })
  do.call(rbind, rows)
}
