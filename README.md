# valleybike <img src="man/figures/logo.png" title="logo created with hexSticker" width="160px" align="right"/>

[ValleyBike Share](https://www.valleybike.org/) data package and helper functions. Check out the data documentation [here](https://amherst-statistics.github.io/valleybike/).

## Installation

Install the development version from GitHub:

```{r}
# install.packages("devtools")
devtools::install_github("Amherst-Statistics/valleybike")
library(valleybike)
```

## Datasets

The package includes all the currently available bike trajectory data since 2018, as well as additional metadata on bike stations, individual users, and individual trips. The datasets included are:

- `stations` (data on all permanent ValleyBike stations)
- `users` (deitentified user data for 2018-2020)
- `trips` (trip data for 2018-2020)
- `june2018`, `july2018`, `august2018`, `september2018`, `october2018`, `november2018`, `april2019`, `may2019`, `june2019`, `july2019`, `august2019`, `september2019`, `october2019`, `november2019`, `june2020`, `july2020`, and `august2020` (by-month trajectory data for 2018-2020, collected at 5-second intervals for every trip)

To use any of the datasets above, you can load them explicitly into your environment:

```{r}
data(trips)
```

## Functions (Under Development)

The package also includes a variety of utility functions, which aim to make the data more accessible and easier to analyze.

Functions for a particular trip:

- `get_trajectory_data`
- `get_duration`
- `get_distance`
- `get_stops`

Functions for a group of trips:

- `get_average_duration`
