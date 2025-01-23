renv::restore()
install.packages("odbc")
install.packages("usethis")
library(usethis)
edit_r_environ()

# data base name, use an acronym to identify the database (e.g "CPRD GOLD")
dbName <- "IDRIL_1"

# create a DBI connection to your database
con <- DBI::dbConnect(odbc::odbc(),
                      Driver   = "ODBC Driver 17 for SQL Server",
                      Server   = Sys.getenv("DB_SERVER"),
                      Database = Sys.getenv("DATABASE"),
                      trusted_connection = "yes")

# schema in the database that contains OMOP CDM standard tables
cdmSchema <- "gold"

# schema in the database where you have writing permissions
writeSchema <- "dev_tim"

# created tables will start with this prefix
prefix <- "c_"

# minimum cell counts used for suppression
minCellCount <- 5

# to create the cdm object
cdm <- CDMConnector::cdmFromCon(
  con = con,
  cdmSchema = cdmSchema,
  writeSchema =  writeSchema,
  writePrefix = prefix,
  cdmName = dbName
)

cdm$observation_period <- cdm$observation_period |>
  dplyr::mutate(observation_period_start_date = as.Date(.data$observation_period_start_date), observation_period_end_date = as.Date(.data$observation_period_end_date))


source("RunCharacterisation.R")