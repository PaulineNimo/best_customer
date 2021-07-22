# Lendable Coding Assessment for Integrations Engineer
# Date: 23/07/2021

# setting up working directory
# this can be replaced with a different local path/ set to location of files
file_path <- "E:/Lendable/Lendable+Coding+Assessment+-+Reliable+Customers/Lendable Coding Assessment - Reliable Customers/data/"
setwd(file_path)

# loading necessary libraries
# this is needed for reading the csv files
library(readr)
# this is for data manipulation
library(tidyverse)

# conducting data checks
# are the dates in the data consecutive?
path_1 <- paste0(getwd(),"/transaction_data_1.csv")
transaction_data <- read_csv(path_1, col_types = cols())
# filtering using one customer ID
acc1_data <- transaction_data[transaction_data$customer_id == "ACC1",]
# creating vector of all days between start and end of data
consecutive_days <- length(seq(min(acc1_data$transaction_date),max(acc1_data$transaction_date),"day"))
consecutive_days > nrow(acc1_data)
# result is TRUE meaning some days are omitted due to no transaction data

# are there duplicated dates?
path_3 <- paste0(getwd(),"/transaction_data_3.csv")
transaction_data <- read_csv(path_3, col_types = cols())
# convert to date format
transaction_data$dates <- as.Date(transaction_data$transaction_date)
# check if dates appear more than once per customer
table(table(transaction_data$customer_id, transaction_data$dates) > 1)
# some results are true showing some days appear more than once per customer

# function to get customers who pay most regularly
# this function returns customer IDs for best customers
# a best customer is the one that has the longest period of consecutive daily payments
# ties from results are sorted alphabetically

reliable_customers <- function(transactions_csv_file_path, n){

    # read in csv file and retaining data format in columns
    transaction_data <- read_csv(transactions_csv_file_path, col_types = cols())

    # using pipe operator
    best_customers <- transaction_data %>%

        # create column with date format as complete function works on date format, not POSIXct
        mutate(dates = as.Date(transaction_date)) %>%

        # fill in the missing dates and set days without payment to have zero transaction amount
        # this arranges the dataframe by the dates column
        complete(dates = seq.Date(min(dates), max(dates), by="day"), customer_id, fill = list(transaction_amount = 0)) %>%

        # introduce new column values to show whether day had payment or not
        # this is used in the consecutive day count and to filter out days with no transactions
        mutate(had_payment = ifelse(transaction_amount > 0, "Yes", "No")) %>%

        # group by customer ID
        # this is used to get the consecutive days for each customer
        group_by(customer_id) %>%

        # remove duplicated dates
        # there appears to be days where there is more than one transaction for a customer
        # since we are concerned with whether a payment is made or not, only one transaction is required
        distinct(dates, customer_id, had_payment, .keep_all = TRUE) %>%

        # get consecutive days with payments
        # counting consecutive days that had the same value in the column had_payment
        mutate(consecutive_days = sequence(rle(had_payment)$lengths)) %>%

        # filter to get only those with payments made
        # removing values of days with no payment
        filter(had_payment == "Yes") %>%

        # arrange by longest payment streak and by alphabetical order of the account names
        # daily transaction streak sorted in descending order
        arrange(desc(consecutive_days), customer_id) %>%

        # get unique customer IDs and ensures all subsequent values corresponding to a similar customer ID are removed
        # this removes all other columns except customer IDs
        distinct(customer_id) %>%

        # return only the number n of rows
        # this value n is input as an argument in the function
        head(n)

    # return customer IDs
    return(best_customers$customer_id)
}

# Test Case 1
path_1 <- paste0(getwd(),"/transaction_data_1.csv")
reliable_customers(transactions_csv_file_path = path_1, n = 1)

# Test Case 2
path_2 <- paste0(getwd(),"/transaction_data_2.csv")
reliable_customers(transactions_csv_file_path = path_2, n = 2)

# Test Case 3
path_3 <- paste0(getwd(),"/transaction_data_3.csv")
reliable_customers(transactions_csv_file_path = path_3, n = 3)
