library(dplyr)
library(tidyr)
library(countries)
library(tibble)
library(ggplot2)
library(stargazer)

# Reading raw data
wars <- read.csv("./Data/Useful/Inter-StateWarData_v4.0.csv") # Uses ccode
  # From COW
CINC <- read.csv("./Data/Useful/CINC.csv") # Uses ccode and stateabb
  # From COW
  CINC <- subset(CINC, select=-c(version))
  colnames(CINC)[3] = "Year" # For consistency with other datasets
foreign_aid <- read.csv("./Data/Useful/foreign-aid-received-net.csv") # Uses ISO3
  # https://ourworldindata.org/grapher/foreign-aid-received-net
  foreign_aid <- subset(foreign_aid, select=-c(X1012392.annotations))
  colnames(foreign_aid)[4] = "Foreign.Aid"
regime_type <- read.csv("./Data/Useful/political-regime.csv") # Uses ISO3
  # https://ourworldindata.org/grapher/political-regime
  # regime_type[nchar(regime_type$Code) > 3,] # All these are taken care of in gdp_growth data
corruption <- read.csv("./Data/Useful/political-corruption-index.csv") # Uses ISO3
  # https://ourworldindata.org/grapher/ti-corruption-perception-index
  colnames(corruption)[4] = "Corruption.index"
  # corruption[nchar(corruption$Code) > 3,] # All these are taken care of in gdp_growth data
state_capacity <- read.csv("./Data/Useful/state-capacity-index.csv") # Uses ISO3
  # https://ourworldindata.org/grapher/state-capacity-index
  colnames(state_capacity)[4] = "State.capacity"
health_expenditure <- read.csv("./Data/Useful/public-health-expenditure-share-gdp.csv") # Uses ISO3
  # https://ourworldindata.org/grapher/public-health-expenditure-share-gdp
  # Unfortunately data is too limiting on the merged dataset

# Differently shaped data from World Bank
gdp_growth <- read.csv("./Data/Useful/gdp-growth.csv") # Uses ISO3 
                                                                                         # Minorly preprocessed before uploading to R, may require the same kind of column dropping and renaming as other datasets for reproducability if using original data
population <- read.csv("./Data/Useful/population.csv") # Uses ISO3
  population <- subset(population, select=-c(Indicator.Name, Indicator.Code, X2024, X)) 

fdi <- read.csv("./Data/Useful/fdi_wdi.csv") # Uses ISO3
  fdi <- subset(fdi, select=-c(Indicator.Name, Indicator.Code, X2024, X)) 
inflation <- read.csv("./Data/Useful/inflation_wdi.csv") # Uses ISO3
  inflation <- subset(inflation, select=-c(Indicator.Name, Indicator.Code, X2024, X)) 
interest_rate <- read.csv("./Data/Useful/interest_rate_wdi.csv") # Uses ISO3
  interest_rate <- subset(interest_rate, select=-c(Indicator.Name, Indicator.Code, X2024, X)) 

# Needed for equating different country identifiers 
ccodes <- read.csv("./cow2iso.csv")
  # https://github.com/leops95/cow2iso/blob/master/cow2iso.csv

# Add ISO3 codes to COW dataframes
wars = add_column(wars, ISO3 = NA, .after = "ccode")
for (i in 1:length(wars$ccode)) {
  wars$ISO3[i] = ccodes[ccodes$cow_id == wars$ccode[i], 5][1]
}

CINC = add_column(CINC, Code = NA, .before = "ccode") # Naming "Code" for consistency with other data
CINC = add_column(CINC, Entity = NA, .before = "Code")
for (i in 1:length(CINC$ccode)) {
  CINC$Code[i] = ccodes[ccodes$cow_id == CINC$ccode[i], 5][1]
  CINC$Entity[i] = ccodes[ccodes$cow_id == CINC$ccode[i], 11][1]
}

# Reshape WDI data
gdp_growth <- gdp_growth %>% 
  pivot_longer(
    cols = starts_with("X"),
    names_to = "Year",
    names_prefix = "X",
    values_to = "Gdp.growth"
  ) %>%
  mutate(Year = as.numeric(Year)) %>% 
  as.data.frame() %>%
  na.omit()
colnames(gdp_growth)[1:2] <- c("Entity", "Code")

