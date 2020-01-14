# TODO
# Deal with cat 260
# QA
library(tidyverse, warn.conflicts = FALSE)
source('data-raw/util.R')


##########################################################
###
### CCS DX ICD-9
###
##########################################################

download_extract(url = "https://www.hcup-us.ahrq.gov/toolssoftware/ccs/Multi_Level_CCS_2015.zip",
                 exdir = "data-raw",
                 files = c("ccs_multi_dx_tool_2015.csv"))


CCS_ICD9_DX <- read_csv("data-raw/ccs_multi_dx_tool_2015.csv", 
                        col_types = cols(.default = col_character()))



CCS_ICD9DX_cat <- CCS_ICD9_DX %>% 
  select(code = "'CCS LVL 2'", label = "'CCS LVL 2 LABEL'") %>% 
  filter(grepl('[', label, fixed = TRUE)) %>% 
  unique() %>% 
  mutate(level = "L2") %>% 
  bind_rows(
    CCS_ICD9_DX %>%
      select(code = "'CCS LVL 2'", label = "'CCS LVL 3 LABEL'") %>%
      filter(grepl('[', label, fixed = TRUE)) %>%
      unique() %>%
      mutate(level = "L3")
  ) %>%
  mutate(cat_code = as.integer(str_extract(label, "(?<=\\[).+?(?=\\])")),
         cat_desc = sub("\\s*\\[.*", "", label))


CCS_ICD9_DXmap <- CCS_ICD9_DX %>% 
  inner_join(CCS_ICD9DX_cat, by=c("'CCS LVL 2'" = "code")) %>% 
  select (cat_code, icd_code = "'ICD-9-CM CODE'") %>% 
  transmute(category_code = cat_code,
            code = str_remove_all(icd_code, "'"),
            code_type = "ICD-9-CM") %>% 
  bind_rows(
    CCS_ICD9_DX %>% 
      inner_join(CCS_ICD9DX_cat, by=c("'CCS LVL 3'" = "code")) %>% 
      select (cat_code, icd_code = "'ICD-9-CM CODE'") %>% 
      transmute(category_code = cat_code,
                code = str_remove_all(icd_code, "'"),
                code_type = "ICD-9-CM"))



##########################################################
###
### CCS DX ICD-10
###
##########################################################

download_extract(url = "https://www.hcup-us.ahrq.gov/toolssoftware/ccs10/ccs_dx_icd10cm_2019_1.zip",
                 exdir = "data-raw",
                 files = c("ccs_dx_icd10cm_2019_1.csv"))

CCS_ICD10_DX <- read_csv("data-raw/ccs_dx_icd10cm_2019_1.csv", 
                         col_types = cols(.default = col_character()))



CCS_ICD10_DXcat <- CCS_ICD10_DX %>% 
  filter(!is.na(`'MULTI CCS LVL 2 LABEL'`)) %>% 
  select(cat_code = "'CCS CATEGORY'", cat_desc = "'CCS CATEGORY DESCRIPTION'", bodysystem = "'MULTI CCS LVL 1 LABEL'") %>% 
  mutate(cat_code = as.integer(gsub("'", "", cat_code, fixed=TRUE))) %>% 
  unique()



CCS_ICD10_DXmap <- CCS_ICD10_DX %>% 
  select(cat_code = "'CCS CATEGORY'", icd_code = "'ICD-10-CM CODE'") %>% 
  transmute(category_code = as.integer(str_remove_all(cat_code, "'")),
            code = str_remove_all(icd_code, "'"),
            code_type = "ICD-10-CM") %>% 
  unique()



##########################################################
###
### CCS DX Combine ICD-9/ICD-10 cat. and mappings
###
##########################################################

CCS_DX_categories <- CCS_ICD10_DXcat %>% 
  full_join(CCS_ICD9DX_cat, by = c("cat_code")) %>% 
  transmute(bodysystem = ifelse(cat_code == 150, "Diseases of the digestive system",  
                                ifelse(cat_code >= 6500, "Mental Illness",
                                       ifelse(cat_code == 260, "Residual codes; unclassified; all E codes [259. and 260.]", bodysystem))),
            category_code = cat_code,
            category_desc = ifelse(is.na(cat_desc.x), cat_desc.y, cat_desc.x))


CCS_DX_mapping <- bind_rows(CCS_ICD9_DXmap, CCS_ICD10_DXmap)


# write_rds(CCS_DX_categories, "data/CCS_DX_categories.rds")
# write_rds(CCS_DX_mapping, "data/CCS_DX_mapping.rds")



# CCS_DX_mapping %>%
#   group_by(category_code, code_type) %>%
#   count() %>%
#   View()


usethis::use_data(CCS_DX_categories)
usethis::use_data(CCS_DX_mapping)
