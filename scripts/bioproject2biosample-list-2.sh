#!/bin/bash
#SBATCH --job-name=bioproj2biosample
#SBATCH --output=bioproj2biosample_%A.log
#SBATCH --error=bioproj2biosample_%A.err
#SBATCH --nodes=1 
#SBATCH --ntasks=1 
#SBATCH --cpus-per-task 1
#SBATCH --mem-per-cpu=5120
#SBATCH --time=4:00:00
#SBATCH --account=cohen_theodore

module load EDirect/20.4.20230912-GCCcore-10.2.0
# replace bioproject-id-dummy.list with any text files, new lines = bioproject accession

# command
for acc in `sed -n 2,268p alltab_filteredacc_240331.txt`; do \
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
-block Attributes -element "&HOSTBODYPRODUCT" \ > biosample-$acc-full.tab; done