population <- population %>% 
  pivot_longer(
    cols = starts_with("X"),
    names_to = "Year",
    names_prefix = "X",
    values_to = "Population"
  ) %>%
  mutate(Year = as.numeric(Year)) %>% 
  as.data.frame() %>%
  na.omit()
colnames(population)[1:2] <- c("Entity", "Code")

fdi <- fdi %>% 
  pivot_longer(
    cols = starts_with("X"),
    names_to = "Year",
    names_prefix = "X",
    values_to = "FDI"
  ) %>%
  mutate(Year = as.numeric(Year)) %>% 
  as.data.frame() %>%
  na.omit()
colnames(fdi)[1:2] <- c("Entity", "Code")

inflation <- inflation %>% 
  pivot_longer(
    cols = starts_with("X"),
    names_to = "Year",
    names_prefix = "X",
    values_to = "Inflation"
  ) %>%
  mutate(Year = as.numeric(Year)) %>% 
  as.data.frame() %>%
  na.omit()
colnames(inflation)[1:2] <- c("Entity", "Code")

interest_rate <- interest_rate %>% 
  pivot_longer(
    cols = starts_with("X"),
    names_to = "Year",
    names_prefix = "X",
    values_to = "Interest.rate"
  ) %>%
  mutate(Year = as.numeric(Year)) %>% 
  as.data.frame() %>%
  na.omit()
colnames(interest_rate)[1:2] <- c("Entity", "Code")

# This approach is slow
  # merged_data <- data.frame()
  # for (i in 1:nrow(gdp_growth)) {
  #   curr_row <- gdp_growth[i,]
  #   for (j in 3:length(curr_row)) {
  #     merged_data <- rbind(merged_data, 
  #                        data.frame(
  #                          Country.Name = curr_row$Country.Name, 
  #                          Country.Code = curr_row$Country.Code,
  #                          Year = as.numeric(gsub("X", "", colnames(curr_row)[j])),
  #                          Gdp.growth = gdp_growth[i,j]
  #                        )
  #                     )
  #   }
  # }
  # gdp_growth <- merged_data
  

# The below code for setting start_year and end_year is deactivated, but I haven't deleted it in case I want to use it later
# Pruning datasets to relevant time periods
# start_year = min( # Change to max for actual pruning, relying on na.omit later
#   min(CINC$Year),
#   min(foreign_aid$Year),
#   min(regime_type$Year),
#   min(corruption$Year),
#   min(state_capacity$Year),
#   min(health_expenditure$Year),
#   
#   min(gdp_growth$Year),
#   min(population$Year),
#   min(fdi$Year),
#   min(inflation$Year),
#   min(interest_rate$Year)
# )
# end_year = max( # Change to min for actual pruning, relying on na.omit later
#   max(CINC$Year),
#   max(foreign_aid$Year),
#   max(regime_type$Year),
#   max(corruption$Year),
#   max(state_capacity$Year),
#   max(health_expenditure$Year),
#   
#   max(gdp_growth$Year),
#   max(population$Year),
#   max(fdi$Year),
#   max(inflation$Year),
#   max(interest_rate$Year)
# )

