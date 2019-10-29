library(reshape)

    # Import data, which is all from the World Bank Indicators database
gdp <- read.csv("data/API_NY.GDP.PCAP.KD.ZG_DS2_en_csv_v2_422038.csv",sep=',',header=TRUE,skip=4)
literacy <- read.csv("data/API_SE.ADT.LITR.ZS_DS2_en_csv_v2_422117.csv",sep=',',header=TRUE,skip=4)
pop <- read.csv("data/API_SP.POP.GROW_DS2_en_csv_v2_429579.csv",sep=',',header=TRUE,skip=4)
urb <- read.csv("data/API_SP.URB.TOTL.IN.ZS_DS2_en_csv_v2_424393.csv",sep=',',header=TRUE,skip=4)
