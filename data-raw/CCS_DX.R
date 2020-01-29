
options(tidyverse.quiet = TRUE)
library(tidyverse)
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


CCS_ICD9_DX_L2 <- CCS_ICD9_DX %>% 
  mutate(code = str_trim(str_remove_all(`'ICD-9-CM CODE'`, "'")),
         code_type = "ICD9CM",
         L2code = str_remove_all(`'CCS LVL 2'`, "'"),
         label = `'CCS LVL 2 LABEL'`,
         code_chapter = `'CCS LVL 1 LABEL'`,
         cat_code = as.integer(str_extract(label, "(?<=\\[).+?(?=\\])")),
         cat_desc = sub("\\s*\\[.*", "", label)) %>% 
  filter(str_detect(label, '\\[')) %>% 
  select(code_chapter, code, code_type, L2code, cat_code, cat_desc )


CCS_ICD9_DX_L3 <- CCS_ICD9_DX %>% 
  mutate(code = str_trim(str_remove_all(`'ICD-9-CM CODE'`, "'")),
         code_type = "ICD9CM",
         L2code = str_remove_all(`'CCS LVL 2'`, "'"),
         label = `'CCS LVL 3 LABEL'`,
         code_chapter = `'CCS LVL 1 LABEL'`,
         cat_code = as.integer(str_extract(label, "(?<=\\[).+?(?=\\])")),
         cat_desc = sub("\\s*\\[.*", "", label)) %>% 
  filter(str_detect(label, '\\[')) %>% 
  select(code_chapter, code, code_type, L2code, cat_code, cat_desc )


CCS_ICD9DX_cat <- CCS_ICD9_DX_L2 %>% 
  bind_rows(CCS_ICD9_DX_L3) %>% 
  select(code_chapter, cat_code, L2code, cat_desc) %>% 
  unique()

CCS_ICD9_DXmap <- CCS_ICD9_DX_L2 %>% 
  bind_rows(CCS_ICD9_DX_L3) %>% 
  mutate(vocabulary_id = "ICD9CM") %>% 
  select(category_code = cat_code, code, vocabulary_id) %>% 
  unique()


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
  #filter(!is.na(`'MULTI CCS LVL 2 LABEL'`)) %>% 
  select(L2code = "'MULTI CCS LVL 2'", cat_code = "'CCS CATEGORY'", cat_desc = "'CCS CATEGORY DESCRIPTION'", code_chapter = "'MULTI CCS LVL 1 LABEL'") %>% 
  mutate(cat_code = as.integer(gsub("'", "", cat_code, fixed=TRUE)),
         L2code = ifelse(L2code == "' '", NA, str_remove_all(L2code, "'"))) %>% 
  unique()



CCS_ICD10_DXmap <- CCS_ICD10_DX %>% 
  select(cat_code = "'CCS CATEGORY'", icd_code = "'ICD-10-CM CODE'") %>% 
  transmute(category_code = as.integer(str_remove_all(cat_code, "'")),
            code = str_remove_all(icd_code, "'"),
            vocabulary_id = "ICD10CM") %>% 
  unique()



##########################################################
###
### CCS DX Combine ICD-9/ICD-10 cat. and mappings
###
##########################################################

CCS_DX_categories <- CCS_ICD10_DXcat %>% 
  full_join(CCS_ICD9DX_cat, by = c("cat_code", "L2code")) %>% 
  transmute(code_chapter = ifelse(is.na(code_chapter.x), code_chapter.y, code_chapter.x),
            code_chapter = ifelse(cat_code == 150, "Diseases of the digestive system",  
                                ifelse(cat_code >= 6500, "Mental Illness",
                                       ifelse(cat_code == 260, "Residual codes; unclassified; all E codes [259. and 260.]", code_chapter))),
            category_code = cat_code,
            L2code = L2code,
            category_desc = ifelse(is.na(cat_desc.x), cat_desc.y, cat_desc.x)) %>% 
  unique()


CCS_DX_mapping <- bind_rows(CCS_ICD9_DXmap, CCS_ICD10_DXmap)


# CCS_DX_mapping %>%
#   group_by(category_code, code_type) %>%
#   count() %>%
#   View()




usethis::use_data(CCS_DX_categories, overwrite=TRUE)
usethis::use_data(CCS_DX_mapping, overwrite=TRUE)


# QA
 # CCS_DX_mapping %>%
 #   anti_join(CCS_DX_categories, by = "category_code") %>%
 #   select(category_code) %>% unique()
 # 
 # CCS_DX_categories %>%
 #   anti_join(CCS_DX_mapping, by = "category_code")
 # 