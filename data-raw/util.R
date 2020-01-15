
#utils

download_extract <- function (url, exdir, files) {
  
  temp <- tempfile()
  download.file(url, temp)
  unzip(temp, exdir = exdir, junkpaths = TRUE, files = files)
  
}



expand_HCPCS_range <- function (code_range) {
  
  #code_range = '00918-00924'
  
  r <- str_split_fixed(code_range, "-", n = 2)
  
  if (!grepl("[[:alpha:]]", r[1]) & !grepl("[[:alpha:]]", r[2]))
  {
    str_pad(as.character(seq(r[1], r[2], 1)), 5, pad="0")
  } else if (r[1] == r[2]) {
    r[1]
  } else if (grepl("[[:alpha:]]", substr(code_range, 5,5))) {
    
    paste0(str_pad(as.character(seq(substr(r[1], 1, 4), substr(r[2], 1, 4), 1)), 4, pad="0"), substr(r[1], 5, 5))
    
  } else {
    NA
  }
  
}