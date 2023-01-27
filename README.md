# varAssembly
Pipeline for var gene asssembly from RNA-seq

Main pipeline takes paired-end RNA-seq (fq or fa) and performs var gene assembly. It uses several third party tools:
-Subread align, seqtk, samtools, blobtools, SPAdes, BBMap, SSPACE, HMMER and Cath Tools

The output will be assembled var transcripts and their corresponding domain annotation 
