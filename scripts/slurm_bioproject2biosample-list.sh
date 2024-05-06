#!/bin/bash
#SBATCH --job-name=bioproj2biosample
#SBATCH --output=bioproj2biosample_%A.log
#SBATCH --error=bioproj2biosample_%A.err
#SBATCH --nodes=1 
#SBATCH --ntasks=1 
#SBATCH --cpus-per-task 1
#SBATCH --mem-per-cpu=5120
#SBATCH --time=12:00:00
#SBATCH --account=[YOUR_ACCOUNT]

module load EDirect
mkdir -p data/tabs

# command
for acc in `cat bioproject-id-q03.list`; do \
esearch -db bioproject -query $acc | elink -target biosample | efetch -format docsum | xtract -pattern BioSample \
-SRA "(NA)" \
-block Id -if Id@db -equals "SRA" -SRA Id \
-block Ids -first Id -element "&SRA" \
-ORGANISM "(NA)" \
-block Description -element OrganismName \
-DATE "(NA)" \
-block Attribute -if Attribute@harmonized_name -equals "collection_date" -DATE Attribute \
-block Attributes -element "&DATE" \
-LOC "(NA)" \
-block Attribute -if Attribute@harmonized_name -equals "geo_loc_name" -LOC Attribute \
-block Attributes -element "&LOC" \
-SEQMETHOD "(NA)" \
-block Attribute -if Attribute@attribute_name -equals "seq_methods" -SEQMETHOD Attribute \
-block Attributes -element "&SEQMETHOD" \
-HOST "(NA)" \
-block Attribute -if Attribute@harmonized_name -equals "host" -HOST Attribute \
-block Attributes -element "&HOST" \
-HOSTBODYPRODUCT "(NA)" \
-block Attribute -if Attribute@harmonized_name -equals "isolation_source" -HOSTBODYPRODUCT Attribute \
-block Attributes -element "&HOSTBODYPRODUCT" \ > ./data/tabs/biosample-$acc-full.tab; done
