# CCS
R data package with Clinical Classifications Software (CCS) mapping to common diagnosis and procedure codes.

The package includes 3 CCS categorizations:

* __CCS DX__: Diagnosis categorization initially created based on ICD-9 codes. ICD-10 code mappings were later included in the original categories as a beta release. 13726 ICD-9-CM and 72446 ICD-10-CM codes are aggregated to 308 CCS diagnosis categories.

* __CCSR DX__: Refined categorization released in 2019 and based on ICD-10 codes. Does not currently include ICD-9 code mappings. 82738 ICD-10-CM diagnosis codes are aggregated to 538 CCSR diagnosis categories.

* __CCS PCS__: Procedure categorization which includes groupings for HCPCS/CPT-4, ICD-9 and ICD-10 (beta).  54982 HCPCS/CPT4, 3948 ICD-9, and 80492 ICD-10 codes are aggregated to 244 CCS procedure categories.


## Installation

This currently can only be installed from github:

```R
# install.packages('devtools')
devtools::install_github("vcastro/CCS")
```

CCS is developed and maintained by the US Agency for Healthcare Research and Quality (AHRQ) as part of the Healthcare Cost and Utilization Project (HCUP).  This package may not contain the latest releases of CCS mapping data.  The latest mappings are available at: (https://www.hcup-us.ahrq.gov/tools_software.jsp)
