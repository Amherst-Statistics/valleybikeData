
# valleybikeData <img src="man/figures/logo.png" title="logo created with hexSticker" width="160px" align="right"/>

<!-- badges: start -->

[![R build
status](https://github.com/Amherst-Statistics/valleybikeData/workflows/R-CMD-check/badge.svg)](https://github.com/Amherst-Statistics/valleybikeData/actions)
[![Lifecycle:
maturing](https://img.shields.io/badge/lifecycle-maturing-blue.svg)](https://www.tidyverse.org/lifecycle/#maturing)
<!-- badges: end -->

[ValleyBike Share](https://www.valleybike.org/) data package.

Check out the [Data Import Workflow
Documentation](https://amherst-statistics.github.io/valleybike/) and the
[package
manual](https://github.com/Amherst-Statistics/valleybikeData/blob/master/valleybikeData_0.0.1.pdf)
for more details.

## Installation

Install the development version from GitHub:

``` r
devtools::install_github("Amherst-Statistics/valleybikeData")
library(valleybikeData)
```

## Datasets

The package includes all the currently available bike trajectory data
since 2018, as well as additional metadata on bike stations, individual
users, and individual trips. The datasets included are:

  - `stations` (data on all permanent ValleyBike stations)
  - `users` (de-identified user data for 2018-2020)
  - `trips` (trip data for 2018-2020)
  - `june2018`, `july2018`, `august2018`, `september2018`,
    `october2018`, `november2018`, `april2019`, `may2019`, `june2019`,
    `july2019`, `august2019`, `september2019`, `october2019`,
    `november2019`, `june2020`, `july2020`, `august2020`,
    `september2020`, and `october2020` (by-month trajectory data for all
    19 active months of ValleyBike, collected at 5-second intervals
    during each trip)

## Functions

The package also includes a variety of utility functions for importing
the raw data:

  - `download_data`
  - `import_day`
  - `import_month`
  - `import_full`
  - `aggregate_trips`
  - `aggregate_users`

For more details on what these functions do and how to use them, please
see the [Data Import Workflow
Documentation](https://amherst-statistics.github.io/valleybike/).