wars <- wars[(wars$StartYear1 >= 1960),] # Technically unneeded but makes looking at the data easier
# Dummy code war location data
wars = add_column(wars, FoughtHome = NA, .after = "WhereFought")
wars$FoughtHome <- c(  # 1 = was fought on home soil, 0 = no
  1, # Assam                            India
  0, # Assam                      China (PRC)
  0, # Vietnam War, Phase 2         United States of America
  1, # Vietnam War, Phase 2                         Cambodia
  0, # 5         Vietnam War, Phase 2                      South Korea
  0, # 6         Vietnam War, Phase 2                      Philippines
  1, # 7         Vietnam War, Phase 2                    South Vietnam
  1, # 8         Vietnam War, Phase 2                          Vietnam
  0, # 9         Vietnam War, Phase 2                         Thailand
  0, # 10        Vietnam War, Phase 2                        Australia
  1, # 11              Second Kashmir                            India
  1, # 12              Second Kashmir                         Pakistan
  0, # 13                 Six Day War                           Israel
  0, # 14                 Six Day War                            Egypt
  1, # 15                 Six Day War                           Jordan
  0, # 16                 Six Day War                            Syria
  0, # 17     Second Laotian, Phase 2         United States of America
  0, # 18     Second Laotian, Phase 2                         Thailand
  1, # 19     Second Laotian, Phase 2                             Laos
  0, # 20     Second Laotian, Phase 2                          Vietnam
  0, # 21            War of Attrition                            Egypt
  1, # 22            War of Attrition                           Israel
  1, # 23                Football War                         Honduras
  1, # 24                Football War                      El Salvador
  0, # 25         Communist Coalition                          Vietnam
  0, # 26         Communist Coalition         United States of America
  1, # 27         Communist Coalition                         Cambodia
  0, # 28         Communist Coalition                    South Vietnam
  0, # 29                  Bangladesh                            India
  1, # 30                  Bangladesh                         Pakistan
  1, # 31              Yom Kippur War                            Egypt
  0, # 32              Yom Kippur War                     Saudi Arabia
  1, # 33              Yom Kippur War                           Israel
  0, # 34              Yom Kippur War                           Jordan
  1, # 35              Yom Kippur War                            Syria
  0, # 36              Yom Kippur War                             Iraq
  0, # 37               Turco-Cypriot                           Turkey
  1, # 38               Turco-Cypriot                           Cyprus
  0, # 39             War over Angola                             Cuba
  0, # 40             War over Angola                     South Africa
  0, # 41             War over Angola Democratic Republic of the Congo
  1, # 42             War over Angola                           Angola
  1, # 43  Second Ogaden War, Phase 2                         Ethiopia
  0, # 44  Second Ogaden War, Phase 2                             Cuba
  1, # 45  Second Ogaden War, Phase 2                          Somalia
  1, # 46        Vietnamese-Cambodian                          Vietnam
  1, # 47        Vietnamese-Cambodian                         Cambodia
  1, # 48          Ugandian-Tanzanian                           Uganda
  1, # 49          Ugandian-Tanzanian                         Tanzania
  0, # 50          Ugandian-Tanzanian                            Libya
  0, # 51    Sino-Vietnamese Punitive                            China
  1, # 52    Sino-Vietnamese Punitive                          Vietnam
  1, # 53                   Iran-Iraq                             Iraq
  1, # 54                   Iran-Iraq                             Iran
  0, # 55            Falkland Islands                   United Kingdom
  0, # 56            Falkland Islands                        Argentina
  0, # 57            War over Lebanon                           Israel
  0, # 58            War over Lebanon                            Syria
  1, # 59   War over the Aouzou Strip                             Chad
  0, # 60   War over the Aouzou Strip                            Libya
  1, # 61  Sino-Vietnamese Border War                          Vietnam
  0, # 62  Sino-Vietnamese Border War                            China
  1, # 63                    Gulf War                           Kuwait
  0, # 64                    Gulf War         United States of America
  0, # 65                    Gulf War                           Canada
  0, # 66                    Gulf War                   United Kingdom
  0, # 67                    Gulf War                            Italy
  0, # 68                    Gulf War                          Morocco
  1, # 69                    Gulf War                             Iraq
  0, # 70                    Gulf War                            Egypt
  0, # 71                    Gulf War                             Oman
  0, # 72                    Gulf War                           France
  0, # 73                    Gulf War             United Arab Emirates
  0, # 74                    Gulf War                            Qatar
  1, # 75                    Gulf War                     Saudi Arabia
  0, # 76                    Gulf War                            Syria
  0, # 77        Bosnian Independence                          Croatia
  1, # 78        Bosnian Independence                           Bosnia
  0, # 79        Bosnian Independence                       Yugoslavia
  1, # 80              Azeri-Armenian                       Azerbaijan
  1, # 81              Azeri-Armenian                          Armenia
  1, # 82               Cenepa Valley                          Ecuador
  1, # 83               Cenepa Valley                             Peru
  1, # 84                Badme Border                          Eritrea
  1, # 85                Badme Border                         Ethiopia
  0, # 86              War for Kosovo                           Turkey
  0, # 87              War for Kosovo                            Italy
  0, # 88              War for Kosovo                   United Kingdom
  0, # 89              War for Kosovo         United States of America
  0, # 90              War for Kosovo                      Netherlands
  0, # 91              War for Kosovo                           France
  1, # 92              War for Kosovo                       Yugoslavia
  0, # 93              War for Kosovo                          Germany
  1, # 94                  Kargil War                            India
  0, # 95                  Kargil War                         Pakistan
  0, # 96     Invasion of Afghanistan                           Canada
  0, # 97     Invasion of Afghanistan                           France
  0, # 98     Invasion of Afghanistan                   United Kingdom
  0, # 99     Invasion of Afghanistan         United States of America
  0, # 100    Invasion of Afghanistan                        Australia
  1, # 101    Invasion of Afghanistan                      Afghanistan
  0, # 102           Invasion of Iraq                        Australia
  0, # 103           Invasion of Iraq                   United Kingdom
  0, # 104           Invasion of Iraq         United States of America
  1  # 105           Invasion of Iraq                             Iraq
)

