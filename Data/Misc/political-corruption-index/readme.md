# Political corruption index - Data package

This data package contains the data that powers the chart ["Political corruption index"](https://ourworldindata.org/grapher/political-corruption-index?v=1&csvType=full&useColumnShortNames=false) on the Our World in Data website. It was downloaded on April 30, 2025.

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


## Political corruption index – (central estimate)
Central estimate of the extent to which a country is affected by political corruption.
Last updated: March 17, 2025  
Next update: March 2026  
Date range: 1789–2024  


### How to cite this data

#### In-line citation
If you have limited space (e.g. in data visualizations), you can use this abbreviated in-line citation:  
V-Dem (2025) – processed by Our World in Data

#### Full citation
V-Dem (2025) – processed by Our World in Data. “Political corruption index – (central estimate)” [dataset]. V-Dem, “Democracy report v15” [original data].
Source: V-Dem (2025) – processed by Our World In Data

### What you should know about this data
* Measures the extent of political corruption across executive, legislative, judicial, and public sectors.
* Includes both petty and grand corruption, such as bribery, embezzlement, and misuse of office.
* Higher values (0–1 scale) indicate more pervasive corruption, reversing the typical V-Dem index direction.

### How is this data described by its producer - V-Dem (2025)?
Question: How pervasive is political corruption?

Clarification: The directionality of the V-Dem corruption index runs from less corrupt to more corrupt unlike the other V-Dem variables that generally run from less democratic to more democratic situation. The corruption index includes measures of six distinct types of corruption that cover both different areas and levels of the polity realm, distinguishing between executive, legislative and judicial corruption. Within the executive realm, the measures also distinguish between corruption mostly pertaining to bribery and corruption due to embezzlement. Finally, they differentiate between corruption in the highest echelons of the executive at the level of the rulers/cabinet on the one hand, and in the public sector at large on the other. The measures thus tap into several distinguished types of corruption: both 'petty' and 'grand'; both bribery and theft; both corruption aimed and influencing law making and that affecting implementation.

Scale: Interval, from low to high (0-1).

V-Dem indicator name: `v2x_corr`

### Source

#### V-Dem – Democracy report
Retrieved on: 2025-03-17  
Retrieved from: https://v-dem.net/data/the-v-dem-dataset/  

#### Notes on our processing step for this indicator
The regional aggregates (including values for the World) have been estimated by averaging the country values.


    