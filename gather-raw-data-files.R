# gather the raw observed data in one place for use in the construction of the
# PEST control file. Some of the raw data will be processed in other R-projects
# but I will keep a copy of the raw data used in this repo to increase 
# transparency
# created Kevin Brannan 2015-12-08

# simulation period determined from updated meteo data. The files are in a 
# zipfile. The HSPF UCI file for the extended simulation period is extracted 
# from the zipfile and the begin and end dates of the simulation are taken from
# this UCI file
# zipfile path and name
tmp.dir <- "M:/Models/Bacteria/HSPF/TetraTech20150211 WDM file extension/"
tmp.zip <- "HSPF&WDMfiles.zip"

# get list of files in the zipfile
tmp.fns <- unzip(zipfile = paste0(tmp.dir,tmp.zip), list = TRUE)

# read the uci file for the extended simulation period in as a character vector
tmp.uci <- scan(unz(paste0(tmp.dir,tmp.zip),
                    grep("*.extend.*\\.uci$", tmp.fns[ , 1], value=TRUE)
                    )
                , sep = "\n", what = character()
                )

# get the line in the UCI that has the begin and end dates of the simulation
tmp.str <- grep("START", tmp.uci, value=TRUE)

# get begin date
dt.sim.bg <- as.POSIXct(
  gsub("/","-",
       gsub("((\\s{1,})|([aA-zZ]))", "",
            gsub("( ){,1}00:00.*END.*$","",tmp.str))))

# get end date
dt.sim.ed <- as.POSIXct(
  gsub("/","-",
       gsub("((\\s{1,})|(24:00))","",
            gsub(".*END","",tmp.str))))

# clean up
rm(list=ls(pattern = "^tmp\\..*"))


# obs flow data