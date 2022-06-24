#data Preparation
#install.packages("readxl")
library(janitor)
library("readxl")

#Load excel data
sheet_one_data<- read_excel("GRAIN---Land-grab-deals---Jan-2012-2.xlsx", sheet = 1)

sheet_two_data<- read_excel("GRAIN---Land-grab-deals---Jan-2012-2.xlsx", sheet = 2)


#Basic information about the data
class(sheet_one_data)
class(sheet_two_data)

dim(sheet_one_data)
dim(sheet_two_data)

summary(sheet_one_data)
summary(sheet_two_data)

#format unsightly column names in a data frame
#clean sheet one data names
clean_sheet_one_data<-clean_names(sheet_one_data)
colnames(clean_sheet_one_data)

#clean sheet two data names
clean_sheet_two_data<-clean_names(sheet_two_data)
colnames(clean_sheet_two_data)

clean_sheet_one_data
nrow(clean_sheet_two_data)

#remove empty rows from data frame
clean_sheet_one_data <- clean_sheet_one_data[!apply(clean_sheet_one_data == "", 1, all),]
clean_sheet_two_data <- clean_sheet_two_data[!apply(clean_sheet_two_data == "", 1, all),]


#In the data frame, separate out duplicate records.
clean_sheet_one_data %>% get_dupes(landgrabbed,landgrabber,base,sector,hectares,production,projected_investment,year,status_of_deal,summary)
clean_sheet_two_data %>% get_dupes(landgrabbed,landgrabber,base,sector,hectares,production,projected_investment,year,status_of_deal,summary)

#correcting errors
View(clean_sheet_one_data)
View(clean_sheet_two_data)

#merge data
data <- rbind(clean_sheet_one_data,clean_sheet_two_data)

dim(data)
summary(data)
View(data)
#checking for duplicates
data %>% get_dupes(landgrabbed,landgrabber,base,sector,hectares,production,projected_investment,year,status_of_deal,summary)

library(stringr)
#correcting damaged data
data$status_of_deal<-str_replace(data$status_of_deal,"Don","Done")
data$status_of_deal<-str_replace(data$status_of_deal,"Donee","Done")
data$status_of_deal<-str_replace(data$status_of_deal,"Done\r\n","Done")
data$status_of_deal<-str_replace(data$status_of_deal,"Inprocess","In process")
data$status_of_deal<-str_replace(data$status_of_deal,"Suspended (October 2011)","Suspended")
data$status_of_deal<-str_replace(data$status_of_deal,"Done - 15/08/2011","Done")
data$status_of_deal<-str_replace(data$status_of_deal,"Done (50-yr lease)","Done")

# Quick and Format tabulations
data %>% tabyl(status_of_deal) %>% adorn_pct_formatting(digits =2,affix_sign=TRUE)
data %>% tabyl(status_of_deal) %>% adorn_pct_formatting(digits =2,affix_sign=TRUE)

data  %>% tabyl(status_of_deal) %>% adorn_totals()
data  %>% tabyl(status_of_deal)%>% adorn_totals(where = "col")
data %>% tabyl(status_of_deal,base) %>%
  adorn_totals("row") %>%
  adorn_percentages("row") %>%
  adorn_pct_formatting() %>%
  adorn_ns("front")


