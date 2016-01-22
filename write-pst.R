## set path
chr.dir <- "m:/models/bacteria/hspf/HydroCal201506/R_Projs/construct_control"

## load the observed data processed by "gather-raw-data-files.R"
load(file=paste0(chr.dir,"/","obs-blocks.RData"))

## load uci and PEST-control files processed by "gather-raw-data-files.R"
load(file = paste0(chr.dir, "/", "uci-control.RData"))

## combine the dfs to form the block of obs 
lng.og <- grep("\\* observation groups", str.control) + 1
lng.og.e <- lng.og + grep("\\*", str.control[lng.og:length(str.control)])[1] - 2
chr.df.names <- paste0("df.",str.control[lng.og:lng.og.e])

junk <- do.call(rbind, mget(chr.df.names))

junk <- mget(chr.df.names)

junk$df.mtime
junk$df.mbaseind
junk$df.mvol_ann

junk <- rbind(junk$df.mtime, junk$df.mbaseind)




str(mget(chr.df.names[3]))

write(junk$line, file = "junk.txt")

str(junk)
names(junk)


cat(junk, file = "junk.txt", sep="\n")

tail(junk, 100)

## get number of observation groups
junk <- rbind(ls(pattern = "^df\\..*"))

