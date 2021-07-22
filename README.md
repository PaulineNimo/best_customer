# Lendable Coding Assessment for Integrations Engineer
## Date: 23/07/2021

### Task:
Writing a function that returns the ids of the n best customers from the transaction data. The best customer is the one that has the longest period of consecutive daily payments. 
### Tool: 
R; readr, tidyverse
### Notes:
File path can be edited on line 6 of the R script to reflect file path location on your local computer. In the case of ties, the function returns the first n values arranged alphabetically.
The data contains omits dates where no transactions were made for each customer. The dates had to be added so as to make the computation of consecutive days easier. 
The data also contains multiple entries in one calendar day for a customer where multiple transactions were made. Since the task is only concerned with whether a payment was made or not, one entry is removed. 
Additional comments are available in the code.
