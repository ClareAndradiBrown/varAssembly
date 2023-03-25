

#2. Assemble var transcripts from polymorphic reads- keeping samples separate
#rna spades, read error correction on, k-mer 71
for file in *_polymorphic_reads_1.fq
do
file_name=$(echo "$file" | cut -d"_" -f1)
rnaspades -o "$file_name"_SPAdes71 -k 71 -1 "$file_name"_polymorphic_reads_1.fq -2 "$file_name"_polymorphic_reads_2.fq
done

#3. Run SSPACE on SPAdes contigs
#SSPACE requires a library.txt file containing insert size estimates- these can be estimated using bbmerge (requires fasta file )
for file in *_polymorphic_reads_1.fq
do
file_name=$(echo "$file" | cut -d"_" -f1)
sed -n '1~4s/^@/>/p;2~4p' "$file_name"_polymorphic_reads_1.fq > "$file_name"_polymorphic_reads_1.fa
sed -n '1~4s/^@/>/p;2~4p' "$file_name"_polymorphic_reads_2.fq > "$file_name"_polymorphic_reads_2.fa
bbmap.sh in1="$file_name"_polymorphic_reads_1.fa in2="$file_name"_polymorphic_reads_2.fa ihist="$file_name"_bbmerge.txt out=bbmerge_out ref=pf3d7_var_transcripts.fasta
done

#Create library file
for file in *_polymorphic_reads_1.fq
do
file_name=$(echo "$file" | cut -d"_" -f1)
insert_size_avg=$(head -1 "$file_name"_bbmerge.txt)
insert_size_avg=$(echo "$insert_size_avg" | cut -d$'\t' -f2)
insert_size=$(echo "$insert_size_avg" | cut -d$'.' -f1)
echo "
bwa "$file_name"_polymorphic_reads_1.fq _polymorphic_reads_1.fq "$insert_size" 0.25 RF
"> "$file_name"_libraries.txt
done

#Run SSPACE
for file in *_polymorphic_reads_1.fq
do
file_name=$(echo "$file" | cut -d"_" -f1)
perl SSPACE_Basic_v2.0.pl -l "$file_name"_libraries.txt -s "$file_name"_SPAdes71_transcripts.fasta -n 31 -x 0 -k 10 -b "$file_name"_SPAdes71_SSPACE
done
