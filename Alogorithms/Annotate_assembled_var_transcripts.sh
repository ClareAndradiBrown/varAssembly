
#4. Annotate the assembled transcripts
for file in *_polymorphic_reads_1.fq
do
file_name=$(echo "$file" | cut -d"_" -f1)
hmmsearch --domtblout "$file_name"_assembled_transcripts_hmm -E 1e-5 var_domain_hmm "$file_name"_SPAdes71_SSPACE.scafSeq
done

#Resolve hits
for file in *_polymorphic_reads_1.fq
do
file_name=$(echo "$file" | cut -d"_" -f1)
cath-resolve-hits --input-format hmmer_domtblout "$file_name"_assembled_transcripts_hmm --hits-text-to-file "$file_name"_assembled_transcripts_hmm_cathresolvehits
done


#Process hmm annotations 
for file in *_polymorphic_reads_1.fq
do
file_name=$(echo "$file" | cut -d"_" -f1)
python -c 'import process_hmm_annotations; print process_hmm_annotations.("$file_name"_assembled_transcripts_hmm_cathresolvehits,"$file_name")'
seqtk subseq "$file_name"_SPAdes71_SSPACE.scafSeq assembled_id_sig_annotation.txt > "$file_name"_sig_var_transcripts.fasta
done 


