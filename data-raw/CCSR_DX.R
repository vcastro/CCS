options(tidyverse.quiet = TRUE)
library(tidyverse)
source('data-raw/util.R')


##########################################################
###
### CCSR DX ICD-10
###
##########################################################

download_extract(url = "https://www.hcup-us.ahrq.gov/toolssoftware/ccsr/DXCCSR2020_1.zip",
                 exdir = "data-raw",
                 files = c("DXCCSR-Reference-File-v2020-1.xlsx"))


CCSR_DX_src <- readxl::read_xlsx("data-raw/DXCCSR-Reference-File-v2020-1.xlsx", 
                                 sheet = "CCSR_Categories")


CCSR_DX_chapters <- tribble(
  ~chapter_number, ~chapter_desc, ~chapter_abbr, 
  1, "Certain infectious and parasitic diseases", "INF",
  2, "Neoplasms", "NEO",
  3, "Diseases of the blood and blood-forming organs and certain disorders involving the immune mechanism", "BLD",
  4, "Endocrine, nutritional and metabolic diseases", "END",
  5, "Mental, behavioral and neurodevelopmental disorders", "MBD",
  6, "Diseases of the nervous system", "NVS",
  7, "Diseases of the eye and adnexa", "EYE",
  8, "Diseases of the ear and mastoid process", "EAR",
  9, "Diseases of the circulatory system", "CIR",
  10, "Diseases of the respiratory system", "RSP",
  11, "Diseases of the digestive system", "DIG",
  12, "Diseases of the skin and subcutaneous tissue", "SKN",
  13, "Diseases of the musculoskeletal system and connective tissue", "MUS",
  14, "Diseases of the genitourinary system", "GEN",
  15, "Pregnancy, childbirth and the puerperium", "PRG",
  16, "Certain conditions originating in the perinatal period", "PNL",
  17, "Congenital malformations, deformations and chromosomal abnormalities", "MAL",
  18, "Symptoms, signs and abnormal clinical and laboratory findings, not elsewhere classified", "SYM",
  19, "Injury, poisoning and certain other consequences of external causes", "INJ",
  20, "External causes of morbidity", "EXT",
  21, "Factors influencing health status and contact with health services", "FAC"
)


CCSR_DX_categories <- CCSR_DX_src %>% 
  mutate(chapter_abbr = substr(`CCSR CATEGORY`, 1, 3)) %>% 
  left_join(CCSR_DX_chapters, by="chapter_abbr") %>% 
  select(chapter_abbr, chapter_number, chapter_desc, 
         CCSR_category_code = `CCSR CATEGORY`, 
         CCSR_category_desc = `CCSR CATEGORY DESCRIPTION`)


CCSR_DX_map_src <- readxl::read_xlsx("data-raw/DXCCSR-Reference-File-v2020-1.xlsx", 
                                 sheet = "DXCCSR_Mapping")


CCSR_DX_mapping <- CCSR_DX_map_src %>% 
  mutate(vocabulary_id = 'ICD10CM') %>% 
  select(CCSR_category_code = `CCSR CATEGORY`, vocabulary_id, 
         code = `ICD-10-CM CODE`, 
         code_description = `ICD-10-CM CODE DESCRIPTION` )





usethis::use_data(CCSR_DX_categories, overwrite=TRUE)
usethis::use_data(CCSR_DX_mapping, overwrite=TRUE)


# QA
# CCSR_DX_mapping %>% 
#   anti_join(CCSR_DX_categories, by = "CCSR_category_code")
# 
# CCSR_DX_categories %>% 
#   anti_join(CCSR_DX_mapping, by = "CCSR_category_code")
# 


