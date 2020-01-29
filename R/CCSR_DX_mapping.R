#' CCSR Diagnosis Category Mappings
#'
#' A dataset containing the CCSR category mapping to ICD codes 
#' (currently only ICD10).
#' 
#'
#' @format A data frame with 82738 obs. and 4 variables:
#' \describe{
#'   \item{CCSR_category_code}{CCSR category code}
#'   \item{vocabulary_id}{Source vocabulary for mapping code}
#'   \item{code}{Source vocabulary code (currently only ICD10)}
#'   \item{code_description}{Description of source code}
#' }
#' @source \url{https://www.hcup-us.ahrq.gov/toolssoftware/ccsr/DXCCSR2020_1.zip}
#' 
#' @seealso \code{\link{CCSR_DX_categories}} for description of each CCSR category.
#'
"CCSR_DX_mapping"