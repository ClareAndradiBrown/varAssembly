#Assumes read files have their unique id separated by '_'

#1. Identify reads derived from non-core genes
#Map fastq files to human genome
#Assumes all fastq files are in one directory (and are PE reads)


#Build subread index of human genome, Pf 3D7 genome (with var genes excluded) and var3kb exon 1 database
subread-buildindex -o plasmodium_transcripts_novar_index Pf3D7_transcripts_no_var_1.fa
subread-buildindex -o human_genome_index hg38.fa
subread-buildindex -o var_index var3kb_exon1.fasta


#Map reads to human genome and remove any reads that map to the human genome

for file in *_1.fq
do
file_name=$(echo "$file" | cut -d"_" -f1)
subread-align -t 0 -i human_genome_index -r "$file_name"_1.fq -R "$file_name"_2.fq -o "$file_name"_human_mapped.sam --SAMoutput
#extract unmapped reads
samtools view -f 4 "$file_name"_human_mapped.sam | cut -f1 > "$file_name"_unmapped_reads.txt
seqtk subseq "$file_name"_1.fq "$file_name"_unmapped_reads.txt > "$file_name"_human_unmapped_1.fq
seqtk subseq "$file_name"_2.fq "$file_name"_unmapped_reads.txt > "$file_name"_human_unmapped_2.fq
done

#Map the human unmapped reads to Pf 3D7 and identify any unmapped reads
mkdir plasmodium_3d7_mapped_novar
for file in *_human_unmapped_1.fq
do
file_name=$(echo "$file" | cut -d"_" -f1)
subread-align -t 0 -i plasmodium_transcripts_novar_index -r "$file_name"_human_unmapped_1.fq -R "$file_name"_human_unmapped_2.fq -o "$file_name"_mapped_pf_novar.sam --SAMoutput

samtools view -f 4 "$file_name"_mapped_pf_novar.sam  | cut -f1 > "$file_name"_Pf_unmapped_reads.txt
done



#Map the human unmapped reads to var3kb exon 1 and identify any mapped reads
mkdir var3kb_exon1
for file in *_human_unmapped_1.fq
do
file_name=$(echo "$file" | cut -d"_" -f1)
subread-align -t 0 -i var_index -r "$file_name"_human_unmapped_1.fq -R "$file_name"_human_unmapped_2.fq -o "$file_name"_var3kb_mapped.sam --SAMoutput
samtools view -F 4 "$file_name"_var3kb_mapped.sam > "$file_name"_read_mapped_ids.txt
done

#Check for duplication in reads identified (Pf unmapped + var3kb mapped) and identify polymorphic reads
for file in *_human_unmapped_1.fq
do
file_name=$(echo "$file" | cut -d"_" -f1)
cat "$file_name"_read_mapped_ids.txt "$file_name"_Pf_unmapped_reads.txt > "$file_name"_polymorphic_reads_ids.txt
sort "$file_name"_polymorphic_reads_ids.txt| uniq -u > "$file_name"_polymorphic_reads_ids_noDuplicates.txt
seqtk subseq "$file_name"_1.fq "$file_name"_polymorphic_reads_ids_noDuplicates.txt > "$file_name"_polymorphic_reads_1.fq
seqtk subseq "$file_name"_2.fq "$file_name"_polymorphic_reads_ids_noDuplicates.txt > "$file_name"_polymorphic_reads_2.fq
done





