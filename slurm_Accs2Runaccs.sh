#!/bin/bash
#SBATCH --job-name=Accs2Runaccs
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=1G
#SBATCH --time=0:10:00
#SBATCH --output=Accs2Runaccs_%A.out
#SBATCH --error=Accs2Runaccs_%A.err
#SBATCH --account=cohen_theodore

###########################
# options
###########################
dirtemplate='/home/yc954/project.cohen/sm_Bioproj2Lineage/dirTemplate/'
bioproj='PRJNA736718'
batchno=23

# config parameters for Snakefile (sm_Accs2Runaccs)
sras=$(echo '/home/yc954/project.cohen/sm_Bioproj2Lineage/dirTemplate/batchedtsvs/'${bioproj}'_batch'${batchno}'_sras.tsv')
reference='/home/yc954/project.cohen/sm_Bioproj2Lineage/dirTemplate/reference/NC_000962_3.fa'
wanted_lineage='lineage4.2'
basedir=$(pwd)
dirscript='/home/yc954/project.cohen/sm_Bioproj2Lineage/dirTemplate/scripts/'

# other parameters
myinputdir='sample_info'
myoutputdir='json_summarise'
myoutputname='js_summarise_dummy.tsv'

###########################
# script
###########################
# 1. prepare sm_Accs2Runaccs
mkdir -p sm_Accs2Runaccs
cp -n ${dirtemplate}sm_Accs2Runaccs/Snakefile ./sm_Accs2Runaccs

module purge
module load miniconda/23.5.2
conda activate snakemake
conda activate bioinfo
cd ./sm_Accs2Runaccs
snakemake --cores all --config sras=${sras} reference=${reference} wanted_lineage=${wanted_lineage} basedir=${basedir}/sm_Accs2Runaccs/ dirscript=${dirscript}