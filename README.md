
# valleybikeData <img src="man/figures/logo.png" title="logo created with hexSticker" width="160px" align="right"/>

<!-- badges: start -->

[![R build
status](https://github.com/Amherst-Statistics/valleybikeData/workflows/R-CMD-check/badge.svg)](https://github.com/Amherst-Statistics/valleybikeData/actions)
[![Lifecycle:
maturing](https://img.shields.io/badge/lifecycle-maturing-blue.svg)](https://www.tidyverse.org/lifecycle/#maturing)
<!-- badges: end -->

[ValleyBike.org](https://www.valleybike.org/) data package.

For the reproducible data curation process, check out the [Data Import
Workflow
Documentation](https://amherst-statistics.github.io/valleybikeData/).
For more specific information on the datasets and utility functions
included, see the [package
manual](https://github.com/Amherst-Statistics/valleybikeData/blob/master/valleybikeData_0.0.1.pdf).

## Installation

Install the development version from GitHub:

``` r
devtools::install_github("Amherst-Statistics/valleybikeData")
library(valleybikeData)
```

## Datasets

The package includes all currently-available ValleyBike trajectory data
in month-by-month chunks, as well as additional aggregates data on
individual users and trips. A dataset containing all permanent bikeshare
stations is also included.

| Dataset Name                                                                                                                          | Description                                                                                                                          |
| ------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------ |
| `trips`                                                                                                                               | one-row-per-trip data, including variables like duration, start and end times, start and end stations, etc.                          |
| `stations`                                                                                                                            | data on all permanent ValleyBike stations                                                                                            |
| `users`                                                                                                                               | one-row-per-user data, including variables like total number of trips, time and date of first trip, top start and end stations, etc. |
| `june2018` up to `november2018`, `april2019` up to `november2019`, `june2020` up to `december2020`, and `january2021` up to `may2021` | by-month trajectory data for all active months of ValleyBike, collected at 5-second intervals during each trip                       |

## Functions

The package also includes a variety of utility functions for importing
the raw data:

  - `import_day` (import a single day’s worth of data from source)
  - `import_month` (import a month’s worth of data from source)
  - `get_full_data` (get all available data from source)
  - `aggregate_trips` (aggregate a one-row-per-trip dataset)
  - `aggregate_users` (aggregate a one-row-per-user dataset)
  - `download_files` (download raw .csv.gz data files from online
    mirror)

Lastly, `get_monthly_dataset` is another important utility function
provided by the package. It can be used to access a monthly trajectory
dataset through the numeric representation of its corresponding month
and year. This is useful when data access must be automated, so writing
out dataset names like `"july2019"` becomes inconvenient. Instead, one
can call `get_monthly_dataset`:

``` r
# returns the july2019 dataset
get_monthly_dataset(month = 7, year = 2019)
```

For more details on what these functions do and how to use them, please
see the [package
manual](https://github.com/Amherst-Statistics/valleybikeData/blob/master/valleybikeData_0.0.1.pdf).
