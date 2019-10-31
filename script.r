 library(reshape)
 
 # Import data and remove the first 4 rows
 gdp <- read.csv("data/API_NY.GDP.PCAP.CD_DS2_en_csv_v2_422141.csv",sep=',',header=TRUE,skip=4)
 literacy <- read.csv("data/API_SE.ADT.LITR.ZS_DS2_en_csv_v2_422117.csv",sep=',',header=TRUE,skip=4)
 pop <- read.csv("data/API_SP.POP.GROW_DS2_en_csv_v2_429579.csv",sep=',',header=TRUE,skip=4)
 urb <- read.csv("data/API_SP.URB.TOTL.IN.ZS_DS2_en_csv_v2_424393.csv",sep=',',header=TRUE,skip=4)
 gni <- read.csv("data/API_NY.GNP.PCAP.CD_DS2_en_csv_v2_424618.csv",sep=',',header=TRUE,skip=4,stringsAsFactors = FALSE)
 
 
 ## Also read in a metadata file we can use to remove aggregated countries (regions)
 country_code <- read.csv("data/Metadata_Country.csv",sep=",",header=TRUE,skip=0)
          
 
 #change the name of the first row
 colnames(country_code)[1] <-"CountryCode"
 
 #keep only countries and skip aggregated inputs
 # as aggregates "Region" column is empty
 country_code <- country_code[!(country_code$Region == ""), ] 
 
 # Since all the data is from the same source and comes in the same format, we can clean it easily together.
 # Create a list of all the names of the dataframes and the generic header names
 str_of_dataframes <- c('gdp','literacy','pop','urb','gni')
 header_names <- c('Country_Name', 'Country_Code', 'Indicator_Name','Indicator_Code',1960:2018) # Note, these year columns will be turned into strings
 
 
 CleanDataFrame <- function(D) {
   # This simply ensures consistency
   D[length(D)] <- NULL # Delete the last column, it is empty
   colnames(D) <- header_names # Change the headernames to be the same
   return(D)
 }
 
 OnlyCountries <- function(D) {
   # Remove entries from regions of aggregated countries
   D <- subset(D,D$Country_Code %in% country_code$CountryCode)
   return(D)
 }
 
 
 
 
 
 
 
 # Actually clean the data: Walk through the list of indicators and clean it
 for (i in 1:length(str_of_dataframes)) {
   assign(str_of_dataframes[i], CleanDataFrame(get(str_of_dataframes[i])))
   assign(str_of_dataframes[i], OnlyCountries(get(str_of_dataframes[i])))
 }
 
 
 
 ########################### Add column for GNI########################
 
 
 
 gni["income"] = 0
 # make na values zero 
 gni$'2018'[is.na(gni$'2018')] <- 0
 
 # classigy countries based on http://blogs.worldbank.org/opendata/new-country-classifications-income-level-2018-2019
 
 
 for (i in 1:nrow(gni)){
   if (gni[i,'2018']  0 & gni[i,'2018'] < 996){
     gni[i,'income'] = 'Low-Income'
   }
   else if (gni[i,'2018'] = 996 & gni[i,'2018'] <= 3895){
     gni[i,'income'] = 'Lower-middle Income'
   }
   else if (gni[i,'2018'] = 3896 & gni[i,'2018'] <= 12055){
     gni[i,'income'] = 'Upper-middle Income'
   }
   else if (gni[i,'2018'] = 12055){
     gni[i,'income'] = 'High-Income'
   }
   else {
     gni[i,'income'] = 'Data not available'
   }
 }