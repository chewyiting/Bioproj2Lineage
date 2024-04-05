################################
# Overview
################################
# A reproducible example in dirTemplate
# Goal: dirTemplate is the 'main' thing we copy from to populate batch02.
# no new files are created in dirTemplate
# pretend we are in batch02 directory now. 
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

################################################
# Ignore
################################################
# setup all conda environments


# setup snakemake, part 1
# info
# 	current working directory = /home/yc954/project.cohen/sm_Bioproj2Lineage/PRJNA736718/batch01
# steps
# 1. setup directory structure, input files
bioproj='PRJNA736718'
sm_01_base='/home/yc954/project.cohen/sm_Accs2Runaccs/'
cp ${sm_01_base}Snakefile .
mkdir config
cp ${sm_01_base}config/config.yaml ./config
cp ${sm_01_base}slurm_acc2profile.sh .
mkdir scripts
cp ${sm_01_base}scripts/ftp_fetch.sh ./scripts
cp ${sm_01_base}scripts/json2tsv.R ./scripts
head -n 1 ../${bioproj}_sras.tsv > tmp_head
sed -n 2,101p ../${bioproj}_sras.tsv > tmp_tail
2,101       # batch 1: (${i}-1)*100 + 2
202,301p    # batch 2: (${i}-1)*100 + 2
f_start=$(expr (${i}-1)*100 + 2)
f_stop=
cat tmp_tail >> tmp_head 
rm tmp_tail
mkdir data
mv tmp_head ./data/${bioproj}_batch01_sras.txt

#modify config/config.yaml to specify sras: "data/${bioproj}_batch01_sras.txt"
#modify Snakefile to specify mybasedir='/home/yc954/project.cohen/sm_Bioproj2Lineage/PRJNA736718/batch01'
#modify slurm script to specify options
sbatch slurm_acc2profile.sh

# 2. Get RunAccs2Fasta 
mycwd='/home/yc954/project.cohen/sm_Bioproj2Lineage/PRJNA736718/batch01/sm_Accs2Fasta'
cd $mycwd
sm_02_base='/home/yc954/project.cohen/sm_Runacc2Fasta'


mkdir scripts
cp ${sm_02_base}/scripts/summarise_lineage.R ./scripts

mkdir config
cp ${sm_02_base}/Snakefile .
cp ${sm_02_base}/config/config.yaml ./config
cp ${sm_02_base}/slurm_run2fasta.sh .

# modify Snakefile options
#   mybasedir='/home/yc954/project.cohen/sm_Bioproj2Lineage/PRJNA736718/batch01/sm_Accs2Fasta/'
# modify slurm_run2fasta.sh options
#   mybasedir=${mycwd}
#   inputTSV='/home/yc954/project.cohen/sm_Bioproj2Lineage/PRJNA736718/batch01/json_summarise/js_summarise_dummy.tsv'
# modify config/config.yaml
#   alljson:"/home/yc954/project.cohen/sm_Bioproj2Lineage/PRJNA736718/batch01/json_summarise/js_summarise_dummy.tsv"

sbatch slurm_run2fasta.sh
