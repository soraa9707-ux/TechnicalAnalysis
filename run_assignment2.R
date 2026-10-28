# Run this file from the repository root in RStudio.
required_packages <- c("quantmod", "zoo")
missing_packages <- required_packages[
  !vapply(required_packages, requireNamespace, logical(1), quietly = TRUE)
]
if (length(missing_packages)) {
  stop("Install required packages first: install.packages(c(",
       paste(sprintf('"%s"', missing_packages), collapse = ", "),
       "))")
}

source("Assignment2/R/load_stock_data.R")
source("Assignment2/R/calculate_statistics.R")
source("Assignment2/R/display_output.R")

stock_data <- load_stock_data("Assignment2/portfolio.txt")
statistics_table <- calculate_all_statistics(stock_data, moving_average_window = 20)
display_stock_output(stock_data, statistics_table)
