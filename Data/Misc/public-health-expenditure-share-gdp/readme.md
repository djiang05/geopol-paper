# Government health spending as a share of GDP - Data package

This data package contains the data that powers the chart ["Government health spending as a share of GDP"](https://ourworldindata.org/grapher/public-health-expenditure-share-gdp?v=1&csvType=full&useColumnShortNames=false) on the Our World in Data website. It was downloaded on May 08, 2025.

### Active Filters

A filtered subset of the full data was downloaded. The following filters were applied:

## CSV Structure

The high level structure of the CSV file is that each row is an observation for an entity (usually a country or region) and a timepoint (usually a year).

The first two columns in the CSV file are "Entity" and "Code". "Entity" is the name of the entity (e.g. "United States"). "Code" is the OWID internal entity code that we use if the entity is a country or region. For normal countries, this is the same as the [iso alpha-3](https://en.wikipedia.org/wiki/ISO_3166-1_alpha-3) code of the entity (e.g. "USA") - for non-standard countries like historical countries these are custom codes.

The third column is either "Year" or "Day". If the data is annual, this is "Year" and contains only the year as an integer. If the column is "Day", the column contains a date string in the form "YYYY-MM-DD".

The final column is the data column, which is the time series that powers the chart. If the CSV data is downloaded using the "full data" option, then the column corresponds to the time series below. If the CSV data is downloaded using the "only selected data visible in the chart" option then the data column is transformed depending on the chart type and thus the association with the time series might not be as straightforward.

## Metadata.json structure

The .metadata.json file contains metadata about the data package. The "charts" key contains information to recreate the chart, like the title, subtitle etc.. The "columns" key contains information about each of the columns in the csv, like the unit, timespan covered, citation for the data etc..

## About the data

Our World in Data is almost never the original producer of the data - almost all of the data we use has been compiled by others. If you want to re-use data, it is your responsibility to ensure that you adhere to the sources' license and to credit them correctly. Please note that a single time series may have more than one source - e.g. when we stich together data from different time periods by different producers or when we calculate per capita metrics using population data from a second source.

## Detailed information about the data


## Public health expenditure as a share of GDP – Historical data – Lindert, OECD
Public health expenditure divided by gross domestic product, expressed as a percentage.
Last updated: March 4, 2025  
Next update: March 2026  
Date range: 1880–2023  
Unit: % of GDP  


### How to cite this data

#### In-line citation
If you have limited space (e.g. in data visualizations), you can use this abbreviated in-line citation:  
OECD Health Expenditure and Financing Database (2024); OECD (1993); Lindert (1994) – with major processing by Our World in Data

#### Full citation
OECD Health Expenditure and Financing Database (2024); OECD (1993); Lindert (1994) – with major processing by Our World in Data. “Public health expenditure as a share of GDP – Lindert, OECD – Historical data” [dataset]. OECD Health Expenditure and Financing Database, “OECD Health Expenditure and Financing Database”; OECD, “OECD Health Systems”; Lindert, “The rise of social spending (1880-1930)” [original data].
Source: OECD Health Expenditure and Financing Database (2024), OECD (1993), Lindert (1994) – with major processing by Our World In Data

### What you should know about this data
* This indicator combines three different datasets: Lindert (1994), OECD (1993), and the OECD Health Expenditure and Financing Database. We combine the two OECD datasets by using the implicit growth rate from the older series, so we can extend the series back to 1960. We also use the data from Lindert (1994) to extend the series to 1880.

### Sources

#### OECD Health Expenditure and Financing Database
Retrieved on: 2025-02-25  
Retrieved from: https://data-explorer.oecd.org/  

#### OECD – OECD Health Systems
Retrieved on: 2025-03-04  
Retrieved from: https://search.worldcat.org/title/868237125  

#### Lindert – The rise of social spending (1880-1930)
Retrieved on: 2025-03-04  
Retrieved from: https://www.sciencedirect.com/science/article/abs/pii/S0014498384710011  

#### Notes on our processing step for this indicator
We extrapolated the data available from the OECD Health Expenditure and Financing Database (Government/compulsory schemes) using the earliest available observation from this dataset and applying the growth rates implied by the OECD (1993) data to obtain a series starting in 1960. These steps are necessary because the data in these years is not exactly the same for the two datasets due to changes in definitions and measurement, though the trends are consistent for common years (1970-1991).

We don't transform the data from Lindert (1994), the values are the same as in the original source.


    