CINC <- CINC[(CINC$Year >= start_year) & (CINC$Year <= end_year),] 
foreign_aid <- foreign_aid[(foreign_aid$Year >= start_year) & (foreign_aid$Year <= end_year),] 
regime_type <- regime_type[(regime_type$Year >= start_year) & (regime_type$Year <= end_year),] 
corruption <- corruption[(corruption$Year >= start_year) & (corruption$Year <= end_year),] 
state_capacity <- state_capacity[(state_capacity$Year >= start_year) & (state_capacity$Year <= end_year),] 
health_expenditure <- health_expenditure[(health_expenditure$Year >= start_year) & (health_expenditure$Year <= end_year),] 

gdp_growth <- gdp_growth[(gdp_growth$Year >= start_year) & (gdp_growth$Year <= end_year),] 
population <- population[(population$Year >= start_year) & (population$Year <= end_year),] 
fdi <- fdi[(fdi$Year >= start_year) & (fdi$Year <= end_year),] 
inflation <- inflation[(inflation$Year >= start_year) & (inflation$Year <= end_year),] 
interest_rate <- interest_rate[(interest_rate$Year >= start_year) & (interest_rate$Year <= end_year),] 

# Change Initiator variable in war dataset to match dummy coding conventions
wars$Initiator <- ifelse(wars$Initiator == 1, 1, 0)

# Dummy code outcome data: 1 = won, 0 = didn't
wars = add_column(wars, Victory = NA, .after = "Outcome")
wars$Victory = ifelse(wars$Outcome == 1, 1, 0)

# Merge datasets
merged_data <- auto_merge(CINC, foreign_aid, regime_type, corruption, state_capacity,  
                          gdp_growth, population, fdi, inflation, interest_rate,
           by = c("Code", "Year", "Entity")) 
# %>% na.omit() 
# Could keep NAs, then omit them during different models so as to maximize data if certain entries are missing for certain vars
##############
# NOTE: interest_rate is limiting, cuts data in half essentially
# health_expenditure data is too limited
##############

# for (i in 1:length(gdp_growth)) {
#   if (!(gdp_growth[i,]$Country.Code %in% ccodes$StateAbb)) {
#     gdp_growth <- gdp_growth %>% filter(Country.Code != gdp_growth[i,]$Country.Code)
#     print(c(gdp_growth[i,]$Country.Code, gdp_growth[i, ]$Country.Name))
#   }
# }

# Year is weird for some reason - fix
merged_data$Year <- as.numeric(substring(merged_data$Year, 1, 4))
# Dummy code regime type
merged_data = add_column(merged_data, Autocracy = NA, .after = "Political.regime")
merged_data = add_column(merged_data, Democracy = NA, .after = "Autocracy") # Technically redundant
merged_data$Autocracy <- ifelse(merged_data$Political.regime <= 1, 1, 0)
merged_data$Democracy <- ifelse(merged_data$Political.regime >= 2, 1, 0) # Technically redundant

merged_data <- subset(merged_data, select=-c(Political.regime))

