# Load package
library(dplyr)
library(xlsx)
# Set the working directory
setwd("/apps/rspro/projects/healthcare-data-comparison/institutional")

# Hard set the select function
select <- dplyr::select

# Read in the institutional data set
work_book1 <- read.csv("institutional_data_ehp_healthnow_mvp.csv")

# Look at the structure
str(work_book1)

# Look at the column names
names(work_book1)

# Selecting the column names and arranging them with NPI and address
work_book2 <-
  select(work_book1,
         National.Provider.Indentification,
         Plan.Name, Standardized.Add.1,
         Standardized.City,
         Standardized.State,
         Standardized.County.Name,
         Standardized.ZIP, License.Number,
         Medicaid.Provider.Identification.No,
         Provider.Primary.Specialty,
         Phone.Number) %>%
  arrange(National.Provider.Indentification,
          Standardized.Add.1,
          Standardized.City,
          Standardized.State,
          Standardized.County.Name,
          Standardized.ZIP)
# Recheck the column names
names(work_book2)

# Create a table and extract the NPI column.
# Then use that to substitute the NPI when it is greater than 1
# Assign subset to work_book2_new
id.table <- table(work_book2$National.Provider.Indentification)
work_book2_new <- subset(work_book2, National.Provider.Indentification %in% names(id.table[id.table > 1]))

# Use unique function, this function will remove duplicates but keep the original
a <- unique(work_book2_new)

# This is to clean up and remove any individual NPI
# If their were two identical NPI rows than the unique function would remove one
# Without another health plan to compare it to, the NPI has no value and should be removed
id.table2 <- table(a$National.Provider.Indentification)
remove_individual_npi <- subset(a, National.Provider.Indentification %in% names(id.table2[id.table2 > 1]))

# Export to a Excel file
write.csv(remove_individual_npi, "/apps/rspro/projects/healthcare-data-comparison/institutional/remove_individual_npi.csv")
