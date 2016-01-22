## set path
chr.dir <- "m:/models/bacteria/hspf/HydroCal201506/R_Projs/construct_control"

## load the observed data processed by "gather-raw-data-files.R"
load(file=paste0(chr.dir,"/","obs-blocks.RData"))

## load uci and PEST-control files processed by "gather-raw-data-files.R"
load(file = paste0(chr.dir, "/", "uci-control.RData"))

## combine the dfs to form the block of obs 
lng.og <- grep("\\* observation groups", str.control) + 1
lng.og.e <- lng.og + grep("\\*", str.control[lng.og:length(str.control)])[1] - 2

paste0("df.",str.control[lng.og:lng.og.e])

## get number of observation groups
junk <- rbind(ls(pattern = "^df\\..*"))

