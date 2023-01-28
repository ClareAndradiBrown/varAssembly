
#4. Annotate the assembled transcripts
for file in *_polymorphic_reads_1.fq
do
file_name=$(echo "$file" | cut -d"_" -f1)
hmmsearch --domtblout "$file_name"_assembled_transcripts_hmm -E 1e-5 all_var_subdomains_hmm_v6 "$file_name"_SPAdes71_SSPACE.scafSeq
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
python -c 'import process_hmm_annotations; print process_hmm_annotations.("$file_name"_assembled_transcripts_hmm_cathresolvehits)'
done 

