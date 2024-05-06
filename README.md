## Bioproj2Lineage
This directory contains two sequential Snakemake workflows for performing lineage calling on Mtb genomes (TB Profiler) from publicly available sequences hosted on NCBI. 
* [NCBI Bioproject](https://www.ncbi.nlm.nih.gov)

## Installation
### Conda environments
```bash
conda create --name snakemake --file ./myenvs/spec-file-snakemake.txt
conda create --name tbprofiler --file ./myenvs/spec-file-tbprofiler.txt
conda create --name bioinfo --file ./myenvs/spec-file-bioinfo.txt
```

### Setting up TB-Profiler
Setting up TB-Profiler to process existing .bam files, by specifying our reference genome to which our raw reads will be aligned to. 

Create and activate a conda environment named 'tbprofiler', then install [TB Profiler](https://github.com/jodyphelan/TBProfiler).

```bash
conda create --name tbprofiler
conda activate tbprofiler
conda install -c bioconda tb-profiler
tb-profiler update_tbdb --match_ref ./reference/NC_000962_3.fa
```

## Usage
### Reproducible example
To illustrate, we will analyse the list of SRA accessions corresponding to BioProject PRJNA736718.

#### Step 1: Batching
The following slurm submission script was designed for ./data/PRJNA736718_sras.tsv
Run just once to batch this initial tsv file into a series of smaller tsv files, each with the header 'SRA' followed by 100 SRA accessions.

```bash
sbatch slurm_batching.sh
```

Inspect the series of smaller tsv files, there should be 23 in total.

```bash
ll batchedtsvs/* | wc -l 
```

#### Step 2: For a given BioProject and batch number, prepare the following directory structure
In your directory of choice, prepare the following folders 
```bash
cd /path/to/your/directory/
mkdir -p PRJNA736718/batch23
cd PRJNA736718/batch23
cp /path/to/cloned/repo/Bioproj2Lineage/slurm*Runacc* .
```

#### Step 3: Use sm_Accs2Runaccs to retrieve run accessions from SRA accessions
Modify SBATCH directives and options in slurm_Accs2Runaccs.sh

```bash
nano slurm_Accs2Runaccs.sh
```

Launch snakemake workflow
```bash
sbatch slurm_Accs2Runaccs.sh
```

Check that all accessions have been processed by running the following command.
This should return the same number of lines in the input file: 
in this example, this is /path/to/cloned/repo/Bioproj2Lineage/batchedtsvs/PRJNA736718_batch23_sras.tsv

```bash
wc -l sm_Accs2Runaccs/json_summarise/js_summarise_dummy.tsv
wc -l /path/to/cloned/repo/Bioproj2Lineage/batchedtsvs/PRJNA736718_batch23_sras.tsv
```

If not all jobs have finished running with the initial sbatch command, repeat it. 

#### Step 4: Use sm_Accs2Runaccs to retrieve run accessions from SRA accessions

Modify SBATCH directives and options in slurm_Runacc2Fasta.sh

```bash
nano slurm_Runacc2Fasta.sh
```

Launch snakemake workflow
```bash
sbatch slurm_Runacc2Fasta.sh
```

Check that all accessions have been processed by running the following command.

```bash
wc -l sm_Runacc2Fasta/fasta_summary/fasta_summary_dummy.tsv 
wc -l sm_Accs2Runaccs/json_summarise/js_summarise_dummy.tsv 
```

If not all jobs have finished running with the initial sbatch command, repeat it. 

#### Step 5: To process other batches, repeat steps 2-4 

Modify slurm_batching.sh to modify batch size and input list of SRA accessions.
