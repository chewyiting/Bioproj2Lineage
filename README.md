## Bioproj2Lineage

This directory contains two workflows for profiling Mtb lineages using TB Profiler from publicly available sequences hosted on NCBI. 
* [TB Profiler](https://github.com/jodyphelan/TBProfiler)

## Installation
### Conda environments
```bash
conda create --name bioinfo --file ./myenvs/spec-file-bioinfo.txt
conda create --name snakemake --file ./myenvs/spec-file-snakemake.txt
conda create --name tbprofiler --file ./myenvs/spec-file-tbprofiler.txt
```

### Setting up TB-Profiler
```bash
conda activate tbprofiler
tb-profiler update_tbdb --match_ref ./reference/NC_000962_3.fa
```
## Usage
### Reproducible example

#### Step 1: Batching
The following slurm submission script was designed for ./data/PRJNA736718_sras.tsv
Run just once to batch this initial tsv file into a series of smaller tsv files

```bash
sbatch slurm_batching.sh
```

Inspect the series of smaller tsv files, there should be 23 in total.

```bash
ll batchedtsvs/* | wc -l 
```

#### Step 2: For a given BioProject and batch number, use sm_Accs2Runaccs to retrieve run accessions from SRA accessions
In your directory of choice, prepare the following folders 
```bash
cd /path/to/your/directory/
mkdir -p PRJNA736718/batch23
cd PRJNA736718/batch23
cp /path/to/cloned/repo/Bioproj2Lineage/slurm*Runacc* .
```

Modify SBATCH directives and options in slurm_Accs2Runaccs.sh

```bash
nano slurm_Accs2Runaccs.sh
```

Launch snakemake workflow
```bash
sbatch slurm_Accs2Runaccs.sh
```
