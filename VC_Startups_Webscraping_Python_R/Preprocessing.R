######################################################
#################### by Shu Liu ######################
############ shutel at hotmail dot com ###############
################### 08/14/2016 #######################
### Webscraping project @ NYC Data Science Academy ###
######################################################

companies <- read.csv('companies.csv', stringsAsFactors = FALSE) # load the data
companies <- companies[, -1]

# tidy up the format
companies$accel_amt_exited <- as.numeric(gsub("\\[u'|\\']", "", companies$accel_amt_exited))
companies$accel_amt_funded <- as.numeric(gsub("\\[u'|\\']", "", companies$accel_amt_funded))
companies$accel_num_exited <- as.numeric(gsub("\\[u'|\\']", "", companies$accel_num_exited))
companies$accel_num_funded <- as.numeric(gsub("\\[u'|\\']", "", companies$accel_num_funded))
companies$accel_estb_yr <- gsub("\\[u'|\\']", "", companies$accel_estb_yr)
companies$accel_estb_yr <- as.numeric(gsub("\\[|\\]", "", companies$accel_estb_yr))
companies$name <- gsub("\n", "", companies$name)

companies_cln <- companies
write.csv(companies_cln, file = './companies_mdf.csv' ) # for futher analysis in python and r

