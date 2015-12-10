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
# library(devtools)
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

# get PEST control file

# zipfile path and name
tmp.dir <- "//deqhq1/tmdl/TMDL_WR/MidCoast/Models/Bacteria/HSPF/Hydro Calibration/Files from Cadmus"
tmp.zip <- "Final_Deliverables_EPA_July2012.zip"

# get list of files in the zipfile
tmp.fns <- unzip(zipfile = paste0(tmp.dir,"/", tmp.zip), list = TRUE)

# see how many occurances there are of the control file in the zipfile
grep("control.pst", tmp.fns$Name, value = TRUE)

# only one, I'll use it
tmp.file <- "Final_Deliverables_EPA_July2012/PEST_end/control.pst"

# read the PEST control file as a character vector
str.control <- scan(unz(paste0(tmp.dir,"/", tmp.zip),
                        tmp.file
                        )
, sep = "\n", what = character()
)

# get observational groups names

# get rows where the block names are
tmp.blk.hd <- grep("\\*", str.control)
str.obs.grp.names <- 
  str.control[(tmp.blk.hd[grep("[Oo]bs.*[Gg]roups", 
                               str.control[tmp.blk.hd])] + 1):
              (tmp.blk.hd[grep("[Oo]bs.*[Gg]roups", 
                              str.control[tmp.blk.hd]) + 1] - 1)]

# clean up
rm(list = ls(pattern = "^tmp\\..*"))

# create vector strings of output for each observation group

# mlog - log10 of daily flow in cfs. addedd 0.0001 cfs in case there are 0 flows

# get flow data and apply log10 transform
tmp.data <- log10(df.flow$flow_cfs + 0.0001)

# get the prefix for the observation in the group, which is the group name
tmp.grp <- str.obs.grp.names[1]

# get first occrence of observation in group to see format
grep(paste0(tmp.grp,".*"), str.control, value = TRUE)[2]

# format of line
# "mlog_1                 1.797268        5.564000E-02  mlog"
tmp.num <- 1:length(tmp.data)

sprintf(fmt = "%04i", 1)

paste0(tmp.grp, "_", 
sprintf(fmt = paste0("%", paste0("0",nchar(length(tmp.data))),"i"), tmp.num[1]),
"              ",
sprintf(fmt = "%1.5E", tmp.data[1]),
"     1.000000E+00  ",
tmp.grp)

