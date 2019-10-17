#create file for collecting proteome info
echo "Proteome, mcrA_genes, hsp70_genes" > proteomes_genesearch.csv

#here is the for loop code contained in the script file (hmmsearch.sh)
#loop finds first proteome file
#then set the name variable to be the name of the proteome file but with dots and slashes removed
#echo the file name being processed through the loop
#use hmmsearch to look for mcrAgene from hmmbuild against proteome
#output table from hmmsearch is then concatenated, remove lines containing "#", then count number of lines left (hits)
#same code is executed for hsp70gene
#values from catting mcrAgene output table and hsp70 output table along with file name are appended into an already existing file to collect info for each proteome

for file in proteomes/proteome_*.fasta; do
        name=$(echo $file | cut -d "." -f 1 | cut -d "/" -f 2)
        echo $name
        ~/Private/hmmer-3.2.1/bin/hmmsearch --tblout output_tables/mcrA_tables/$name.mcrA.table alingment.mcrA.hmmbuild $file
        mcrAvalue=$(cat ./output_tables/mcrA_tables/"$name.mcrA.table" | grep -v "#" | wc -l) 
	~/Private/hmmer-3.2.1/bin/hmmsearch --tblout output_tables/hsp70_tables/${name}.hsp70.table alingment.hsp70.hmmbuild $file
        hsp70value=$(cat ./output_tables/hsp70_tables/"$name.hsp70.table" | grep -v "#" | wc -l)
        echo $name, "$mcrAvalue", "$hsp70value" >> proteomes_genesearch.csv
done

cat proteomes_genesearch.csv | cut -d ',' -f 1,2 | awk '$2 == 1 || $2 == 2' > candidate_methanogens.csv


