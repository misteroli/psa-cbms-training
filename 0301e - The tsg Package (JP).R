#===============================================================================
#tsg FIRST HANDS-ON EXERCISE
#===============================================================================
library(tsg)
library(dplyr)
library(rcdf)

env <- read_env()
password <- env$PRIVATE_KEY_PW
decryption_key <- "data/sample-rcdf/RSA Keys/1001319-private-key.pem"
rcdf_file <- "data/sample-rcdf/1001319 Sumilao.rcdf"

data <- read_rcdf(
  path = rcdf_file,
  decryption_key = decryption_key,
  password = password,
  return_meta = TRUE
)

#===============================================================================
# Using the generate_frequency() function, generate the following frequency
# tables:
# 1. Five-year age group, include cumulative frequency and percentage, and
#    position the total row at the top.
#===============================================================================
five_year_age_group <- data$cbms_person_record %>%
  generate_frequency(
    a05_age_group_five_years,
    add_cumulative = TRUE,
    add_cumulative_percent = TRUE,
    position_total = "top"
  )



#===============================================================================
# 2. Highest educational attainment (a11_hgc_group) of the household head.
#===============================================================================
hgc <- data$cbms_person_record %>%
  filter(a02_relation_to_hh_head == 1) %>%
  generate_frequency(
    a11_hgc_group
  )




#===============================================================================
# 3. Strength of construction materials of the house ((roof, floor, and
#    outer walls), then collapse the list into a single data frame.ad.
#===============================================================================
construction_strength <- data$cbms_household_record %>%
  generate_frequency(
    o03_roof_strength,
    o04_outer_walls_strength,
    o06_floor_strength,
    collapse_list = TRUE
  )



#===============================================================================
# 4. Number of households with access to electricity (o11_electricity), grouped
#    by barangay.
#===============================================================================
electricity_access <- data$cbms_household_record %>%
  group_by(barangay_code) %>%
  generate_frequency(o11_electricity, group_as_list = TRUE)


#===============================================================================
# 5. Top 10 religious affiliations (a08_religion) of the household members, and
#    express the values as proportions.
#===============================================================================
top_10_religion <- data$cbms_person_record %>%
  generate_frequency(a08_religion,
                     as_proportion = TRUE)

#===============================================================================
#tsg SECOND HANDS-ON EXERCISE
#===============================================================================

#===============================================================================
# Generate the following cross-tabulations using the generate_crosstab()
# function:
# 1. Employment, unemployment, and underemployment rates by sex, grouped by
# barangay.
#===============================================================================
library(dplyr)
library(rcdf)

employment_rates <- data$cbms_person_record %>%
  mutate(
    emp_status = case_when(
      e01_employment_status == 1 & e12_want_more_hours == 1 ~ "Underemployed",
      e01_employment_status == 1 ~ "Employed",
      e01_employment_status == 2 ~ "Unemployed"
    )
  ) %>%
  group_by(barangay_code) %>%
  generate_crosstab(emp_status,
                    a03_sex,
                    group_as_list = TRUE)

#===============================================================================
# 2. Perception of safety of the respondents by barangay.
#===============================================================================
perception_safety <- data$cbms_household_record |>
  generate_crosstab(l01_safe_walking_alone, barangay_code)


#===============================================================================
# 3. Pregnant and lactating/breastfeeding mothers below 20 years old by basic
#    literacy.
#===============================================================================
pregnant_basic_literacy <- data$cbms_person_record %>%
       filter(a05_age < 20 & b09_lactating_mother == 1) %>%
       generate_crosstab(b09_lactating_mother,
                         a10_simple_literacy)



#===============================================================================
# 4. Reason for not attending school by sex, grouped by barangay.
#===============================================================================
reason_not_attending <- data$cbms_person_record %>%
  group_by(barangay_code) %>%
  generate_crosstab(d06_reason_not_attending_school,
                    a03_sex  )

