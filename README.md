# valleybike <img src="man/figures/logo.png" title="logo created with hexSticker" width="160px" align="right"/>

[ValleyBike Share](https://www.valleybike.org/) data package and helper functions.

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
- `june2018`, `november2018` (for the active 2018 months) `april2019` to `november2019` (by-month trajectory data, collected at 5-second intervals for every trip)

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
