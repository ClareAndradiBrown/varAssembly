# varAssembly
Pipeline for var gene asssembly from RNA-seq

Main pipeline takes paired-end RNA-seq (fq or fa) and performs var gene assembly. 

The output will be assembled var transcripts and their corresponding domain annotation 

This is executed using several multinlanguage scripts and third party tools. Before you start, please ensure you have Python, Subread align, seqtk, samtools, blobtools, SPAdes, BBMap, SSPACE, HMMER and Cath Tools installed (installation instructions below).

This pipeline assumes you have all required data files (reads, human genome, Pf 3D7 genome (with var excluded), varDB of exon 1 (> 3kb), HMM of var domains).

Most requirements can be installed using Anaconda. Please ensure all are installed before running the pipeline.

To install, run the following commands:

conda install -c anaconda python 
conda install -c bioconda subread
conda install -c bioconda seqtk
conda install -c bioconda samtools
conda install -c bioconda blobtools
conda install -c bioconda spades
conda install -c bioconda bbmap
conda install -c bioconda hmmer
conda install -c bioconda cath-tools 


For SSPACE, please download the source code at:https://github.com/nsoranzo/sspace_basic

