setwd("m:/models/bacteria/hspf/HydroCal201506/R_Projs/construct_control")

load(file="obs-blocks.RData")

load("uci-control.RData")


head(str.control, 25)

## get number of observation groups
junk <- rbind(ls(patter = "^df\\..*"))

dfs <- Filter(function(x) is(x, "data.frame"), mget(ls()))

junk <- do.call(rbind,mget(ls(patter = "^df\\..*")))