# Extract necessary data from the wars dataset
# Prepare the new columns beforehand
merged_data[,"BattleDeaths"] <- 0
merged_data[,"InitiatedWar"] <- 0
merged_data[,"WonWar"] <- 0
merged_data[,"FoughtHome"] <- 0
# Set the relevant row cells to be the appropriate statistic: 
for (wrow in 1:nrow(wars)) {
  # For each war, get: the relevant state, the start year, the end year, the battle deaths, the Initiator, and the Outcome
  # wars$ISO3[wrow], wars$StartYear1[wrow], wars$EndYear1[wrow], wars$BatDeath[wrow], wars$Initiator[wrow], wars$Victory[wrow]
  #                                         For the wars we are looking at, we don't have to worry about EndYear2 since it is either NA or the same as EndYear1
  start_year = wars$StartYear1[wrow]
  end_year = wars$EndYear1[wrow]
  for (drow in 1:nrow(merged_data)) {
    curr_year = merged_data$Year[drow]
    # Deal with Years during the war
    if ((merged_data$Code[drow] == wars$ISO3[wrow]) & (curr_year >= start_year + 1) & (curr_year <= end_year + 1)) { # + 1 incorporates a 1 year delay to allow for the effects of war to "kick in"
      duration = end_year - start_year
      # Two different approaches for if the war lasts more than one year: 
      if (duration != 0) {
        # if it does, "ease into" the full effects by one year after war's end
        merged_data$BattleDeaths[drow] = merged_data$BattleDeaths[drow] + ((wars$BatDeath[wrow]/duration) * (curr_year - (start_year + 1)))
        merged_data$InitiatedWar[drow] = merged_data$InitiatedWar[drow] + ((wars$Initiator[wrow]/duration) * (curr_year - (start_year + 1)))
        merged_data$WonWar[drow] = merged_data$WonWar[drow] + ((wars$Victory[wrow]/duration) * (curr_year - (start_year + 1)))
        merged_data$FoughtHome[drow] = merged_data$FoughtHome[drow] + ((wars$FoughtHome[wrow]/duration) * (curr_year - (start_year + 1)))
      } else {
        # If not, just set it and be done with it
        merged_data$BattleDeaths[drow] = merged_data$BattleDeaths[drow] + wars$BatDeath[wrow]
        merged_data$InitiatedWar[drow] = merged_data$InitiatedWar[drow] + wars$Initiator[wrow]
        merged_data$WonWar[drow] = merged_data$WonWar[drow] + wars$Victory[wrow]
        merged_data$FoughtHome[drow] = merged_data$FoughtHome[drow] + wars$FoughtHome[wrow]
      }
    }
    # Deal with "recovery period" 10 years after the war
    if ((merged_data$Code[drow] == wars$ISO3[wrow]) & (curr_year >= wars$EndYear1[wrow] + 2) & (curr_year <= wars$EndYear1[wrow] + 11)) { # Still incorporating a 1 year delay
      merged_data$BattleDeaths[drow] = merged_data$BattleDeaths[drow] + ((wars$BatDeath[wrow]/(-10)) * (curr_year - (end_year + 11)))
      merged_data$InitiatedWar[drow] = merged_data$InitiatedWar[drow] + ((wars$Initiator[wrow]/(-10)) * (curr_year - (end_year + 11)))
      merged_data$WonWar[drow] = merged_data$WonWar[drow] + ((wars$Victory[wrow]/(-10)) * (curr_year - (end_year + 11)))
      merged_data$FoughtHome[drow] = merged_data$FoughtHome[drow] + ((wars$FoughtHome[wrow]/(-10)) * (curr_year - (end_year + 11)))
    }
  }
}

# Transform battle deaths into as a proportion of the population
merged_data$BattleDeaths <- merged_data$BattleDeaths / merged_data$Population

# Standardize data
merged_data <- merged_data %>%
  as_tibble() %>%
  mutate(across(6:26, ~ scale(.)[, 1], .names = "{.col}_scaled"))

# Models 1 and 2: should I be looking at peacetime data too if it's military/war related data?
# Model 1: IV
temp_df <- subset(merged_data, select=c(
  Gdp.growth_scaled, InitiatedWar
)) %>% na.omit()
  # N = 13884
model1 <- lm(Gdp.growth_scaled ~ 
               InitiatedWar, data = temp_df
) 
summary(model1)

# Model 2: CINC variables
temp_df <- subset(merged_data, select=c(
  Gdp.growth_scaled, irst_scaled, pec_scaled, milex_scaled, milper_scaled, upop_scaled, Population_scaled
)) %>% na.omit()
  # N = 8345
