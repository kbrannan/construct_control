## scratch file to create funtion that reads PLTGEN output file
## from the hydro cal uci file
## created 2015-12-24 by Kevin Brannan

## set path for the PLTGEN file
str.dir <- paste0(getwd(), "/ODEQ_hspf/extended period/")

## set name for the PLTGEN file
str.file <- "beflhyd.out"

## read in the PLTGEN file
str.pltgen <- scan(file = paste0(str.dir,str.file), sep = "\n", 
                   what = "character")

## get first line of data. the "-1.0000000E+30" is a flag for no data and 
## should only occur on the first day for a daily tiime step aggregation of
## hourly data. take min just incase
lng.str <- min(grep("^( ){1,}To.*-1.0000000E\\+30{1,}$", str.pltgen) + 1)

## get data only from orginal PLTGEN file
str.data <- str.pltgen[lng.str:length(str.pltgen)]


## get variable names from PLTGEN file
## get line where the variable name list starts
lng.name.str <- grep("^( ){1,}To( ){1,}Label( ){1,}LINTYP", 
                 str.pltgen[1:lng.str]) + 1

## get line where the variable name list ends
lng.name.end <- min(grep("^( ){1,}To$", str.pltgen[1:lng.str])) - 1

## get variable names
str.var.names <- do.call(rbind,
                         lapply(str.pltgen[lng.name.str:lng.name.end],
                                function(x){
                                  y <- gsub("( ){3,}.*","", 
                                            gsub("^( ){1,}To( ){1,}" , "", x))
                                  z <- gsub(" ", ".", y)
                                  return(z)
                                  }
                                )
                         )
