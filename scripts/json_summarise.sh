#!/bin/bash

helpFunction()
{
   echo ""
   echo "Usage: $0 -a [input directory] -b [output directory] "
   echo -e "\t-a Input directory for all input files "
   echo -e "\t-b Output directory to write output files to"
   exit 1 # Exit script after printing help
}

while getopts "a:b:" opt
do
   case "$opt" in
      a ) indir="$OPTARG" ;;
      b ) outdir="$OPTARG" ;;
      ? ) helpFunction ;; # Print helpFunction in case parameter is non-existent
   esac
done

# Print helpFunction in case parameters are empty
if [ -z "$indir" ] || [ -z "$outdir" ] 
then
   echo "Some or all of the parameters are empty";
   helpFunction
fi

# Begin script in case all parameters are correct
echo "$indir"
echo "$outdir"

cd $indir
pwd

# Script begins here
for infile in `cat input_json.txt`; 
do
acc_fq=$(jq '.[] | .run_accession' ${infile} | tr -d '"')
echo $acc_fq; done