model2 <- lm(Gdp.growth_scaled ~ 
               irst_scaled + pec_scaled + milex_scaled + milper_scaled + upop_scaled + Population_scaled, data = temp_df
)
summary(model2)

# Model 3: Economic Control Variables
temp_df <- subset(merged_data, select=c(
  Gdp.growth_scaled, 
  irst_scaled, milex_scaled, Foreign.Aid_scaled,
  FDI_scaled, Inflation_scaled, Interest.rate_scaled
)) %>% na.omit()
# N = 2848
model3 <- lm(Gdp.growth_scaled ~ 
             irst_scaled + milex_scaled + 
             Foreign.Aid_scaled +
             FDI_scaled + Inflation_scaled + Interest.rate_scaled, data = temp_df
)
summary(model3)

# Model 4: All Control Variables (CINC deconstructed)
temp_df <- subset(merged_data, select=c(
  Gdp.growth_scaled, WonWar, BattleDeaths_scaled, FoughtHome, 
  irst_scaled, pec_scaled, milex_scaled, milper_scaled, upop_scaled, 
  Population_scaled, Corruption.index_scaled, Foreign.Aid_scaled,
  Democracy, State.capacity_scaled, FDI_scaled, Inflation_scaled, Interest.rate_scaled
)) %>% na.omit()
# N = 2379
model4 <- lm(Gdp.growth_scaled ~ WonWar + BattleDeaths_scaled + FoughtHome + 
             irst_scaled + pec_scaled + milex_scaled + milper_scaled + upop_scaled + 
             Population_scaled + 
             Corruption.index_scaled + Foreign.Aid_scaled +
             Democracy + State.capacity_scaled + FDI_scaled + Inflation_scaled + Interest.rate_scaled, data = temp_df
)
summary(model4)

# Model 5: All Control Variables (CINC consolidated)
temp_df <- subset(merged_data, select=c(
  Gdp.growth_scaled, WonWar, BattleDeaths_scaled, FoughtHome, 
  cinc_scaled, 
  Corruption.index_scaled, Foreign.Aid_scaled,
  Democracy, State.capacity_scaled, FDI_scaled, Inflation_scaled, Interest.rate_scaled
)) %>% na.omit()
# N = 2379
model5 <- lm(Gdp.growth_scaled ~ WonWar + BattleDeaths_scaled + FoughtHome + 
               cinc_scaled + 
               Corruption.index_scaled + Foreign.Aid_scaled +
               Democracy + State.capacity_scaled + FDI_scaled + Inflation_scaled + Interest.rate_scaled, data = temp_df
)
summary(model5)


# Model 6: All variables (CINC deconstructed)
temp_df <- subset(merged_data, select=c(
  Gdp.growth_scaled, InitiatedWar, WonWar, BattleDeaths_scaled, FoughtHome, 
    irst_scaled, pec_scaled, milex_scaled, milper_scaled, upop_scaled, 
    Population_scaled, Corruption.index_scaled, Foreign.Aid_scaled,
    Democracy, State.capacity_scaled, FDI_scaled, Inflation_scaled, Interest.rate_scaled
)) %>% na.omit()
  # N = 2379
model6 <- lm(Gdp.growth_scaled ~ InitiatedWar + WonWar + BattleDeaths_scaled + FoughtHome + 
           irst_scaled + pec_scaled + milex_scaled + milper_scaled + upop_scaled + 
           Population_scaled + 
            Corruption.index_scaled + Foreign.Aid_scaled +
           Democracy + State.capacity_scaled + FDI_scaled + Inflation_scaled + Interest.rate_scaled, data = temp_df
)
summary(model6)

# Model 7: All variables (CINC consolidated)
temp_df <- subset(merged_data, select=c(
  Gdp.growth_scaled, InitiatedWar, WonWar, BattleDeaths_scaled, FoughtHome, 
  cinc_scaled, 
  Corruption.index_scaled, Foreign.Aid_scaled,
  Democracy, State.capacity_scaled, FDI_scaled, Inflation_scaled, Interest.rate_scaled
)) %>% na.omit()
  # N = 2379
