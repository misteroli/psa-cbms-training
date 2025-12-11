#===============================================================================
# 1. Read the RCDF file 1001319 Sumilao.rcdf using the provided decryption key
#    and password.
#===============================================================================
library(rcdf)
library(dplyr)

env <- read_env()

password <- env$PRIVATE_KEY_PW

decryption_key <- "data/sample-rcdf/RSA Keys/1001319-private-key.pem"

data <- read_rcdf(
  path = "data/sample-rcdf/1001319 Sumilao.rcdf",
  decryption_key = decryption_key,
  password = password,
  return_meta = TRUE
)

attributes(data)
class(data)
names(data)
glimpse(data)
View(data)




#===============================================================================
# 2. Find all available metadata in the RCDF file, aside from mentioned in the
#    previous slides.
#===============================================================================
path <- "data/sample-rcdf/1001319 Sumilao.rcdf"

keys <- c(
  "source_note", "psgc_version", "summary_statistics", "ignore_duplicates",
  "key_app", "iv_app", "key_admin", "iv_admin", "pc_os", "pc_os_release_date",
  "pc_os_version", "pc_hardware", "version","dir_base")

for (k in keys) {
  value <- get_rcdf_metadata(path, key = k)
  paste(cat(k," : ", value, "\n"))
}

#===============================================================================
# 3. Extract the data dictionary from the RCDF file and save it as
#    data_dictionary.
#===============================================================================
data_dictionary <- get_rcdf_metadata(
  path = path,
  key = "dictionary"
)

glimpse(data_dictionary)
View(data_dictionary)


#===============================================================================
# 4. Get all variables in the data_dictionary object (in item 3) that start
#    with “a01”, “a03”, and “e” and save it as data_dictionary_filtered.
#===============================================================================
library(stringr)

data_dictionary_filtered <- data_dictionary %>%
  filter(str_detect(variable_name,"^(a01|a03|e)"))

glimpse(data_dictionary_filtered)
View(data_dictionary_filtered)



#===============================================================================
# 5. Filter the data_dictionary_filtered object to only include variables that
#    are of type character (c) or integer (i).
#===============================================================================
data_dictionary_filtered <- data_dictionary %>%
  filter(type %in% c("c","i"))

glimpse(data_dictionary_filtered)
View(data_dictionary_filtered)


#===============================================================================
# 6. Get the valueset for a02_relation_to_hh_head. This must return a data
#    frame or a tibble with two columns: value and label. Name it
#    relation_to_hh_head_valueset.
#===============================================================================
relation_to_hh_head_valueset <- data_dictionary[
  data_dictionary$variable_name == "a02_relation_to_hh_head",
]$valueset[[1]]


glimpse(relation_to_hh_head_valueset)
View(relation_to_hh_head_valueset)
