library(stringr)

phone_numbers <- c(
  "09123456789", "(0917)123-4567", "0917.123.4567",
  "0917 123 4567", "+6309171234567"
)

#===============================================================================
# 1. Use str_detect() to identify which phone numbers start with “09” or “+63”.
#===============================================================================
str_detect(phone_numbers,"^(09|\\+63)")


#===============================================================================
# 2. Use str_extract() to extract the area code (the first four digits) from
#    each phone number.
#===============================================================================
str_extract(phone_numbers,"\\d{4}")


#===============================================================================
# 3. Use str_replace() or str_replace_all() to standardize all phone numbers to
#    the format “0917 123 4567”.
#===============================================================================
replace_number <- str_replace_all(
  str_replace(phone_numbers,"^(\\+63)","09")
  ,"\\D","")
eleven_digits <- str_extract(replace_number, "\\d{11}")
standard_number <- str_replace_all(eleven_digits, "(\\d{4})(\\d{3})(\\d{4})","\\1 \\2 \\3")
standard_number


#===============================================================================
# 4. Use str_split() to split each phone number (from item 3) into its
#    individual component: 4 digits, 3 digits, 4 digits.
#===============================================================================
str_split(z, pattern = " ")
