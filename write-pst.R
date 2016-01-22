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
## combine blocks
df.obs.block <- do.call(rbind, mget(chr.df.names))


## get number of obs
lng.n.obs <- length(df.obs.block$line)

## set number of observations
chr.ln <- str.control[4]

# substitute the new number of observations
chr.ln.new <- gsub("[0-9]{4,}",as.character(lng.n.obs), chr.ln)







system.time(write.table(junk$line, file = "junk.txt", row.names = FALSE, col.names = FALSE,
            quote = FALSE)
)


