#!/bin/bash
#SBATCH --job-name=acc2prof
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=4
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=1G
#SBATCH --time=0:10:00
#SBATCH --output=acc2prof_%A.out
#SBATCH --error=acc2prof_%A.err
#SBATCH --account=XXXXX

# options
mybasedir='/path/to/sm_Bioproj2Lineage/PRJNA736718/batch01/'
myinputdir='sample_info'
myoutputdir='json_summarise'
myoutputname='js_summarise_dummy.tsv'

# commands
module purge
module load miniconda/23.5.2
conda activate snakemake
conda activate bioinfo
snakemake --cores all 
mkdir -p json_summarise 

Rscript ./scripts/json2tsv.R ${mybasedir}${myinputdir} ${myoutputname} ${mybasedir}${myoutputdir}

