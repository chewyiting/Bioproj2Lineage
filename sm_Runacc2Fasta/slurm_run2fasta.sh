#!/bin/bash
#SBATCH --job-name=run2fasta
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=4
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=1G
#SBATCH --time=0:30:00
#SBATCH --output=run2fasta_%A.out
#SBATCH --error=run2fasta_%A.err
#SBATCH --account=XXXXXX

# options
mybasedir='/path/to/sm_Runacc2Fasta/'
inputTSV='/path/to/sm_Accs2Runaccs/json_summarise/js_summarise_dummy.tsv'
outputdir='fasta_summary'
myoutput='fasta_summary_dummy.tsv'

# commands
module purge
module load miniconda/23.5.2
conda activate snakemake
module load BWA SAMtools
mkdir -p ./results # for tb-profiler
snakemake --cores all

conda activate bioinfo
mkdir -p ./fasta_summary # for summarise_lineage.R
Rscript ./scripts/summarise_lineage.R ${mybasedir}plots ${inputTSV} ${mybasedir}${outputdir} ${myoutput}
