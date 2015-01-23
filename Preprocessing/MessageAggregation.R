
####################################################

##--    Aggregate Messages, Write Out as TXT    --##

## 1 conversation per txt file, 1 month per folder
## naming: convo_id_actor_id_type.txt
## folder naming: mmyy
## conversation that expends 2 months will be count in the first month
## conversation that has more than one counselors will belong to the first counselor

####################################################

rm(list=ls())

## set working directory
setwd("C:/School/Thesis")


## load & inspect data
load("./data/ms_rated_cleaned.Rda")
#names(ms)
#range(ms$m_time)
#ms <- ms [1:5000, ]


## create mmyy variable from m_time for folder naming
require(gdata)
require(stringr)
ms$month <- getMonth(ms$m_time)
ms$year <- getYear(ms$m_time)
ms$mmyy <- paste(ms$month,str_sub(ms$year,3,4), sep = "", collapse = NULL)


## aggregate messages based on convo_id and type of actor
require(plyr)

## for split analysis
pastems <- function(data){
  ms <- paste(data$message, sep = " ",collapse = "\n")
  n.char <- nchar(ms)
  n.ms <- length(data$message)
  mmyy <- unique(data$mmyy)[1]
  conv_id <- unique(data$conv_id)
  actor_id <- unique(data$actor_id)[1]
  type <- unique(data$type)
  filename <- paste(conv_id, actor_id, type, sep = "_")
  data.agg <- c(mmyy, filename, actor_id, type, n.ms, n.char, ms)
  return(data.agg)
}

convo.texter <- ddply(ms[ms$type == "texter", ],.(conv_id), pastems)
colnames(convo.texter) <- c("conv_id", "foldername", "filename", "actor_id", "type", "nms.texter", "nchar.texter", "ms")

convo.counselor <- ddply(ms[ms$type == "counselor", ],.(conv_id), pastems)
colnames(convo.counselor) <- c("conv_id", "foldername", "filename", "actor_id", "type", "nms.counselor", "nchar.counselor", "ms")


## merge texter and counselor to create convo_lan_meta.Rda
texter_lan_meta <- convo.texter[ , c("conv_id", "actor_id", "type", "nms.texter", "nchar.texter")]
counselor_lan_meta <- convo.counselor[, c("conv_id", "actor_id", "type", "nms.counselor", "nchar.counselor")]

convo_lan_meta <- merge(x = counselor_lan_meta, y = texter_lan_meta, by.x = "conv_id", by.y = "conv_id")
convo_lan_meta$nms.counselor <- as.numeric(convo_lan_meta$nms.counselor)
convo_lan_meta$nms.texter <- as.numeric(convo_lan_meta$nms.texter)
convo_lan_meta$nms.all <- as.numeric(convo_lan_meta$nms.counselor) + as.numeric(convo_lan_meta$nms.texter)
convo_lan_meta$tcratio <- convo_lan_meta$nms.texter/ convo_lan_meta$nms.counselor

names(convo_lan_meta)

convo_lan_meta <- convo_lan_meta[, c(1,2,4,5,6,8,9,10,11)]
colnames(convo_lan_meta) <- c("conv_id", "counselor_id", "nms.counselor",
                              "nchar.counselor", "texter_id", "nms.texter", "nchar.texter",
                              "nms.all", "nms.tcratio")
save(convo_lan_meta, file = "./data/convo_lan_meta.Rda")


## output conversation as txt 
convo.texter_mmyysplit <- dlply(convo.texter, .(foldername))

for (i in 1:length(convo.texter_mmyysplit)){
  folder = paste("./data/LIWC/texter/", unique(convo.texter_mmyysplit[[i]]$foldername), "/", sep = "")
  dir.create(folder, showWarnings = FALSE)
  for (j in 1: nrow(convo.texter_mmyysplit[[i]])){
    write.table(convo.texter_mmyysplit[[i]][j,'ms'],
                file = paste(folder,convo.texter_mmyysplit[[i]][j,'filename'], ".txt", sep = ""))
  }
}

convo.counselor_mmyysplit <- dlply(convo.counselor, .(foldername))

for (i in 1:length(convo.counselor_mmyysplit)){
  folder = paste("./data/LIWC/counselor/", unique(convo.counselor_mmyysplit[[i]]$foldername), "/", sep = "")
  dir.create(folder, showWarnings = FALSE)
  for (j in 1: nrow(convo.counselor_mmyysplit[[i]])){
    write.table(convo.counselor_mmyysplit[[i]][j,'ms'],
                file = paste(folder,convo.counselor_mmyysplit[[i]][j,'filename'], ".txt", sep = ""))
  }
}












