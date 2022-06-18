.libPaths("/hwfssz1/ST_EARTH/P18Z10200N0113/USER/pepiline/software/software2/local/bin/R/R-4.0.2/library")

setwd("./")
library(dplyr)
library(stringr)
library(ggplot2)

df<-read.table("tmp1.txt",header = F)
table(df$V1)
freq1 <- table(df$V1)
freq2<- table(df$V2)
write.table(freq1,file="chr_HOM1gene_num.txt",sep="\t",quote=F,row.names=F,col.names=F)
write.table(freq2,file="chr_HOM2gene_num.txt",sep="\t",quote=F,row.names=F,col.names=F)


