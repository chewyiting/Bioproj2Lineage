import requests
import time
import argparse
import pandas as pd
from io import StringIO

parser = argparse.ArgumentParser(
    prog='name',
    description='what this program does'
)
parser.add_argument("--metadata",required=True,help="metadata to get FTP addresses for, accession in 1st column")
parser.add_argument("--addresses",required=True,help="name of the file to output addresses to")
#parser.add_argument("--sampleinfo",required=True,help="output .tsv file to put sample info in")
args=parser.parse_args()

infile=args.metadata
outfile=args.addresses
#sampleinfo=args.sampleinfo


# Read the list of accessions from the .tsv file
with open(infile, 'r') as file:
    accessions = [line.strip().split('\t')[0] for line in file]

# Base URL for ENA API
base_url = 'https://www.ebi.ac.uk/ena/portal/api/'

#track if header has been printed (to print it only once) - uncomment if you want header
header_printed = False

#sample_info=open(sampleinfo,'w')
#open the output tsv
#realoutput = pd.DataFrame(columns=['run_accession','sample_accession','R1_end','R2_end'])
with open(outfile,'w') as output_file:
#with pd.Dataframe()

    # Iterate through the accessions and make API requests
    for accession in accessions:
        # Build the API request URL

        #use this if you want more metadata columns
        #api_url = f'{base_url}search?result=read_run&includeAccessions={accession}&fields=run_accession%2Cexperiment_accession%2Csample_accession%2Cfastq_bytes%2Cfastq_ftp%2Csubmitted_bytes%2Csubmitted_ftp%2Csubmitted_aspera%2Cbam_ftp&limit=10'
        
        #use this to only get the acessions and FTP addresses
        api_url_fastq = f'{base_url}search?result=read_run&includeAccessions={accession}&fields=fastq_ftp%2Cfastq_md5%2Csample_accession&format=json'
        # and now get only the run accession
        #api_url_runaccession = f'{base_url}search?result=read_run&includeAccessions={accession}&fields=run_accession'

        # Send the API request
        fastq_urls_response = requests.get(api_url_fastq)
        #runaccession_response = requests.get(api_url_runaccession)
        #print(fastq_urls_response)

        # Process the responses and print to outfiles
        if fastq_urls_response.status_code == 200:
            data = pd.read_json(StringIO(fastq_urls_response.text),orient='records')
            #data = pd.read_json(fastq_urls_response.text,orient='records')
            #print(data)
            #lines=data.split('\n')
            #lines=len(data)

            #un-comment lines below if you want headers
            if not header_printed:
              #print("run_accession\texperiment_accession\tsample_accession\tfastq_bytes\tfastq_ftp\tsubmitted_bytes\tsubmitted_ftp\tsubmitted_aspera\tbam_ftp")
              #sample_info.write("run_accession\texperiment_accession\tsample_accession\tfastq_bytes\tfastq_ftp\tsubmitted_bytes\tsubmitted_ftp\tsubmitted_aspera\tbam_ftp")
              #header = lines[0]
              #output_file.write(f'{header}')
              output_file.write("strain\trun_accession\tsample_accession\tfastq_1\tfastq_2\tmd5_r1\tmd5_r2\n")
              header_printed = True
            
            
            #lines=data.split('\n')
            if len(data) >= 0:
                #the first line of the API response has headers, so only want the 2nd line
                #second_line = lines[1:]
                #print(second_line)

                #uncomment below if you want full FTP addresses
                #sample_info.write(f"\n{second_line}")

                #the following formats Aspera download addresses from FTP addresses
                #accession=second_line.split('\t')[0]
                #sample_accession=data.sample_accession
                #print(sample_accession)
                #ftp_separate=second_line.split(';')
                data[['R1','R2']]=data['fastq_ftp'].str.split(';',expand=True)
                data[['md5_r1','md5_r2']]=data['fastq_md5'].str.split(';',expand=True)
                #print(accession)
                data['strain']=accession
                #print(data)
                if len(data) >=0:
                    #R1=ftp_separate[0]
                    data[['R1_start','R1_end']]=data['R1'].str.split('.uk/',expand=True)
                    #print(data)
                    #output_file.write(f"module load Aspera-CLI; ascp -T -i /vast/palmer/apps/avx2/software/Aspera-CLI/3.9.6.1467.159c5b1/etc/asperaweb_id_dsa.openssh -l 300m -P 33001 era-fasp@fasp.sra.ebi.ac.uk:vol1/fastq/{R1_endonly} {accession}_1.fastq.gz\n")
                    #R2=ftp_separate[1]
                    #R2_endonly=data['R2'].str.split('.uk/')[0]
                    #print(R2_endonly)
                    data[['R2_start','R2_end']]=data['R2'].str.split('.uk/',expand=True)
                    #print(data)
                    output_file.write(data[['strain','run_accession','sample_accession','R1_end','R2_end','md5_r1','md5_r2']].to_csv(header=False,index=False,sep='\t'))
                    #pd.concat([realoutput,data])
                    #output_file.write(f"module load Aspera-CLI; ascp -T -i /vast/palmer/apps/avx2/software/Aspera-CLI/3.9.6.1467.159c5b1/etc/asperaweb_id_dsa.openssh -l 300m -P 33001 era-fasp@fasp.sra.ebi.ac.uk:vol1/fastq/{R2_endonly} {accession}_2.fastq.gz\n")
                    #output_file.write(f'{accession}\t{R1_endonly}\t{R2_endonly}\n')

        else:
            print(f"Error for accession {accession}: {fastq_urls_response.status_code}")
        #Pause for 0.02 seconds as ERA limits users to 50 requests/second
        time.sleep(0.02)

#outfile,write(data)