model7 <- lm(Gdp.growth_scaled ~ InitiatedWar + WonWar + BattleDeaths_scaled + FoughtHome + 
             cinc_scaled + 
             Corruption.index_scaled + Foreign.Aid_scaled +
             Democracy + State.capacity_scaled + FDI_scaled + Inflation_scaled + Interest.rate_scaled, data = temp_df
)
summary(model7)




##########################################
#               FIGURE(S)                #
##########################################
temp_df <- data.frame(Code = merged_data$Code, Year = merged_data$Year, gdp = merged_data$Gdp.growth)
for (wrow in 1:nrow(wars)) {
  end_year = wars$EndYear1[wrow]
  for (drow in 1:nrow(temp_df)) {
    curr_year = temp_df$Year[drow]
    if ((temp_df$Code[drow] == wars$ISO3[wrow]) & (curr_year >= end_year)) {
      temp_df$Year[drow] = curr_year - end_year # Transform the year variable into years after a war
    }
  }
}
temp_df <- temp_df %>% filter(Year <= 10) # Only look at the "defined recovery period"

ggplot(data = temp_df, mapping = aes(x = Year, y = gdp, color = Code)) + 
  geom_line() + 
  labs(
    title = "GDP Growth Rate after Wars", 
    x = "Year",
    y = "GDP Growth Rate"
  ) +
  scale_x_continuous(breaks = seq(0, 10, by = 2)) +
  scale_y_continuous(breaks = c(-50, 0, 50, 100), limits = c(-50, 100)) +
  theme_minimal() + 
  theme(
    legend.position = "none",
    plot.title = element_text(hjust = 0.5)
  )

stargazer(model1, model2, model3, model4, model5, model6, model7,
          type = "html",  
          title = "DV: GDP growth rate",
          report = "vc*s",
          align = TRUE,
          no.space = TRUE)

##########################################
# TODO: 
##########################################
# Figure out how to code missing ccode conversions
  # Only fill in Taiwan and Vietnam "I dropped non-major players"
  # Footnote: I lost some data due to ... bad merging
  # "When countries ar ein war and they're not major players we lose the ability to collect data on them"
  # "International relations data is gross and we just have to put up with it"
    # - Dr. Croco (is awesome) 

# Concerns:
  # How long does a war affect economy?
    # Conservative is 10 years
    # Shift variable by a year
    # Write out the table as an example in the paper
    # "I'm assuming an equal decay function. Some readers may take issue with this..."
  # Population and death variables might be correlated

# Next:
  # Insert the following into the merged data. War dataset contains:
    # War start years
    # Battle Deaths (%)
    # Instigator
    # Outcome
    # Location?
  # Run regressions

# Ridge and lasso, CV to see lambda
# If the model with non dropped out vars performs just as well, then they are sufficient to explain variation
# 80/20 training validation

# Have a model where I 

#                                   Estimate Std. Error t value Pr(>|t|)    
# (Intercept)                      4.537e+00  5.086e-01   8.921  < 2e-16 ***
# merged_data$InitiatedWar        -3.714e-01  9.678e-01  -0.384  0.70120    
# merged_data$WonWar               3.925e-01  9.744e-01   0.403  0.68708    
# merged_data$BattleDeaths        -1.146e+02  9.691e+01  -1.182  0.23707    
# merged_data$FoughtHome           2.210e+00  7.950e-01   2.781  0.00544 ** 
# merged_data$cinc                -3.936e+01  4.920e+01  -0.800  0.42374    
# merged_data$irst                 7.177e-06  1.617e-05   0.444  0.65713    
# merged_data$pec                  1.180e-06  2.728e-06   0.433  0.66525    
# merged_data$milex               -3.331e-08  3.650e-08  -0.913  0.36140    
# merged_data$milper               2.803e-03  9.945e-04   2.819  0.00483 ** 
# merged_data$Population          -1.643e-11  2.872e-09  -0.006  0.99544    
# merged_data$Corruption.index    -4.699e-01  4.286e-01  -1.097  0.27289    
# merged_data$Foreign.Aid          1.863e-11  1.139e-10   0.164  0.87013    
# merged_data$Closed.autocracy    -5.815e-01  5.502e-01  -1.057  0.29061    
# merged_data$Electoral.autocracy  1.229e-01  5.504e-01   0.223  0.82331    
# merged_data$Electoral.democracy -4.625e-01  5.412e-01  -0.854  0.39288



