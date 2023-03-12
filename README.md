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
```
conda install -c anaconda python <br />
conda install -c bioconda subread <br />
conda install -c bioconda seqtk <br />
conda install -c bioconda samtools <br />
conda install -c bioconda blobtools <br />
conda install -c bioconda spades <br />
conda install -c bioconda bbmap <br />
conda install -c bioconda hmmer <br />
conda install -c bioconda cath-tools <br />

```
For SSPACE, please download the source code at:https://github.com/nsoranzo/sspace_basic


# Notes on the code:
The pipeline is run in three steps:<br />
<br />

**1. Identifying reads derived from polymorphic genes: This step removes any reads mapping to human and P.falciparum core (non-polymorphic) genes**<br />
  <br />
  Assuming reads are in the same directory as Identify_reads_from_var_genes.sh, run the following command: <br />
  ```./Identify_reads_from_var_genes.sh ```<br />
  This will identify reads derived from polymorphic genes for all paired fq files in the current directory <br />
  
The output of this step are several fq files:
- *_human_unmapped_1.fq is a fq contaning all the reads that were not mapped to the human genome <br />
-  plasmodium_3d7_mapped_novar/*_Pf_unmapped_reads.txt is a txt file containing the read ids that are unmapped to the Pf genome (with var removed) <br />
-  var3kb_exon1/*_read_mapped_ids.txt contains the read ids that map to var3kb  <br />
  
*_polymorphic_reads_1.fq are the fq files of the identified polymorphic (non-core) reads, from which var assembly can be performed <br />
<br />

**2. Assembling the var transcripts:** <br />
This is run in several steps: <br />
- rnaSPAdes (k-71) <br />
- bbmap to estimate insert sizes for SSPACE <br />
- SSPACE  <br />

*_SPAdes71_SSPACE represent the unfiltered assembled transcripts <br />

**3. Annotating the var transcripts**<br /> This step annotates the assembled transcripts with domain annotations defined in Rask et al., 2010. It currently filters for transcripts >= 1500nt in length and containing at least 3 significantly annotated var domains<br />
- *assembled_id_and_var_annotation.csv is a csv file with the assembled sequence ID and the corresponding var domain annotation<br />
- *_sig_var_transcripts.fasta is a fasta file of the sequences of the significantly annotated var transcripts 
