#!/bin/bash

helpFunction()
{
   echo ""
   echo "Usage: $0 -a [input SRAS tsv] -b [bioproject name] -c [batch size]"
   echo -e "\t-a Input SRAS.tsv"
   echo -e "\t-b Bioproject name"
   echo -e "\t-c Number of accessions per batch"
   exit 1 # Exit script after printing help
}

while getopts "a:b:c:" opt
do
   case "$opt" in
      a ) inputtsv="$OPTARG" ;;
      b ) myname="$OPTARG" ;;
      c ) batchsize="$OPTARG" ;;
      ? ) helpFunction ;; # Print helpFunction in case parameter is non-existent
   esac
done

# Print helpFunction in case parameters are empty
if [ -z "$inputtsv" ] || [ -z "$myname" ] || [ -z "$batchsize" ] 
then
   echo "Some or all of the parameters are empty";
   helpFunction
fi

# Begin script in case all parameters are correct
echo "Parameters used are:"
echo "$inputtsv"
echo "$myname"
echo "$batchsize"

pwd
##############################
# Script begins here
##############################
# inputtsv='/home/yc954/project.cohen/sm_Bioproj2Lineage/PRJNA736718/PRJNA736718_sras.tsv'
# myname='PRJNA736718'
# batchsize='100'

n_lines=$(wc -l ${inputtsv} | awk '{print $1}')
n_files=$((($n_lines / $batchsize) + ($n_lines % $batchsize > 0)))

echo "SRA" > commonHeader.txt

for i in `seq 1 $n_files`
do 
   touch ${myname}_batch${i}_sras.tsv
   eval f_start=$((((${i} -1) * 100) + 2 ))
   eval f_stop=$(((${i} * 100) + 1 ))
   sed -n ${f_start},${f_stop}p ${inputtsv} > ${myname}_batch${i}_sras_tmp.tsv
   cat commonHeader.txt ${myname}_batch${i}_sras_tmp.tsv >> ${myname}_batch${i}_sras.tsv
done

rm *tmp.tsv