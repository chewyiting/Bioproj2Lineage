####################################
# Library town
####################################
library(jsonlite)
library(stringr)
library(readr)

####################################
# Arguments 
####################################
# From list of json files, convert into tsv ! 
args <- commandArgs(trailingOnly = TRUE)
setwd(args[1]) 
print("Echoing current working directory")
getwd()
outputname <- args[2] 
outputdir <- args[3] # 
####################################
# Data and directories
####################################
list_json <- list.files(pattern='*.json')
print("printing list_json")
print(list_json)

####################################
# Functions
####################################
json_i_1 <- unlist(read_json(list_json[1]))
for(j in 1:length(json_i_1)){
  print(json_i_1[j])
}
json2row <- function(json_i){
  vec_out <- vector(length=5)
  vec_out[1:2] <- unlist(str_split(json_i[1],pattern=';'))
  vec_out[3] <- json_i[2]
  vec_out[4:5] <- json_i[3:4]
  return(vec_out)
}

dummyrow <- json2row(json_i_1)
dummyrow
####################################
# Actual analysis
####################################
df_out <- data.frame(jsonfile=list_json, fastq_ftp_1=NA,fastq_ftp_2=NA, fastq_md5=NA,sample_accession=NA,run_accession=NA)
for(k in 1:length(list_json)){
  json_input <- unlist(read_json(list_json[k]))
  df_out[k,2:6] <- json2row(json_input)
}
df_out
print("Printing outputname")
print(outputname)
setwd(outputdir)
print("Printing output directory")
getwd()
write_delim(df_out, file=outputname,
            delim='\t',col_names=T,quote="none")