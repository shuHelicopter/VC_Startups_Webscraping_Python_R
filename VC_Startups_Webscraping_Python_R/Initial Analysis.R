######################################################
#################### by Shu Liu ######################
############ shutel at hotmail dot com ###############
################### 08/14/2016 #######################
### Webscraping project @ NYC Data Science Academy ###
######################################################

library(corrplot)
library(dplyr)
library(ggplot2)
library(ggthemes)
library(plotly)

########## Merge data from 'Seed-DB.com' and 'Twitter'
companies_mdf = read.csv('./companies_mdf.csv', header = TRUE, stringsAsFactors = FALSE)
companies_mdf = companies_mdf[, -1] # remove the column with index
twitter = read.csv('./twitter.csv', header = TRUE, stringsAsFactors = FALSE)
twitter = twitter[, -1] # remove the column with index
companies_cln = merge(companies_mdf, twitter)


########### seed accelerators #############
###########################################

# correlation between varaible of seed accelerators
accel_corr <- companies_cln[, c('seed_accelerator', 'accel_add', 'accel_amt_exited', 
                                'accel_amt_funded', 'accel_num_exited', 'accel_num_funded')]

accel_corr$seed_accelerator <- as.factor(accel_corr$seed_accelerator)
accel_corr$accel_add <- as.factor(accel_corr$accel_add) 
accel_corr <- accel_corr %>% 
  group_by(seed_accelerator, accel_add) %>% 
  summarise('accel_amt_exited' = mean(accel_amt_exited, na.rm = TRUE), # handle the problem that same-name accelerators located in different places
            'accel_amt_funded' = mean(accel_amt_funded, na.rm = TRUE), # handle the problem that same-name accelerators located in different places
            'accel_num_exited' = mean(accel_num_exited, na.rm = TRUE), # handle the problem that same-name accelerators located in different places
            'accel_num_funded' = mean(accel_num_funded, na.rm = TRUE)) # handle the problem that same-name accelerators located in different places

# order seed accelerators by amount funded
accel_amt<- accel_corr[order(accel_corr$accel_amt_funded, decreasing = TRUE), ]
accel_amt10 <- accel_amt[c(1:10), ]

g_amt_funded <- ggplot(accel_amt10, aes(x = seed_accelerator, y = accel_amt_funded))
g_amt_funded + geom_bar(stat = 'identity', fill = 'Orange') + theme_hc() + 
  theme(axis.text = element_text(size = 10), axis.title = element_text(size = 15)) + 
  labs(title = 'Top 10 Seed Accelerators by Amount Funded', x = 'Accelerators', y = 'Amount')

# select observations with valid followers_num, friends_num, favorites_num and statuses_num
startup_corr0 <- companies_cln[, c('funding', 'rounds', 'followers_num', 
                                  'friends_num', 'statuses_num', 'favourites_num')]
startup_corr <- startup_corr0[which(startup_corr0$followers_num != 0 | 
                                      startup_corr0$friends_num != 0 |
                                      startup_corr0$favourites_num != 0 |
                                      startup_corr0$statuses_num != 0), ]
startup_M <- cor(startup_corr)
corrplot(startup_M, method = 'number')
corrplot(startup_M, method = 'circle')

################## startups ###############
###########################################
startups <- companies_cln[, c('name', 'seed_accelerator', 'funding', 'rounds', 'favourites_num', 
                              'followers_num',  'friends_num', 'statuses_num')]
startups_amt <- startups[order(startups$funding, decreasing = TRUE), ]
startups_amt10 <- startups_amt[c(1:10), ]

g_amt_funding <- ggplot(startups_amt10, aes(x = name, y = funding))
g_amt_funding + geom_bar(stat = 'identity', fill = 'deepskyblue') + theme_hc() + 
  theme(axis.text = element_text(size = 10), axis.title = element_text(size = 15)) + 
  labs(title = 'Top 10 Startups by Funding Amount', x = 'Starups', y = 'Amount')
