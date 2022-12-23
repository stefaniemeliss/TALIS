# --------------- read in TALIS data --------------- #

rm(list = ls())

library(EdSurvey) # see https://www.air.org/project/nces-data-r-project-edsurvey
# https://naep-research.airprojects.org/Portals/0/EdSurvey_A_Users_Guide/_book/philosophyOfAnalysis.html

# define directories
cd <- getwd() # get project directory
setwd("..") # go to parent directory
root_dir <- getwd() # save parent directory

# download data
downloadTALIS(root_dir, # within root_dir, subdirectories TALIS/[year]
              years = 2018, # avail years: 2008, 2013, 2018
              cache = TRUE) # caching data speeds up later reading of the files

# define directory in which data is stored
data_dir <- file.path(root_dir, "TALIS", "2018")

# go back to project dir
setwd(cd)

# read in downloaded data as edsurvey.data.frame (sdf)
sdf <- EdSurvey::readTALIS(
  path = data_dir,
  countries = "eng", # data for England only
  dataLevel = "teacher", # allows to analyse teacher and school variables togther
  isced = "b"
  # a stands for Primary Level 
  # b is for Lower Secondary Level
  # c is for Upper Secondary Level
)

# print basic information
sdf
colnames(sdf)

# ----- useful EdSurvey functions ----- #

# EdSurvey Codebook Search
# Retrieves variable names and labels for SDF using character string matching
searchSDF("learning", # string to search for in codebook
          sdf, # SDF
          levels = TRUE # return levels in SDF
          )

# Show codebook
View(showCodebook(sdf))
codebook <- showCodebook(sdf)
write.csv(codebook, "codebook_talis_2018_eng.csv", row.names = F)

# Retrieve the levels and labels of a variable
levelsSDF(varnames = "tt3g34e", data = sdf)
levelsSDF(varnames = "t3effpd", data = sdf)

# summarise a variable
summary2(data = sdf,
         variable = "tt3g34e")

summary2(data = sdf,
         variable = "t3effpd")


# ----- Retrieving All Variables in a Dataset ----- #

# https://www.air.org/sites/default/files/EdSurvey-getData.pdf

# use getData in combination with colnames to read SDF to standard df
df <- getData(data = sdf, 
              varnames = colnames(sdf), 
              addAttributes = TRUE, # get df that can be used in other functions that usually work on sdf
              omittedLevels = FALSE, # drop "Omitted Levels"
              defaultConditions = FALSE
              )
# export as csv file
write.csv(df, "data_talis_2018_eng.csv", row.names = F)