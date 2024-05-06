##########################################
# Libraries
##########################################
library(dplyr)
library(readr)
library(xml2)
library(magrittr)
library(tidyr)
library(lubridate)
library(stringr)

############################
# Project-specific parameters
############################
# You should only need to modify parameters within this chunk! Inspect the chunks below for all you want.

dirData <- '/path/to/your/xmlfile/' # xml file in this example: q03_bioproject_result.xml
your_xml <- 'q03_bioproject_result.xml'
your_outputlist <- 'bioproject-id-q03.list'


############################
# Functions
############################

path_to_vec <- function(path,my_read_xml){ 
  vec_out <- my_read_xml %>%
    xml_find_first(path)%>%
    xml_text()
  return(vec_out)
}

get_xml2df_attr <- function(allPaths,my_read_xml,parentnode){
  str_parent <- paste0('.//',parentnode,collapse="")
  entries <- xml_find_all(my_read_xml,str_parent)
  df_out = data.frame(matrix(NA, ncol=length(allPaths), nrow=length(entries)))
  colnames(df_out) <- names(allPaths)
  for(i in 1:length(allPaths)){
    i_path <- allPaths[i]
    #i_attr <- str_extract(i_path, "(?<=\\[)[^]]+")
    i_attr <- str_split(i_path, pattern="@attrid=",simplify=T)[2]
    if(is.na(i_attr)){
      df_out[,i] <- path_to_vec(i_path,entries)
    } else {
      i_path <- str_split(i_path, pattern="@attrid=",simplify=T)[1]
      df_out[,i] <- xml_find_first(entries,i_path)%>%xml_attr(.,i_attr)
    }
  }
  return(df_out)
}


##########################################
# Metadata: From NCBI Query to List of SRA Accessions
##########################################
# Database: https://www.ncbi.nlm.nih.gov/bioproject/
# Query: ("Mycobacterium tuberculosis"[Organism]) AND ("Primary submission"[Filter] AND "bioproject sra"[Filter])
# Query Date: 1-Apr-24
# Results: 3375
# Download results as File > XML > save as: q03_bioproject_result.xml
# Before running script: manually amend XML file by appending start and end of file with <DocumentSummarySet> and </DocumentSummarySet>, otherwise, read_xml() will throw an error!
setwd(dirData)
biopro_xml <- read_xml(yourxml) 

# Inspect XML structure
entries<-biopro_xml %>%
  xml_find_all(".//DocumentSummary") # we are interested in this parent node
length(entries) # should match number of results from database
# xml_structure(entries[[1]]) # visualise XML structure for first entry

# Let's compile project title, description, name into the same column : makes for easier parsing of metadata for keywords
# This column is called 'projsum', created in df_biopro_projsum
biopro_paths <- c(bioproject="./Project/ProjectID/ArchiveID@attrid=accession",
                  archive="./Project/ProjectID/ArchiveID@attrid=archive",
                  proj_name="./Project/ProjectDescr/Name",
                  proj_title="./Project/ProjectDescr/Title",
                  proj_desc="./Project/ProjectDescr/Description",
                  loctagpre="./Project/ProjectDescr/LocusTagPrefix@attrid=biosample_id")

df_biopro <- get_xml2df_attr(biopro_paths,biopro_xml,'DocumentSummary')

# summarise 
df_biopro_projsum <- df_biopro %>%
  mutate(projsum=tolower(paste(proj_name,proj_title,proj_desc,sep="|")))%>%
  select(-c(proj_name,proj_title,proj_desc))

# write out list of bioproject accession ids
write_delim(as.data.frame(df_biopro_projsum$bioproject),col_names=F,eol='\n',
            file=your_outputlist)