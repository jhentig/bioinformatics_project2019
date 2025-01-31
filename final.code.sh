#usage: compiles all reference genes into a singular fiel
#cat hsp70* > hsp70refs
#cat mcrA* > mcrArefs

#usage: aligns reference sequences
#./muscle -in hsp70refs -out alignment.hsp70
#./muscle in mcrArefs -out alignment.mcrA 

#usage: create a fuzzy picture of the gene 
#./Private/bin/bin/hmmbuild --amino ./bioinformatics_project2019/alignment.mcrA.hmmbuild ./bioinformatics_project2019/alignment.mcrA
#./Private/bin/bin/hmmbuild --amino ./bioinformatics_project2019/alignment.hsp70.hmmbuild ./bioinformatics_project2019/alignment.hsp70  

#usage: compares hmmbuild "fuzzy" picture to the proteome sequence and generates a table with the number of WP lines being matches
#./Private/bin/bin/hmmsearch --tblout proteome.x.mcrA.table ./bioinformatics_project2019/alignment.mcrA.hmmbuild ./bioinformatics_project2019/proteomes/proteome_0x.fasta
#./Private/bin/bin/hmmsearch --tblout proteome.x.hsp70.table ./bioinformatics_project2019/alignment.hsp70.hmmbuild ./bioinformatics_project2019/proteomes/proteome_0x.fasta

#mkdir output_tables
#cd output_tables
#mkdir mcrA_tables
#mkdir hsp70_tables
#cd ..


cd ./bioinformatics_project2019/
for file in proteomes/proteome_*.fasta; do
        name=`echo $file | cut -d "." -f 1 | cut -d "/" -f 2`
        echo "$name"
	~/Private/bin/bin/hmmsearch --tblout output_tables/mcrA_tables/${name}.mcrA.table alingment.mcrA.hmmbuild $file
	~/Private/bin/bin/hmmsearch --tblout output_tables/hsp70_tables/${name}.hsp70.table alingment.hsp70.hmmbuild $file
done



#this code has lines added in to count number of genes and store that info into a file 

cd ./bioinformatics_project2019/
echo "Proteome, mcrA_genes, hsp70_genes" > proteomes_genesearch.csv
for file in proteomes/proteome_*.fasta; do
        name=`echo $file | cut -d "." -f 1 | cut -d "/" -f 2`
        echo "$name"
        ~/Private/bin/bin/hmmsearch --tblout output_tables/mcrA_tables/${name}.mcrA.table alingment.mcrA.hmmbuild $file
	mcrAvalue=cat ${name}.mcrA.table | grep -v "#" | wc -l
        ~/Private/bin/bin/hmmsearch --tblout output_tables/hsp70_tables/${name}.hsp70.table alingment.hsp70.hmmbuild $file
	hsp70value=cat ${name}.hsp70.table | grep -v "#" | wc -l
	echo "$name, $mcrAvalue, $hsp70value" >> proteomes_genesearch.csv
done


