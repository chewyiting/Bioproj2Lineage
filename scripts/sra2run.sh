# acc='SRS6657613'

esearch -db sra -query ${acc} | efetch -format docsum | grep -n 'Run acc' | cut -d '=' -f 2 > tmp_${acc}.txt
sed -i 's/ total_spots//g' tmp_${acc}.txt
sed "s/\"//g" tmp_${acc}.txt > tmp_${acc}_2.txt

echo ${acc} > tmp_${acc}_3.txt
paste tmp_${acc}_3.txt tmp_${acc}_2.txt > ${acc}.txt

rm tmp*txt