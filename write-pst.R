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

grep("mbaseind_", str.control, value = TRUE)

grep("mbaseind_", df.obs.block$line, value = TRUE)

## insert new block of observations into the control
lng.obs.st <- grep("\\* observation data" ,str.control)
lng.obs.ed <- lng.obs.st + min(grep("\\* " , 
                       str.control[(lng.obs.st + 1):length(str.control)]))
str.control.new <- c(str.control[1:lng.obs.st], 
                          paste0(df.obs.block[ ,1]),
                          str.control[lng.obs.ed:length(str.control)])

## update the number of observation in control
## get number of obs
lng.n.obs <- length(df.obs.block$line)

## set number of observations
chr.ln <- str.control.new[4]

# substitute the new number of observations
chr.ln.new <- gsub("[0-9]{4,}",as.character(lng.n.obs), chr.ln)

## put new line in control file
str.control.new[4] <- chr.ln.new

## write updated control file
write.table(str.control.new, file = paste0(chr.dir,"/new.pst"), 
            row.names = FALSE, col.names = FALSE, quote = FALSE)
