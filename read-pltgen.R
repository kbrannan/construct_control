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

## get data in dtat frame
## fisrt get data as characters
df.data.chr <- data.frame(do.call(rbind,
                              strsplit(x = gsub("( ){1,}24( ){1,}0", " ",
                                                gsub("^( ){1,}To( ){1,}", "",
                                                     str.data))
                                       , split = "( ){1,}")),
                      stringsAsFactors = FALSE)
## rename variables in the data frame to names in PLTGEN file
names(df.data.chr) <- c("year", "month", "day", str.var.names)

## create data frame with date and numeric values
tmp.flows <- df.data.chr[, c(-1, -2, -3)]
for(ii in 1:length(tmp.flows[1, ])) {
  tmp.flows[ , ii] <- as.numeric(tmp.flows[ , ii])
}
tmp.date <- as.POSIXct(apply(df.data.chr[, 1:3], 
                           1, function(x) paste0(x, collapse = "-"))), 
                           transform(df.data.chr[, c(-1, -2, -3)], as.numeric)
                 )

junk <- as.numeric(df.data.chr[ , str.var.names[5]])
str(junk)
