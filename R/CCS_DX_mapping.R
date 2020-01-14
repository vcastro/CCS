#' CCS Diagnosis Mapping
#'
#' A dataset containing the ICD-9-CM and ICD-10-CM codes for each CCS category
#' 
#'
#' @format A data frame with 113440 obs. and 3 variables:
#' \describe{
#'   \item{category_code}{Numeric CCS category code}
#'   \item{code}{ICD-9 or ICD-10 diagnosis code, without prefixes or decimals}
#'   \item{code_type}{Either ICD-9-CM or ICD-10-CM}
#' }
#' @seealso \code{\link{CCS_DX_categories}} for a list of CCS categories.
#'
#' @source \url{https://www.hcup-us.ahrq.gov/toolssoftware/ccs/Multi_Level_CCS_2015.zip}
#' @source \url{https://www.hcup-us.ahrq.gov/toolssoftware/ccs10/ccs_dx_icd10cm_2019_1.zip}
"CCS_DX_mapping"