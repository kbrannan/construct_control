# gather the raw observed data in one place for use in the construction of the
# PEST control file. Some of the raw data will be processed in other R-projects
# but I will keep a copy of the raw data used in this repo to increase 
# transparency
# created Kevin Brannan 2015-12-08

# load packages
library(devtools)

# simulation period determined from updated meteo data. The files are in a 
# zipfile. The HSPF UCI file for the extended simulation period is extracted 
# from the zipfile and the begin and end dates of the simulation are taken from
# this UCI file
# zipfile path and name
tmp.dir <- "M:/Models/Bacteria/HSPF/TetraTech20150211 WDM file extension/"
tmp.zip <- "HSPF&WDMfiles.zip"

# get list of files in the zipfile
tmp.fns <- unzip(zipfile = paste0(tmp.dir,tmp.zip), list = TRUE)

# read the uci file as a character vector
str.uci <- scan(unz(paste0(tmp.dir,tmp.zip),
                    grep("*.extend.*\\.uci$", tmp.fns[ , 1], value=TRUE)
                    )
                , sep = "\n", what = character()
                )

# get the line in the UCI that has the begin and end dates of the simulation
tmp.str <- grep("START", str.uci, value=TRUE)

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


# flow data
# CANNOT get the ssh authentification to work
# use scripts from the Select_Storm_HydCal repo to get observed flow and estimate the
# flow for Big Elk Creek
# library(RCurl)
# 
# x <- scp(host = "www.github.com", 
#          path = "Select_Storm_HydCal/devel/get-obs-flow-data.R", 
#          user = "kbrannan",
#          key = "~/.ssh/id_rsa_Git_Bash"
#            )
# 
# x <- getURL("https://raw.github.com/kbrannan/Select_Storm_HydCal/master/devel/get-obs-flow-data.R")
# y <- read.csv(text = x)
# use the script from Select_Storm_HydCal on local server to get flow data

# get obs flow from Yaquina River gage
source(file = "//deqhq1/tmdl/TMDL_WR/MidCoast/Models/Bacteria/HSPF/HydroCal201506/R_projs/Select_Storm_HydCal/devel/get-obs-flow-data.R")

# estimate flow for Big Elk Creek from Yaquina River Gage
source(file = "//deqhq1/tmdl/TMDL_WR/MidCoast/Models/Bacteria/HSPF/HydroCal201506/R_projs/Select_Storm_HydCal/devel/estimate-flow.R")

# remove Yaquina data
rm(df.flow.obs)

# get flow data within the simulation period and simplify data.frame
df.flow <- df.flow.est[ df.flow.est$date >= dt.sim.bg &
                          df.flow.est$date <= dt.sim.ed, 
                        c("date", "mean_daily_flow_cfs")]
names(df.flow) <- c("date", "flow_cfs")

# remove Big Elk Creek original data.frame
rm(df.flow.est)
