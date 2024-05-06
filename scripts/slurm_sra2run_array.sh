#!/bin/bash
#SBATCH --job-name=sra2run
#SBATCH --output=sra2run_%A_%a.log
#SBATCH --error=sra2run_%A_%a.err
#SBATCH --nodes=1 
#SBATCH --ntasks=1 
#SBATCH --array=[YOUR_ARRAY_INDEX]
#SBATCH --cpus-per-task 1
#SBATCH --mem-per-cpu=2560
#SBATCH --time=6:00:00
#SBATCH --account=[YOUR_ACCOUNT]

module load EDirect/20.4.20230912-GCCcore-10.2.0

FILENAME=$(sed -n ${SLURM_ARRAY_TASK_ID}p filename2.list)
FILECOMMAND=$(sed -n ${SLURM_ARRAY_TASK_ID}p filecommand2.list)
FILEBATCH=$(sed -n ${SLURM_ARRAY_TASK_ID}p filebatch2.list)

echo $FILENAME
echo $FILECOMMAND
echo $FILEBATCH

mkdir -p ./sra2runtabs

# command actual
for acc in `sed -n ${FILECOMMAND} ${FILENAME}`; do \
esearch -db sra -query "${acc} [Accession]" | efetch -format docsum | xtract -pattern DocumentSummary \
-SRA "(NA)" \
-block ExpXml -element Sample@acc \
-RUN "(NA)" \
-block Runs -element Run@acc \ > ./sra2runtabs/sra-$acc.tab; done
