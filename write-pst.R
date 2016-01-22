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


system.time(write.table(junk$line, file = "junk.txt", row.names = FALSE, col.names = FALSE,
            quote = FALSE)
)

get.row <- function(x) eval(parse(text=paste0(x,"$line[1]")))

cat(do.call(rbind,lapply(chr.df.names, get.row)),file = "get_row.txt",sep = "\n")


junk <- mget(chr.df.names)

junk$df.mtime
junk$df.mbaseind
junk$df.mvol_ann

junk <- rbind(junk$df.mtime, junk$df.mbaseind)

junk.m <- as.matrix(junk$line)

junk.v <- as.vector(junk$line)


str(mget(chr.df.names[3]))

system.time(write.table(junk$line, file = "junk.txt"))

system.time(write(junk$line, file = "junk.txt"))

system.time(write(junk.m, file = "junk_m.txt"))

system.time(write(junk.v, file = "junk_v.txt"))

system.time(cat(junk$line, file = "junk.txt", sep="\n"))

str(junk)
names(junk)


cat(junk$line, file = "junk.txt", sep="\n")

tail(junk, 100)

## get number of observation groups
junk <- rbind(ls(pattern = "^df\\..*"))

