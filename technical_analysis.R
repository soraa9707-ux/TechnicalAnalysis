# BDA400 Assignment 2: Technical Analysis using R, Preliminary Stage
# Student: Prashanth Patel
# Repository folder: TechnicalAnalysis/Assignment2
#
# Run from this folder in RStudio. The script downloads market data from Yahoo
# Finance through quantmod, so an internet connection is required.

required_packages <- c("quantmod", "TTR", "ggplot2")
missing_packages <- required_packages[
  !vapply(required_packages, requireNamespace, logical(1), quietly = TRUE)
]
if (length(missing_packages)) {
  install.packages(missing_packages, repos = "https://cloud.r-project.org")
}

suppressPackageStartupMessages({
  library(quantmod)
  library(TTR)
  library(ggplot2)
})

portfolio_file <- "portfolio.txt"
if (!file.exists(portfolio_file)) {
  stop("portfolio.txt was not found. Set the RStudio working directory to Assignment2.")
}

# One symbol per line; blank lines and comments beginning with # are ignored.
read_portfolio <- function(path = portfolio_file) {
  symbols <- readLines(path, warn = FALSE, encoding = "UTF-8")
  symbols <- trimws(symbols)
  symbols <- symbols[nzchar(symbols) & !startsWith(symbols, "#")]
  symbols <- unique(toupper(symbols))
  if (!length(symbols)) stop("No stock symbols found in portfolio.txt.")
  symbols
}

# Import OHLCV data for every symbol into a named list.
load_stock_data <- function(symbols = read_portfolio(),
                            from = Sys.Date() - 365,
                            to = Sys.Date()) {
  result <- list()
  failures <- character()
  for (symbol in symbols) {
    message("Downloading ", symbol, " ...")
    item <- tryCatch(
      suppressWarnings(getSymbols(symbol, src = "yahoo",
        from = from, to = to, auto.assign = FALSE)),
      error = function(e) {
        failures <<- c(failures, paste0(symbol, ": ", conditionMessage(e)))
        NULL
      }
    )
    if (!is.null(item) && NROW(item) > 0) result[[symbol]] <- item
  }
  if (!length(result)) {
    stop("No stock data downloaded. Check internet access and symbol validity.")
  }
  if (length(failures)) warning(paste(failures, collapse = "\n"))
  result
}

# Statistical mode for numeric values. For continuous price series, exact
# values may rarely repeat; NA is returned if there is no repeated value.
numeric_mode <- function(x) {
  x <- as.numeric(na.omit(x))
  if (!length(x)) return(NA_real_)
  counts <- table(x)
  winners <- names(counts)[counts == max(counts)]
  if (max(counts) < 2) return(NA_real_)
  as.numeric(winners[1])
}

# Calculate mean, mode, median, standard deviation, and a 20-day moving
# average for adjusted closing prices.
calculate_statistics <- function(stock_xts, symbol = deparse(substitute(stock_xts)),
                                 ma_window = 20) {
  if (NROW(stock_xts) == 0) stop("Input stock data is empty.")
  adjusted <- as.numeric(Ad(stock_xts))
  adjusted <- adjusted[is.finite(adjusted)]
  if (!length(adjusted)) stop("No valid adjusted close prices available.")
  moving_average <- TTR::SMA(Ad(stock_xts), n = ma_window)
  data.frame(
    Symbol = symbol,
    Observations = length(adjusted),
    Mean_Adjusted_Close = mean(adjusted),
    Mode_Adjusted_Close = numeric_mode(adjusted),
    Median_Adjusted_Close = median(adjusted),
    SD_Adjusted_Close = if (length(adjusted) > 1) sd(adjusted) else NA_real_,
    Latest_Adjusted_Close = tail(adjusted, 1),
    Latest_MA20 = as.numeric(tail(moving_average, 1)),
    stringsAsFactors = FALSE
  )
}

# Display the latest rows and compute a combined statistics table.
display_stock_data <- function(stock_data, rows = 6) {
  for (symbol in names(stock_data)) {
    cat("\n================", symbol, "================\n")
    print(utils::tail(stock_data[[symbol]], rows))
  }
  invisible(stock_data)
}

calculate_portfolio_statistics <- function(stock_data) {
  stats <- lapply(names(stock_data), function(symbol) {
    calculate_statistics(stock_data[[symbol]], symbol = symbol)
  })
  do.call(rbind, stats)
}

plot_stock_data <- function(stock_data, output_dir = "outputs") {
  dir.create(output_dir, showWarnings = FALSE, recursive = TRUE)
  for (symbol in names(stock_data)) {
    df <- data.frame(
      Date = as.Date(index(stock_data[[symbol]])),
      Adjusted_Close = as.numeric(Ad(stock_data[[symbol]])),
      MA20 = as.numeric(TTR::SMA(Ad(stock_data[[symbol]]), n = 20))
    )
    p <- ggplot(df, aes(x = Date)) +
      geom_line(aes(y = Adjusted_Close), linewidth = 0.45, na.rm = TRUE) +
      geom_line(aes(y = MA20), linewidth = 0.7, na.rm = TRUE,
                linetype = "dashed") +
      labs(title = paste(symbol, "Adjusted Close and 20-day Moving Average"),
           x = "Date", y = "Price (USD)",
           caption = "Source: Yahoo Finance via quantmod; dashed line = MA20") +
      theme_minimal(base_size = 11)
    ggsave(file.path(output_dir, paste0(symbol, "_price_ma20.png")),
           plot = p, width = 8, height = 4.5, dpi = 150)
  }
}

# Main workflow
symbols <- read_portfolio()
stock_data <- load_stock_data(symbols)
display_stock_data(stock_data)
statistics_table <- calculate_portfolio_statistics(stock_data)
print(statistics_table, row.names = FALSE)
write.csv(statistics_table, "outputs_statistics.csv", row.names = FALSE)
plot_stock_data(stock_data)

cat("\nFinished. Review outputs_statistics.csv and the outputs/ plots.\n")
