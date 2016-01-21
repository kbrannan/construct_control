## set path
chr.dir <- "m:/models/bacteria/hspf/HydroCal201506/R_Projs/construct_control"

## load the observed data processed by "gather-raw-data-files.R"
load(file=paste0(chr.dir,"/","obs-blocks.RData"))

## load uci and PEST-control files processed by "gather-raw-data-files.R"
load(file = paste0(chr.dir, "/", "uci-control.RData"))


head(str.control, 25)

## get number of observation groups
junk <- rbind(ls(patter = "^df\\..*"))

dfs <- Filter(function(x) is(x, "data.frame"), mget(ls()))

junk <- do.call(rbind,mget(ls(patter = "^df\\..*")))

lil_junk <- junk[sample(nrow(junk),size = 100, replace = TRUE),1]

gsub("^.*")
