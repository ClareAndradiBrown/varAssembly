# varAssembly
Pipeline for var gene asssembly from RNA-seq

Main pipeline takes paired-end RNA-seq (fq or fa) and performs var gene assembly. 

The output will be assembled var transcripts and their corresponding domain annotation 

This is executed using several multilanguage scripts and third party tools. Before you start, please ensure you have Python, Subread align, seqtk, samtools, blobtools, rnaSPAdes, BBMap, SSPACE, HMMER and Cath Tools installed (installation instructions below).

# Data 
This pipeline assumes you have all required data files (reads, human genome, Pf 3D7 genome (with var excluded), varDB of exon 1 (> 3kb), HMM of var domains).

# Dependencies
Most requirements can be installed using Anaconda. Please ensure all are installed before running the pipeline.<br />
Linux OS is preferable. <br />
python 3.1 or later versions required <br />
<br /> python packages required: NumPy and Pandas<br />

To install dependencies, run the following commands:

conda install -c anaconda python <br />
conda install -c bioconda subread <br />
conda install -c bioconda seqtk <br />
conda install -c bioconda samtools <br />
conda install -c bioconda blobtools <br />
conda install -c bioconda spades <br />
conda install -c bioconda bbmap <br />
conda install -c bioconda hmmer <br />
conda install -c bioconda cath-tools <br />


For SSPACE, please download the source code at:https://github.com/nsoranzo/sspace_basic


# Notes on the code:
The pipeline is run in three steps:<br />
1. Identifying reads derived from polymorphic genes: This step removes any reads mapping to human and P.falciparum core (non-polymorphic) genes<br />
  <br />
  The output of this step are several fq files:
* *_human_unmapped_1.fq is a fq contaning all the reads that were not mapped to the human genome <br />
* plasmodium_3d7_mapped_novar/*_Pf_unmapped_reads.txt is a txt file containing the read ids that are unmapped to the Pf genome (with var removed) <br />
* var3kb_exon1/*_read_mapped_ids.txt contains the read ids that map to var3kb  <br />
  
2. Assembling the var transcripts: This step runs rnaSPAdes (k-71) followed by SSPACE to assemble var transcripts <br />
3. Annotating the var transcripts: This step annotates the assembled transcripts with domain annotations defined in Rask et al., 2010. It currently filters for transcripts >= 1500nt in length and containing at least 3 significantly annotated var domains<br />
