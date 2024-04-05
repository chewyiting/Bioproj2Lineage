#!/bin/bash
#SBATCH --job-name=batching
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=1G
#SBATCH --time=0:10:00
#SBATCH --output=batching_%A.out
#SBATCH --error=batching_%A.err
#SBATCH --account=XXXXXXXXXXXXXXX

# options (modify!)
inputtsv='./data/PRJNA736718_sras.tsv'
script_batch='./scripts/batch_srasTsv.sh'
inputtsv_name='PRJNA736718'
batchsize=100

mkdir -p batchedtsvs
cd batchedtsvs
# script
${script_batch} -a ${inputtsv} -b ${inputtsv_name} -c ${batchsize}
