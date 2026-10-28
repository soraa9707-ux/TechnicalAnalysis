# TechnicalAnalysis — BDA400 Assignment 2

This repository contains the preliminary-stage R project for BDA400: Technical Analysis using R.

## Folder structure
- `Assignment2/portfolio.txt` — stock symbols, one per line.
- `Assignment2/R/load_stock_data.R` — reads symbols and downloads stock data with `quantmod`.
- `Assignment2/R/calculate_statistics.R` — computes moving average, mean, mode, median, and standard deviation.
- `Assignment2/R/display_output.R` — displays data/statistics and saves visualizations.
- `Assignment2/R/run_assignment2.R` — runs the scripts together.
- `Assignment2/docs/Assignment2_Report.docx` — report template and setup instructions.
- `Assignment2/docs/cover_page.md` — cover page template.
- `Assignment2/screenshots/` — add your own screenshots of GitHub, R/RStudio installation, and package installation.
- `Assignment2/output/` — generated CSV and PNG outputs.

## Requirements
Install R and RStudio, then run in R or RStudio:

```r
install.packages(c("quantmod", "TTR"))
```

Open `Assignment2/R/run_assignment2.R` in RStudio and set the working directory to the repository root (or run the script from the repository root). Then run the script.

## Important
- The default `portfolio.txt` uses AAPL, MSFT, and GOOGL as example symbols. Replace them with your own portfolio if required.
- Stock data download requires an internet connection and depends on the data provider being available.
- The report contains screenshot placeholders. Replace them with genuine screenshots from your own computer; do not submit placeholders as real evidence.
- Add your actual GitHub repository URL and verify the college naming convention before submission.
