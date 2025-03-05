#' CCS Procedure Mapping
#'
#' A dataset containing the ICD-9-PCS, ICD-10-PCS, and HCPCS (CPT) codes for each CCS category.
#' 
#'
#' @format A data frame with 139422 obs. and 3 variables:
#' \describe{
#'   \item{category_code}{Numeric CCS procedure category code}
#'   \item{code}{ICD-9, ICD-10, or HCPCS procedure code, without prefixes or decimals}
#'   \item{vocabulary_id}{Either ICD9PCS, ICD10PCS or HCPCS}
#' }
#' @seealso \code{\link{CCS_PCS_categories}} for a list of CCS procedure categories.
#'
#' @source \url{https://www.hcup-us.ahrq.gov/toolssoftware/ccs/Multi_Level_CCS_2015.zip}
#' @source \url{https://www.hcup-us.ahrq.gov/toolssoftware/ccs10/ccs_pr_icd10pcs_2020_1.zip}
"CCS_PCS_mapping"