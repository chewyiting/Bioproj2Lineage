#!/bin/bash

helpFunction()
{
   echo ""
   echo "Usage: $0 -a [query run accession] -b [input tsv file] -c [output directory to write fastq.gz files to]"
   echo -e "\t-a Query run accession (i.e. SRR14782120) "
   echo -e "\t-b Input TSV file linking ftp links to run accession"
   echo -e "\t-c Output directory"
   exit 1 # Exit script after printing help
}

while getopts "a:b:c:" opt
do
   case "$opt" in
      a ) runacc="$OPTARG" ;;
      b ) inputtsv="$OPTARG" ;;
      c ) outputdir="$OPTARG" ;;
      ? ) helpFunction ;; # Print helpFunction in case parameter is non-existent
   esac
done

# Print helpFunction in case parameters are empty
if [ -z "$runacc" ] || [ -z "$inputtsv" ] || [ -z "$outputdir" ] 
then
   echo "Some or all of the parameters are empty";
   helpFunction
fi

# Begin script in case all parameters are correct
echo "$runacc"
echo "$inputtsv"
echo "$outputdir"

cd $outputdir

# Script begins here
# get ftp links 
link_1=$(grep -n ${runacc} ${inputtsv} | cut -f 2)
link_2=$(grep -n ${runacc} ${inputtsv} | cut -f 3)

# Download raw reads
wget -nc -nv ftp://${link_1} 
wget -nc -nv ftp://${link_2} 
