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

B.data_ <- merge_csv_files(directory_path)


## View 
#View(B.data_)

######################### Check for duplicate #################################

# Find duplicate rows
duplicates <- B.data_ %>%
  filter(duplicated(.) | duplicated(., fromLast = TRUE))

# Remove all duplicate rows
Bank_data <- B.data_ %>%
  distinct()  # Keep only unique rows

     
# Select required row  

ser_df <- Bank_data %>%
  select('Date', 'User Type', 'Transaction Type','Service Fee','Banker Service Fee',
         'Customer Service Fee', 'Amount')

#View(ser_df)

# Number of rows 

nrow(ser_df)  ## 11068


########################## Check for missing value ##############################

na_counts_for_all_var <- ser_df %>%
  summarize(across(everything(), list(na_count = ~sum(as.numeric(is.na(.)))))) %>% 
  show()

# Using filter where na is available
filtered_data <- ser_df %>% 
  filter(!is.na(Date) & !is.na(`User Type`) & !is.na(`Transaction Type`) & !is.na(Amount))

# View 
#View(filtered_data)


# Filter rows where all columns have missing values
filtered_data_all <- ser_df %>% 
  filter(is.na(Date) & is.na(`User Type`) & is.na(`Transaction Type`) & is.na(Amount))

#View(filtered_data_all)


# Checking number of rows affected due to missing value
filtered_out_row <- nrow(filtered_data_all)
print(filtered_out_row)


# checking where there is no missing value
filtered_data_com <- ser_df %>% 
  filter(complete.cases(Date, `User Type`, `Transaction Type`, Amount))

#View(filtered_data_com)

# Remove filtered rows from the original data frame
ser_df <- anti_join(ser_df, filtered_data_all)


########### Checking for empty space ######################################

# Count empty strings across character variables
empty_counts_for_all_var  <- ser_df %>%
  summarize(across(where(is.character), list(empty_count = ~sum(as.numeric(. == ""))))) %>% 
  show()


# Filter out rows where any specified column contains empty spaces or NA
rows_with_issue <- ser_df %>%
  filter(
    trimws(Date) == "" |
      trimws(`User Type`) == "" |
      trimws(`Transaction Type`) == "" |
      trimws(Amount) == ""
  )

#View(rows_with_issue)


# Filter out rows where any specified column contains empty spaces or NA
rows_with_issue_empty <- ser_df %>%
  filter(
    trimws(Date) == "" &
      trimws(`User Type`) == "" &
      trimws(`Transaction Type`) == "" &
      trimws(Amount) == ""
  )

#View(rows_with_issue_empty)

# Remove filtered rows from the original data frame
ser_df <- anti_join(ser_df, rows_with_issue_empty)


# Convert and separate into date and time columns
ser_df <- ser_df %>%
  mutate(
    Date = ymd_hms(Date),
    Full_date = as.Date(Date),
    Time = format(Date, "%H:%M:%S")
  )

#View(ser_df)

glimpse(ser_df)

# Process the dataframe to add Service_Period column
ser_df <- ser_df %>%
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
  )

# Convert Time back to character to keep only the time part
ser_df$Time <- format(ser_df$Time, format="%H:%M:%S")

colnames(ser_df)

# Renaming varaibles
ser_df <- ser_df %>%
  rename(
    User_Type = `User Type`, 
    Transaction_Type = `Transaction Type`, 
    Service_Fee = `Service Fee`, 
    Banker_Service_Fee = `Banker Service Fee`, 
    Customer_Service_Fee = `Customer Service Fee`,
    Transaction_Time = Service_Period
  )


# Select required row  
Price_df <- ser_df %>%
  select("Full_date", "User_Type", "Transaction_Type", "Transaction_Time", "Service_Fee", 
         "Banker_Service_Fee", "Customer_Service_Fee", "Amount")

View(Price_df)

nrow(Price_df)

############### Connection to Posgresql ######################################

install.packages("RPostgres")

library(odbc)
library(RODBC)
library(DBI)
library(RPostgres)



# Connection to the database
con <- dbConnect(RPostgres::Postgres(), 
                 dbname = "CrimeProject",
                 host = "localhost",
                 port = 5432,
                 user = "postgres",
                 password = "marvel")  # Password should be enclosed in quotes

# Write to the database, overwriting existing table
dbWriteTable(con, "crime_df", Crime_df, overwrite = TRUE)



# Write to the database, appending data to existing table
#dbWriteTable(con, "Crime_df", Crime_df, append = TRUE)


# Write to the database with a different table name
#dbWriteTable(con, "New_Crime_df", Crime_df)


dbDisconnect(con)


