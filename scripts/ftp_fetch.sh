#!/bin/bash

helpFunction()
{
   echo ""
   echo "Usage: $0 -a [query SRA accession] -b [output directory] "
   echo -e "\t-a Query SRA accession (i.e. SRR14782120) "
   echo -e "\t-b Output directory to write output files to"
   exit 1 # Exit script after printing help
}

while getopts "a:b:c:" opt
do
   case "$opt" in
      a ) sracc="$OPTARG" ;;
      b ) outdir="$OPTARG" ;;
      ? ) helpFunction ;; # Print helpFunction in case parameter is non-existent
   esac
done

# Print helpFunction in case parameters are empty
if [ -z "$sracc" ] || [ -z "$outdir" ] 
then
   echo "Some or all of the parameters are empty";
   helpFunction
fi

# Begin script in case all parameters are correct
echo "$sracc"
echo "$outdir"

# Building URL
base_url='https://www.ebi.ac.uk/ena/portal/api/'
my_api=$(echo ${base_url}search?result=read_run\&includeAccessions=${sracc}\&fields=fastq_ftp%2Cfastq_md5%2Csample_accession\&format=json)
curl --silent ${my_api} > ${outdir}${sracc}.json

# Slicing JSON
jq '.[] | .fastq_ftp' ${outdir}${sracc}.json > ${outdir}ftp_urls_${sracc}.txt



