##########################################
# Libraries
##########################################
library(dplyr)
library(readr)
library(stringr)
##########################################
# Project-specific options
##########################################
args <- commandArgs(trailingOnly = TRUE)
print(paste0(c('Printing my ',length(args),' arguments'),collapse=""))
print(args)
indir= args[1] # ./data/tabs
outputname=args[2] # ./data/tabs/alltab_full_240331.tsv
setwd(indir)
mylist=args[3] # ./data/tabs/biosample-accs-full.list
metadatafiles <- read_delim(file=mylist,delim='\n',col_names=F)
metadatafiles <- metadatafiles$X1
print(length(metadatafiles))
df_colnames <- c("BioProject","BioSample","SRA","OrganismName","collection_date","geo_loc_name","seq_methods","host","host_body_product")
mycolNum <- length(df_colnames) - 1

##########################################
# Actual script
##########################################

df_out <- data.frame(matrix(data=NA,nrow=1,ncol=length(df_colnames)))
colnames(df_out) <- df_colnames

for(i in 1:length(metadatafiles)){
  df_i <- read_delim(metadatafiles[i], col_names=F,
                     col_types = cols(.default = "c"))
  bp_i <- unlist(strsplit(metadatafiles[i],"-"))[2]
  print(paste0(c('Processing ',bp_i,' now'),collapse=''))
  if(nrow(df_i)==0) next
  if(ncol(df_i)!=mycolNum) next # frail spot
  df_bp_i <- cbind("BioProject"=bp_i,df_i)
  colnames(df_bp_i) <- df_colnames
  df_out <- rbind(df_out,df_bp_i)
}
getwd()

df_out <- df_out[!is.na(df_out$BioProject),]
write_delim(df_out,file=outputname,delim='\t')
print(paste0(c('Finished writing ',outputname),collapse=""))
