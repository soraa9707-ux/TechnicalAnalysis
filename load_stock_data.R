# Load stock data for each symbol listed in portfolio.txt
load_stock_data <- function(portfolio_file = "Assignment2/portfolio.txt",
                            from = Sys.Date() - 365,
                            to = Sys.Date()) {
  if (!requireNamespace("quantmod", quietly = TRUE)) {
    stop("Package 'quantmod' is required. Install it with install.packages('quantmod').")
  }
  if (!file.exists(portfolio_file)) stop("Portfolio file not found: ", portfolio_file)

  symbols <- trimws(readLines(portfolio_file, warn = FALSE))
  symbols <- symbols[nzchar(symbols)]
  if (!length(symbols)) stop("portfolio.txt does not contain any stock symbols.")

  stock_data <- list()
  for (symbol in unique(symbols)) {
    message("Downloading ", symbol, " ...")
    result <- tryCatch(
      quantmod::getSymbols(symbol, src = "yahoo", from = from, to = to,
                           auto.assign = FALSE),
      error = function(e) {
        warning("Could not download ", symbol, ": ", conditionMessage(e))
        NULL
      }
    )
    if (!is.null(result)) stock_data[[symbol]] <- result
  }
  if (!length(stock_data)) warning("No stock data was downloaded.")
  stock_data
}
