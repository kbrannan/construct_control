# gather the raw observed data in one place for use in the construction of the
# PEST control file. Some of the raw data will be processed in other R-projects
# but I will keep a copy of the raw data used in this repo to increase 
# transparency
# created Kevin Brannan 2015-12-08

# meteo data

# simulation period determined from updated meteo data
tmp.dir <- "M:/Models/Bacteria/HSPF/TetraTech20150211 WDM file extension/"
tmp.zip <- "HSPF&WDMfiles.zip"
tmp.fns <- unzip(zipfile = paste0(tmp.dir,tmp.zip), list = TRUE)
## gsub(".*/","", grep("*.extend.*\\.uci$", tmp.fns[ , 1], value=TRUE))
tmp.uci <- scan(unz(paste0(tmp.dir,tmp.zip),
                    grep("*.extend.*\\.uci$", tmp.fns[ , 1], value=TRUE)
                    )
                , sep = "\n", what = character()
                )
grep("START",tmp.uci, value=TRUE)


list2env(setNames(lapply(fns, read.csv, row.names = 1), basename(tools::file_path_sans_ext(fns))), globalenv())

dt.sim.bg <- as.POSIXct("1995-10-01")
dt.sim.ed <- as.POSIXct("2014-05-30")

# obs flow data