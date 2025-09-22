# Foreign aid received - Data package

This data package contains the data that powers the chart ["Foreign aid received"](https://ourworldindata.org/grapher/foreign-aid-received-net?v=1&csvType=full&useColumnShortNames=false) on the Our World in Data website.

## CSV Structure

The high level structure of the CSV file is that each row is an observation for an entity (usually a country or region) and a timepoint (usually a year).

The first two columns in the CSV file are "Entity" and "Code". "Entity" is the name of the entity (e.g. "United States"). "Code" is the OWID internal entity code that we use if the entity is a country or region. For normal countries, this is the same as the [iso alpha-3](https://en.wikipedia.org/wiki/ISO_3166-1_alpha-3) code of the entity (e.g. "USA") - for non-standard countries like historical countries these are custom codes.

The third column is either "Year" or "Day". If the data is annual, this is "Year" and contains only the year as an integer. If the column is "Day", the column contains a date string in the form "YYYY-MM-DD".

The remaining columns are the data columns, each of which is a time series. If the CSV data is downloaded using the "full data" option, then each column corresponds to one time series below. If the CSV data is downloaded using the "only selected data visible in the chart" option then the data columns are transformed depending on the chart type and thus the association with the time series might not be as straightforward.

## Metadata.json structure

The .metadata.json file contains metadata about the data package. The "charts" key contains information to recreate the chart, like the title, subtitle etc.. The "columns" key contains information about each of the columns in the csv, like the unit, timespan covered, citation for the data etc..

## About the data

Our World in Data is almost never the original producer of the data - almost all of the data we use has been compiled by others. If you want to re-use data, it is your responsibility to ensure that you adhere to the sources' license and to credit them correctly. Please note that a single time series may have more than one source - e.g. when we stich together data from different time periods by different producers or when we calculate per capita metrics using population data from a second source.

### How we process data at Our World In Data
All data and visualizations on Our World in Data rely on data sourced from one or several original data providers. Preparing this original data involves several processing steps. Depending on the data, this can include standardizing country names and world region definitions, converting units, calculating derived indicators such as per capita measures, as well as adding or adapting metadata such as the name or the description given to an indicator.
[Read about our data pipeline](https://docs.owid.io/projects/etl/)

## Detailed information about each time series


## Foreign aid received – Official donors
[Official development assistance (ODA)](#dod:oda) is defined as government aid designed to promote the economic development and welfare of developing countries. Monetary aid is estimated as net disbursements. This data is expressed in US dollars. It is adjusted for inflation.
Last updated: February 19, 2025  
Next update: February 2026  
Date range: 1960–2023  
Unit: constant 2022 US$  


### How to cite this data

#### In-line citation
If you have limited space (e.g. in data visualizations), you can use this abbreviated in-line citation:  
OECD (2025) – with minor processing by Our World in Data

#### Full citation
OECD (2025) – with minor processing by Our World in Data. “Foreign aid received – Official donors” [dataset]. OECD, “OECD Official Development Assistance (ODA) - DAC2A: Aid (ODA) disbursements to countries and regions” [original data].
Source: OECD (2025) – with minor processing by Our World In Data

### What you should know about this data
* Official development assistance (ODA) is aid given to countries and territories on the OECD Development Assistance Committee (DAC) list of recipients and multilateral development institutions. To qualify as ODA, the aid has to serve the economic development and welfare of recipient countries and be either a grant or a loan with favorable terms.
* DAC country recipients are all low- and middle-income countries as defined by the World Bank, or least-developed countries as defined by the United Nations. All recipients are listed on [the OECD website](https://www.oecd.org/en/topics/sub-issues/oda-eligibility-and-conditions/dac-list-of-oda-recipients.html).
* Most ODA is provided by [DAC members](https://www.oecd.org/en/about/committees/development-assistance-committee.html), which are major aid donors in the OECD plus the European Union. However, some non-DAC countries, such as Turkey or Saudi Arabia, also give aid that follows ODA guidelines.
* ODA does not include military aid, except for the cost of using armed forces to deliver humanitarian aid. It also excludes spending on peacekeeping unless it is closely related to development.
* The data is reported as net disbursements. This refers to aid ultimately given and is different from commitments, which is only aid that has been pledged. These are net amounts because any money coming in (like loan repayments or interest) has been subtracted from money going out (like new grants or loans).
* The data is measured in constant 2022 US$ – this adjusts for inflation.

### How is this data described by its producer - OECD (2025)?
_[From OECD's indicator explainer](https://www.oecd.org/en/data/indicators/net-oda.html)_

Official development assistance (ODA) is defined as government aid designed to promote the economic development and welfare of developing countries. Loans and credits for military purposes are excluded. Aid may be provided bilaterally, from donor to recipient, or channelled through a multilateral development agency such as the United Nations or the World Bank. Aid includes grants, "soft" loans and the provision of technical assistance. The OECD maintains a list of developing countries and territories; only aid to these countries counts as ODA. The list is periodically updated and currently contains over 150 countries or territories (see DAC List of ODA Recipients: https://oe.cd/dac-list). A long-standing United Nations target is that developed countries should devote 0.7% of their gross national income to ODA. Prior to 2018, the ODA flows basis methodology covered loans expressed on a “cash basis”, meaning their full face value was included, then repayments were subtracted as they came in. From 2018, the ODA grant-equivalent methodology is used whereby only the “grant portion” of the loan, i.e. the amount “given” by lending below market rates, counts as ODA.

### Source

#### OECD – OECD Official Development Assistance (ODA) - DAC2A: Aid (ODA) disbursements to countries and regions
Retrieved on: 2025-02-19  
Retrieved from: https://www.oecd.org/en/topics/policy-issues/official-development-assistance-oda.html  


    