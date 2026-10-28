# BDA400 Assignment 5 — Technical Analysis using R (Development Phase)

**Student:** Piyush Tailor  
**Course:** BDA400 — Data Science Tools and Techniques  
**Assignment:** Assignment 5 — Technical Analysis using R, Development Phase

## Contents

- `R/` — one R script per technical indicator.
- `tests/test_indicators.R` — small base-R checks for the functions.
- `docs/implementation_notes.md` — brief explanations of each implementation.
- `docs/cover_page.md` — cover-page template. Add your GitHub repository URL before submitting.

## Requirements

- Base R only; no external packages are required.
- Install R from CRAN if it is not already installed.
- Run commands from the repository root folder.

## How to run

Open R or RStudio and source the scripts in dependency order:

```r
source("R/sma.R")
source("R/ema.R")
source("R/macd.R")
source("R/stdev.R")
source("R/linreg.R")
source("R/rsi.R")
source("R/stoch_rsi.R")
source("R/crossover.R")
source("R/crossunder.R")
```

Example:

```r
prices <- c(100, 102, 101, 105, 108, 107, 110)
sma(prices, period = 3)
ema(prices, period = 3)
macd(prices, short_period = 3, long_period = 5, signal_period = 2)
stdev(prices)
linreg(prices, regressionLength = 5, regressionOffset = 0)
rsi(prices, period = 3)
stoch_rsi(prices, period = 3, k_period = 3, d_period = 3)
crossover(c(1, 2, 4), c(2, 2, 3))
crossunder(c(3, 2, 1), c(2, 2, 2))
```

Run the basic tests from the repository root using:

```bash
Rscript tests/test_indicators.R
```

## Notes

- SMA returns one value per complete rolling window, so its output is shorter than the input.
- EMA follows the assignment pseudocode and seeds the first EMA value with the first data value.
- `stdev()` uses the population formula shown in the assignment (division by `n`).
- RSI leaves initial values as `NA` until the first period is available.
- MACD, RSI, and StochRSI are educational implementations based on the supplied assignment pseudocode, not investment advice.
- No real stock dataset was included with this file package. If your instructor expects the dataset from Assignment 1, add that dataset to `data/` and document its source.

## GitHub upload

1. Create a new repository on GitHub, for example `BDA400-Assignment5`.
2. Upload all files and folders in this package.
3. Copy the repository URL into `docs/cover_page.md`.
4. Submit the required PDF/Word explanation and cover page through your LMS, in addition to the repository link, as your course instructions require.
