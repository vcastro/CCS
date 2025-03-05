#' CCS Procedure Categories
#'
#' A dataset containing the CCS procedure categories for ICD-9-PCS, ICD-10-PCS 
#' and HCPCS (including CPT-4). 
#' 
#'
#' @format A data frame with 244 obs. and 3 variables:
#' \describe{
#'   \item{code_chapter}{CCS Level 1 description based on ICD body system}
#'   \item{category_code}{Numeric CCS procedure category code}
#'   \item{category_desc}{Description of CCS procedure category}
#' }
#' @source \url{https://www.hcup-us.ahrq.gov/toolssoftware/ccs/Multi_Level_CCS_2015.zip}
#' @source \url{https://www.hcup-us.ahrq.gov/toolssoftware/ccs10/ccs_dx_icd10cm_2019_1.zip}
#' 
#' @seealso \code{\link{CCS_PCS_mapping}} for ICD and HCPCS code mapping for each CCS  
#' procedure category.
#'
"CCS_PCS_categories"