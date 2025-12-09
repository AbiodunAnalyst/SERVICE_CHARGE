library(data.table)
library(dplyr)
library(tidyverse)
library(sparklyr)
library(data.table)
library(readxl)
library(lubridate)

merge_csv_files <- function(mypath) {
  # Get the list of file names
  filenames <- list.files(path = mypath, full.names = TRUE)
  
  # Function to handle reading of files
  read_file <- function(file) {
    if (grepl("\\.zip$", file)) {
      # If the file is a zip, list the contents
      zip_contents <- unzip(file, list = TRUE)
      if (nrow(zip_contents) > 1) {
        stop("Compressed files containing more than 1 file are currently not supported.")
      }
      # Extract the single file and read it
      temp_file <- unzip(file, files = zip_contents$Name[1], exdir = tempdir())
      if (grepl("\\.csv$", temp_file)) {
        data <- fread(temp_file)
      } else if (grepl("\\.xlsx?$", temp_file)) {
        data <- as.data.table(read_excel(temp_file))
      } else {
        stop("Unsupported file type in zip.")
      }
    } else if (grepl("\\.csv$", file)) {
      # If the file is a CSV, read it directly
      data <- fread(file)
    } else if (grepl("\\.xlsx?$", file)) {
      # If the file is an Excel file, read it directly
      data <- as.data.table(read_excel(file))
    } else {
      stop("Unsupported file type.")
    }
    return(data)
  }
  
  # Apply the read_file function to each file
  data_list <- lapply(filenames, read_file)
  
  # Combine all data tables into one
  merged_data <- rbindlist(data_list, fill = TRUE)
  
  return(merged_data)
}

# Specify the directory containing CSV and Excel files

directory_path <- "C:/Users/DELL LATITUDE 7370/OneDrive/Documents/ENFORCA/bank"

# Call the merge_csv_files function to merge files from the directory

Price_df <- merge_csv_files(directory_path) %>%

# Remove duplicate rows   
  distinct() %>%  
  # Select required columns
  select('Date', 'User Type', 'Transaction Type','Service Fee','Banker Service Fee',
         'Customer Service Fee', 'Amount') %>%  
  # Remove rows where all specified columns are NA or empty
  filter(!(
    (is.na(Date) | trimws(Date) == "") &
    (is.na(`User Type`) | trimws(`User Type`) == "") &
    (is.na(`Transaction Type`) | trimws(`Transaction Type`) == "") &
    (is.na(Amount) | trimws(Amount) == "")
  )) %>%  
  # Convert and separate into date and time columns
   mutate(
    Date = ymd_hms(Date),
    Full_date = as.Date(Date),
    Time = format(Date, "%H:%M:%S")
  ) %>% 
  mutate(
    # Parse the Time column to a period object
    Time = hms(Time),
    
    # Create Service_Period based on the hour of the Time column
    Service_Period = case_when(
      hour(Time) >= 5 & hour(Time) < 12 ~ 'Morning',
      hour(Time) >= 12 & hour(Time) < 17 ~ 'Daytime',
      hour(Time) >= 17 & hour(Time) < 21 ~ 'Evening',
      TRUE ~ 'Night'
    )
  ) %>%
  # Convert Time back to character to keep only the time part
  mutate(
    Time = format(Time, format = "%H:%M:%S")
  ) %>% 
  # Renaming varaibles
  rename(
    User_Type = `User Type`, 
    Transaction_Type = `Transaction Type`, 
    Service_Fee = `Service Fee`, 
    Banker_Service_Fee = `Banker Service Fee`, 
    Customer_Service_Fee = `Customer Service Fee`,
    Transaction_Time = Service_Period
  ) %>%
  # Select final required row  
  select("Full_date", "User_Type", "Transaction_Type", "Transaction_Time", "Service_Fee", 
         "Banker_Service_Fee", "Customer_Service_Fee", "Amount")


View(Price_df)

nrow(Price_df)

summary(Price_df)

str(Price_df)

############### Connection to Posgresql ######################################

install.packages("RPostgres")

library(odbc)
library(RODBC)
library(DBI)
library(RPostgres)



# Connection to the database
con <- dbConnect(RPostgres::Postgres(), 
                 dbname = "BankProject",
                 host = "localhost",
                 port = 5432,
                 user = "postgres",
                 password = "marvel")  # Password should be enclosed in quotes

# Write to the database, overwriting existing table
dbWriteTable(con, "Price_df", Price_df, overwrite = TRUE)



# Write to the database, appending data to existing table
dbWriteTable(con, "Crime_df", Crime_df, append = TRUE)

dbDisconnect(con)



