#===============================================================================
# 1. Join the cbms_person_record with cbms_person_record_tvet from the 2024
#    CBMS data to get the individuals who completed/attended TVET courses. The
#    output should include the name, age, sex and TVET course/s of the concerned
#    individuals.
#===============================================================================
library(dplyr)
library(rcdf)

env <- read_env()
password <- env$PRIVATE_KEY_PW
decryption_key <- "data/sample-rcdf/RSA Keys/1001319-private-key.pem"
rcdf_file <- "data/sample-rcdf/1001319 Sumilao.rcdf"

cbms2024 <- read_rcdf(
  path = rcdf_file,
  decryption_key = decryption_key,
  password = password,
  return_meta = TRUE
)

person_record <- cbms2024$cbms_person_record |>
  filter(d07_tvet_graduate == 1) |>
  select(uuid, line_number, region_code, province_code, city_mun_code,
         barangay_code, a01_first_name, a01_middle_name, a01_last_name,
         a05_age, a03_sex)

tvet_record <- cbms2024$cbms_person_record_tvet |>
  select(uuid, line_number, region_code, province_code, city_mun_code,
         barangay_code, d09_tvet_course)

joined_data <- person_record |>
  left_join(tvet_record, by = c("uuid",
                                "line_number",
                                "region_code",
                                "province_code",
                                "city_mun_code",
                                "barangay_code")) |>
  mutate(full_name = paste(a01_first_name, a01_middle_name, a01_last_name)) |>
  select(full_name, a05_age, a03_sex, d09_tvet_course)

View(joined_data)

#===============================================================================
# 2. Join Section Q and R records from the 2022 CBMS data to get the households’
#    main source of water supply, source of drinking water, toilet facility,
#    type of building they occupy, as well as the materials of the roof, outer
#    wall and floor of the building/housing unit they occupy.
#===============================================================================
library(dplyr)
library(readr)

section_q_2022 <- read_delim("data/sample-txt/SECTION_Q.TXT", delim = "\t") |>
  rename_all(tolower)
section_r_2022 <- read_delim("data/sample-txt/SECTION_R.TXT", delim = "\t") |>
  rename_all(tolower)

household_housing_info <- section_q_2022 |>
  mutate(
    area_code_old = paste0(region_code,
                           province_code,
                           city_mun_code,
                           barangay_code,
                           ean,
                           bsn,
                           husn,
                           hsn)
  ) |>
  inner_join(
    section_r_2022 |> mutate(area_code_old = paste0(region_code,
                                                    province_code,
                                                    city_mun_code,
                                                    barangay_code,
                                                    ean,
                                                    bsn,
                                                    husn,
                                                    hsn)),
    by = "area_code_old"
  ) |>
  select(
    "Area Code" = area_code_old,
    "Main water Source" = q01_main_water,
    "Drinking Water Source" = q03_drinking_water,
    "Toilet Facility" = q14_toilet_facility,
    "Building Type" = r01_building_type,
    "Roof Material" = r03_roof,
    "Outer Wall Material" = r04_outer_walls,
    "Floor Material" = r05_floor_finishing
  )

View(household_housing_info)


#===============================================================================
# 3. Generate a summary table showing the total number of households and
#    population per barangay for both CBMS rounds (2022 vs 2024).
#===============================================================================

#-------------------------------------#
#section_a_to_e_2022 (for individual) #
#geo_2022 (for household)             #
#2022 Data                            #
#-------------------------------------#
library(phscs)

section_a_to_e_2022 <- read_delim("data/sample-txt/SECTION_A_TO_E.TXT", delim = "\t") |>
  rename_all(tolower)

geo_2022 <- read_delim("data/sample-txt/GEO_INFO.TXT", delim = "\t") |>
  rename_all(tolower)


#2022 Population per Barangay---------------------------------------------------
total_2022 <- section_a_to_e_2022 %>%
  rename_all(tolower) %>%
  mutate(
    area_code_old = paste0(region_code,
                           province_code,
                           city_mun_code,
                           barangay_code)
  ) %>%
  group_by(area_code_old) %>%
  summarise(
    population_2022 = n()
  )

#2022 Total Number of Households per Barangay-----------------------------------
total_hh_2022 <- geo_2022 %>%
  rename_all(tolower) %>%
  mutate(
    area_code_old = paste0(region_code,
                           province_code,
                           city_mun_code,
                           barangay_code)
  ) %>%
  group_by(area_code_old) %>%
  summarise(
    population_hh_2022 = n()
  )

#Join 2022 Population and 2022 Household Population by area_code_old------------
data_2022 <- inner_join(total_2022, total_hh_2022, by = "area_code_old")


#-------------------------------------------#
#cbms2024_person_record (for individual)    #
#cbms2024_household_record (for household)  #
#-------------------------------------------#

#2024 Population per Barangay---------------------------------------------------
total_2024 <- cbms2024$cbms_person_record %>%
  mutate(
    area_code = paste0(region_code,
                           province_code,
                           city_mun_code,
                           barangay_code)
  ) %>%
group_by(area_code) %>%
  summarise(
    population_2024 = n()
  )

#2024 Total Number of Households per Barangay-----------------------------------
total_hh_2024 <- cbms2024$cbms_household_record %>%
  mutate(
    area_code = paste0(region_code,
                           province_code,
                           city_mun_code,
                           barangay_code)
  ) %>%
group_by(area_code) %>%
  summarise(
    population_hh_2024 = n()
  )

#Join 2024 Population and 2024 Household Population by area_code_old------------
data_2024 <- full_join(total_2024, total_hh_2024, by = "area_code")

#Get Data from PSGC for Area Name
area_names <- get_psgc(
  str_detect(area_code, "^1001319") &
    geographic_level == 6
)

#2022 Population and Household Population---------------------------------------
population_comparison_2022 <-data_2022 %>%
  rename_all(tolower) %>%
  left_join(area_names, by ="area_code_old") %>%
  select(area_name, population_2022, population_hh_2022)
population_comparison_2022

#2024 Population and Household Population---------------------------------------
population_comparison_2024 <- data_2024 %>%
  rename_all(tolower) %>%
  left_join(area_names, by ="area_code") %>%
  select(area_name, population_2024, population_hh_2024)
population_comparison_2024


#2022 vs 2024 Population and Household Population
cbms_2022_2024 <- full_join(population_comparison_2022, population_comparison_2024) %>%
  rename("Barangay" = "area_name",
         "2022 Population" = population_2022,
         "2022 Household Population" = population_hh_2022,
         "2024 Population" = population_2024,
         "2024 Household Population" = population_hh_2024)

View(cbms_2022_2024)




