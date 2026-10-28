# Display downloaded data and statistics; save CSVs and PNG price charts.
display_stock_output <- function(stock_data_list, statistics_table,
                                 output_dir = "Assignment2/output") {
  dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)

  if (!length(stock_data_list)) {
    message("No stock data available to display.")
    return(invisible(NULL))
  }

  for (symbol in names(stock_data_list)) {
    cat("\n==================== ", symbol, " ====================\n", sep = "")
    print(utils::head(stock_data_list[[symbol]]))
    data_path <- file.path(output_dir, paste0(symbol, "_data.csv"))
    data_frame <- data.frame(Date = as.Date(zoo::index(stock_data_list[[symbol]])),
                             zoo::coredata(stock_data_list[[symbol]]),
                             check.names = FALSE)
    utils::write.csv(data_frame, data_path, row.names = FALSE)

    price_col <- grep("Adjusted$", colnames(stock_data_list[[symbol]]), value = TRUE)
    if (!length(price_col)) price_col <- grep("Close$", colnames(stock_data_list[[symbol]]), value = TRUE)
    if (length(price_col)) {
      png(file.path(output_dir, paste0(symbol, "_price_chart.png")),
          width = 1000, height = 600)
      plot(zoo::index(stock_data_list[[symbol]]),
           as.numeric(stock_data_list[[symbol]][, price_col[1]]),
           type = "l", xlab = "Date", ylab = "Price",
           main = paste(symbol, "stock price"))
      dev.off()
    }
  }

  cat("\n==================== Summary statistics ====================\n")
  print(statistics_table)
  utils::write.csv(statistics_table,
                   file.path(output_dir, "summary_statistics.csv"),
                   row.names = FALSE)
  invisible(statistics_table)
}
