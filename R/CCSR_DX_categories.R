#' CCSR Diagnosis Categories
#'
#' A dataset containing the CCSR diagnosis categories.
#' 
#'
#' @format A data frame with 538 obs. and 5 variables:
#' \describe{
#'   \item{chapter_abbr}{CCSR code prefix based on ICD-10 chapters}
#'   \item{chapter_number}{Numeric index for chapter (useful for plotting)}
#'   \item{chapter_desc}{Description of CCSR code chapter}
#'   \item{CCSR_category_code}{CCSR category code}
#'   \item{CCSR_category_desc}{Description of CCSR category}
#' }
#' @source \url{https://www.hcup-us.ahrq.gov/toolssoftware/ccsr/DXCCSR2020_1.zip}
#' 
#' @seealso \code{\link{CCSR_DX_mapping}} for ICD code mapping for each CCSR category.
#'
"CCSR_DX_categories"