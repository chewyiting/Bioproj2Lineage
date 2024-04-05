####################################
# Library town
####################################
library(stringr)
library(readr)

####################################
# Arguments & Purpose
####################################
# From list of lineages.txt, convert into tsv ! 
args <- commandArgs(trailingOnly=TRUE)
inputdir <- args[1]
myinputTSV <- args[2]
outputdir <- args[3]
outputname <- args[4] 

####################################
# Data and directories
####################################
# Local analog
#setwd("~/Desktop/Yale/Rotations/Ted/data/fasta_summarise")
#list_txt <- list.files(pattern='*.lineages.txt')
#inputTSV <- read_delim('js_summarise_dummy.tsv')

# Remote analog
setwd(inputdir)
print("Echoing current working directory")
getwd()

list_txt <- list.files(pattern='*.lineages.txt')
inputTSV <- read_delim(myinputTSV)

####################################
# Actual analysis
####################################
runacc_i_i <- str_remove(list_txt[1],pattern='.lineages.txt')

outTSV_tail <- data.frame(run_accession=str_remove(list_txt,pattern='.lineages.txt'),
                          main_lin=NA,
                          sub_lin=NA)

for(i in 1:length(list_txt)){
  txt_i <- read_delim(list_txt[i],delim='\t',col_names=F)
  outTSV_tail$main_lin[i] <- txt_i[1,]
  outTSV_tail$sub_lin[i] <- txt_i[2,]
}

vec_match <- match(inputTSV$run_accession,outTSV_tail$run_accession)
main_lin <- unlist(outTSV_tail$main_lin[vec_match])
sub_lin <- unlist(outTSV_tail$sub_lin[vec_match])

outTSV <- cbind(inputTSV,main_lin,sub_lin)

setwd(outputdir)
print("Setting output directory to ...")
getwd()

write_delim(outTSV, file=outputname,
            delim='\t',col_names=T,quote="none")

print(paste0(c("Finished writing ",outputname),collapse=""))