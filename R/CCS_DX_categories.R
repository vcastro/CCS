#' CCS Diagnosis Categories
#'
#' A dataset containing the CCS diagnosis categories for both ICD-9-CM and ICD-10-CM. 
#' 
#'
#' @format A data frame with 308 obs. and 4 variables:
#' \describe{
#'   \item{code_chapter}{CCS Level 1 description based on ICD body system}
#'   \item{category_code}{Numeric CCS category code}
#'   \item{L2code}{CCS Level 2 code for category}
#'   \item{category_desc}{Description of CCS category}
#' }
#' @source \url{https://www.hcup-us.ahrq.gov/toolssoftware/ccs/Multi_Level_CCS_2015.zip}
#' @source \url{https://www.hcup-us.ahrq.gov/toolssoftware/ccs10/ccs_dx_icd10cm_2019_1.zip}
#' 
#' @seealso \code{\link{CCS_DX_mapping}} for ICD code mapping for each CCS category.
#'
"CCS_DX_categories"