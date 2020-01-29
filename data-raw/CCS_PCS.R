## add major/minor column to mapping?

##ICD9 PCS to ICD10 PCS Trends
##https://www.hcup-us.ahrq.gov/datainnovations/ICD-10_PCS_Trends_11022017.pdf

library(tidyverse, warn.conflicts = FALSE)
source('data-raw/util.R')

##########################################################
###
### CCS PCS ICD-9
###
##########################################################

download_extract(url = "https://www.hcup-us.ahrq.gov/toolssoftware/ccs/Multi_Level_CCS_2015.zip",
                 exdir = "data-raw",
                 files = c("ccs_multi_pr_tool_2015.csv"))

CCS_ICD9_PCS <- read_csv("data-raw/ccs_multi_pr_tool_2015.csv", 
                         col_types = cols(.default = col_character()))


CCS_ICD9PCS_cat <- CCS_ICD9_PCS %>% 
  select(code = "'CCS LVL 2'", label = "'CCS LVL 2 LABEL'", bodysystem = "'CCS LVL 1 LABEL'") %>% 
  filter(grepl('[', label, fixed = TRUE)) %>% 
  unique() %>% 
  mutate(level = "L2") %>% 
  bind_rows(
    CCS_ICD9_PCS %>% 
      select(code = "'CCS LVL 3'", label = "'CCS LVL 3 LABEL'") %>% 
      filter(grepl('[', label, fixed = TRUE)) %>% 
      unique() %>% 
      mutate(level = "L3")
  ) %>% 
  mutate(cat_code = as.integer(str_extract(label, "(?<=\\[).+?(?=\\.)")),
         cat_code = ifelse(code == '\'7.15\'', 57, cat_code),
         cat_desc = sub("\\s*\\[.*", "", label)
  )


CCS_ICD9PCS_map <- CCS_ICD9_PCS %>% 
  inner_join(CCS_ICD9PCS_cat, by=c("'CCS LVL 2'" = "code")) %>% 
  select (cat_code, icd_code = "'ICD-9-CM CODE'") %>% 
  transmute(category_code = cat_code,
            code = str_remove_all(icd_code, "[^[:alnum:]]"),
            vocabulary_id = "ICD9PCS") %>% 
  bind_rows(
    CCS_ICD9_PCS %>% 
      inner_join(CCS_ICD9PCS_cat, by=c("'CCS LVL 3'" = "code")) %>% 
      select (cat_code, icd_code = "'ICD-9-CM CODE'") %>% 
      transmute(category_code = cat_code,
                code = str_remove_all(icd_code, "[^[:alnum:]]"),
                vocabulary_id = "ICD9PCS")
  )



##########################################################
###
### CCS PCS ICD-10
###
##########################################################

download_extract(url = "https://www.hcup-us.ahrq.gov/toolssoftware/ccs10/ccs_pr_icd10pcs_2020_1.zip",
                 exdir = "data-raw",
                 files = c("ccs_pr_icd10pcs_2020_1.csv"))

CCS_ICD10_PCS <- read_csv("data-raw/ccs_pr_icd10pcs_2020_1.csv", 
                          col_types = cols(.default = col_character()))


CCS_ICD10PCS_cat <- CCS_ICD10_PCS %>% 
  select(cat_code = "'CCS CATEGORY'", cat_desc = "'CCS CATEGORY DESCRIPTION'", bodysystem = "'MULTI CCS LVL 1 LABEL'") %>% 
  mutate(cat_code = as.integer(gsub("'", "", cat_code, fixed=TRUE))) %>% 
  unique()


CCS_ICD10PCS_map <- CCS_ICD10_PCS %>% 
  select(cat_code = "'CCS CATEGORY'", icd_code = "'ICD-10-PCS CODE'") %>% 
  transmute(category_code = as.integer(str_remove_all(cat_code, "'")),
            code = str_remove_all(icd_code, "[^[:alnum:]]"),
            vocabulary_id = "ICD10PCS") %>% 
  unique()



##########################################################
###
### CCS PCS HCPCS
###
##########################################################

download_extract(url = "https://www.hcup-us.ahrq.gov/toolssoftware/ccs_svcsproc/2019_ccs_services_procedures.zip",
                 exdir = "data-raw",
                 files = c("2019_ccs_services_procedures.csv"))

CCS_HCPCS <- read_csv("data-raw/2019_ccs_services_procedures.csv", 
                      col_types = cols(.default = col_character()), 
                      skip = 1) %>% 
  mutate(code_range = str_remove_all(`Code Range`, "'"))


CCS_HCPCS_cat <- CCS_HCPCS %>% 
  select(cat_code = CCS, cat_desc = "CCS Label") %>% 
  mutate(cat_code = as.integer(cat_code)) %>% 
  unique()


CCS_HCPCS_map <- CCS_HCPCS %>% 
  mutate(category_code = as.integer(CCS),
         code = map(code_range, expand_HCPCS_range),
         vocabulary_id = "HCPCS") %>% 
  unnest(code) %>% 
  select(category_code, code, vocabulary_id ) %>% 
  unique()



#write_rds(CCS_HCPCS_cat, "data/CCS_HCPCS_cat.rds")
#write_rds(CCS_HCPCS_map, "data/CCS_HCPCS_map.rds")



##########################################################
###
### CCS PCS - Combine ICD-9/ICD-10/HCPCS cat. & mappings
###
##########################################################


CCS_ICD_PCS_categories <- CCS_ICD10PCS_cat %>% 
  full_join(CCS_ICD9PCS_cat, by = c("cat_code")) %>% 
  transmute(code_chapter = ifelse(cat_code == 68, "Operations on the digestive system", ifelse(is.na(bodysystem.x), bodysystem.y, bodysystem.x)),
            category_code = cat_code,
            category_desc = ifelse(is.na(cat_desc.x), cat_desc.y, cat_desc.x)) 


CCS_PCS_categories <- CCS_ICD_PCS_categories %>% 
  full_join(CCS_HCPCS_cat, by = c("category_code" = "cat_code")) %>% 
  transmute(code_chapter = ifelse(category_code == 244, "Operations on the digestive system", 
                                ifelse(category_code >= 232, "Miscellaneous diagnostic and therapeutic procedures", bodysystem)),
            category_code = category_code,
            category_desc = cat_desc)


CCS_PCS_mapping <- bind_rows(CCS_ICD9PCS_map, CCS_ICD10PCS_map, CCS_HCPCS_map)

# 
# write_rds(CCS_PCS_cat, "data/CCS_PCS_categories.rds")
# write_rds(CCS_PCS_mapping, "data/CCS_PCS_mapping.rds")


# CCS_PCS_mapping %>% 
#  group_by(category_code, code_type) %>% 
#  count() %>% 
#  View()



usethis::use_data(CCS_PCS_categories, overwrite = TRUE)
usethis::use_data(CCS_PCS_mapping, overwrite = TRUE)