.libPaths("/hwfssz1/ST_EARTH/P18Z10200N0113/USER/pepiline/software/software2/local/bin/R/R-4.0.2/library")

setwd("./")
library(dplyr)
library(stringr)
library(ggplot2)

df<-read.table("hap1_hap2_merge.bed",header = F)
table(df$V1)
freq <- table(df$V1)
write.table(freq,file="chr_gene_num.txt",sep="\t",quote=F,row.names=F,col.names=F)

