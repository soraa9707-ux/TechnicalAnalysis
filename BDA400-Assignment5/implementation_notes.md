# Implementation Notes — Assignment 5

All functions use standard/base R operations and follow the function names in the assignment templates.

## 1. Simple Moving Average (`sma`)
Checks that the input is numeric and the period is a positive integer. For each complete window, it sums the values and divides by the period. It returns `length(data) - period + 1` values.

## 2. Exponential Moving Average (`ema`)
Uses multiplier `2 / (period + 1)`. The first EMA is initialized to the first input value; each later EMA uses the current input, previous EMA, and multiplier.

## 3. Moving Average Convergence Divergence (`macd`)
Computes short and long EMAs, subtracts the long EMA from the short EMA to obtain the MACD line, computes an EMA of that line as the signal line, and subtracts the signal line to obtain the histogram.

## 4. Standard Deviation (`stdev`)
Calculates the mean, differences from the mean, squared differences, population variance (sum of squared differences divided by `n`), and square root of the variance. This matches the formula in the assignment.

## 5. Linear Regression (`linreg`)
Selects the window based on `regressionLength` and `regressionOffset`, calculates the least-squares slope and intercept, and returns predictions for the selected window. The returned `predicted_values` correspond to `source_subset`, not the full input vector.

## 6. Relative Strength Index (`rsi`)
Calculates consecutive changes, separates gains and losses, initializes average gain/loss over the first period, then applies Wilder's smoothing. Values before the first available RSI are `NA`.

## 7. Stochastic RSI (`stoch_rsi`)
Calculates RSI first, normalizes it within a rolling `k_period` window to form `%K`, and calculates `%D` as the simple moving average of `%K` over `d_period`. Output is a list with `k_line` and `d_line`.

## 8. Crossover (`crossover`)
Returns `"Up"` when `arr1` crosses above `arr2`, `"Down"` when it crosses below, and `"None"` otherwise.

## 9. Crossunder (`crossunder`)
Returns `"True"` at points where `arr1` crosses below `arr2`, `"False"` otherwise, and `"None"` at the first point where no previous comparison is possible.

## Validation

Run `Rscript tests/test_indicators.R` from the repository root. The tests use small known inputs and check output values, lengths, and crossover events. If R is not installed, install it first and rerun the command.
