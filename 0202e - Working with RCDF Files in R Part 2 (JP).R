library(dplyr)
library(tidyr)

#===============================================================================
# 1. Create new record (subset) from data$cbms_person_record that contains all
#    senior citizens living alone; then get the count by barangay
#    (using area_code). The resulting data frame should have two columns:
#    area_code and senior_citizen_count.
#===============================================================================
senior_citizens_count <- data$cbms_person_record |>
  mutate(
    area_code = paste0(
      region_code,
      province_code,
      city_mun_code,
      barangay_code
    ), .after = 1) |>
  filter(a05_age >= 60, b02_relation_to_nuclear_family_head == 0) |>
  group_by(area_code) |>
  summarize(senior_citizen_count = n())

View(senior_citizens_count)


#===============================================================================
# 2. Find households that are homeless in the dataset, if any, and aggregate by
#    area_code.
#===============================================================================
homeless <- data$cbms_household_record |>
  mutate(
    area_code = paste0(
      region_code,
      province_code,
      city_mun_code,
      barangay_code
    )) |>
  filter(o01_building_type == 8) |>
  group_by(area_code) |>
  summarise(homeless_count = n())

View(homeless)


#===============================================================================
# 3. Find individuals with disabilities who are also senior citizens, and
#    aggregate by area_code.
#===============================================================================
senior_disability <- data$cbms_person_record |>
  filter(a05_age >= 60) |>
  filter(
    b12_a_visual_disability == 1 |
      b12_b_hearing_disability == 1 |
      b12_c_mental_disability == 1 |
      b12_d_physical_disability == 1 |
      b12_e_speech_impairment == 1 |
      b12_f_cancer == 1 |
      b12_g_rare_disease == 1 |
      b12_z_other_disability == 1
  ) |>
  mutate(
    area_code = paste0(
      region_code,
      province_code,
      city_mun_code,
      barangay_code
    )
  ) |>
  group_by(area_code) |>
  summarise(
    senior_pwd_count = n()
  )

View(senior_disability)



#===============================================================================
# 4. Find individual who’s date of birth is on February 29 (leap year) and
#    change the middle name (a01_middle_name) to middle initial.
#===============================================================================
leap_birth <- data$cbms_person_record |>
  filter(a04_birthday_month == "02", a04_birthday_day == "29") |>
  mutate(
    a01_middle_initial = ifelse(
      !is.na(a01_middle_name) & nchar(a01_middle_name) > 0,
      sub("^(.).*", "\\1", a01_middle_name),
      a01_middle_name
    ), .after = 8
  )

View(leap_birth)


#===============================================================================
# 5. Find all working children (aged 5-17) who are not attending school, and
#    aggregate by area_code.
#===============================================================================
working_children <- data$cbms_person_record |>
  filter(
    a05_age >= 5 & a05_age <= 17,
    d01_currently_attending_school == 1,
    e01_employment_status == 1
  ) |>
  mutate(
    area_code = paste0(region_code, province_code, city_mun_code, barangay_code)
  ) |>
  group_by(area_code) |>
  summarise(
    working_children_count = n()
  )

View(working_children)
