################################
# Overview
################################
# Given 'PRJNA736718_sras.tsv'
# Which contains 2236 accessions
# We process this into batches of 100
# modify slurm_all.sh to specify options
sbatch slurm_all.sh 

#################################
# Initial set-up (run just once)
#################################
# conda environments
conda create --name bioinfo --file spec-file-bioinfo.txt
conda create --name snakemake --file spec-file-snakemake.txt
conda create --name tbprofiler --file spec-file-tbprofiler.txt

# tb-profiler set-up
conda activate tbprofiler
tb-profiler update_tbdb --match_ref /home/yc954/project.cohen/sm_Bioproj2Lineage/dirTemplate/reference/NC_000962_3.fa

#################################
# Reproducible example
#################################
# Step 1: Batching
# The following slurm submission script was designed for PRJNA736718_sras.tsv
# Run just once to batch this initial tsv file into a series of smaller tsv files
sbatch slurm_all.sh 
# Inspect the series of smaller tsv files, there should be 23 in total.
ll batchedtsvs/* | wc -l 

# Step 2: For a given batch of a certain BioProject, use sm_Accs2Runaccs to retrieve run accessions from SRA accessions
mkdir -p ../PRJNA736718/batch22
cd ../PRJNA736718/batch22
cp ../../dirTemplate/slurm*Runacc* .
