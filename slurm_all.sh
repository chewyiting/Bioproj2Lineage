#!/bin/bash
#SBATCH --job-name=setup
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=4
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=1G
#SBATCH --time=0:10:00
#SBATCH --output=setup_%A.out
#SBATCH --error=setup_%A.err
#SBATCH --account=cohen_theodore

# options (modify!)
inputtsv='/home/yc954/project.cohen/sm_Bioproj2Lineage/dirTemplate/data/PRJNA736718_sras.tsv'
script_batch='/home/yc954/project.cohen/sm_Bioproj2Lineage/dirTemplate/scripts/batch_srasTsv.sh'
inputtsv_name='PRJNA736718'
batchsize=100

mkdir -p batchedtsvs
cd batchedtsvs
# script
${script_batch} -a ${inputtsv} -b ${inputtsv_name} -c ${batchsize}

