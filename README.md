# varAssembly
Pipeline for var gene asssembly from RNA-seq as described in Andradi-Brown et al., 2023 A novel computational pipeline for var gene expression augments the discovery of changes in the Plasmodium falciparum transcriptome during transition from in vivo to short-term in vitro cultureeLife12:RP87726
https://doi.org/10.7554/eLife.87726.2

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
Install python-c to run Python scripts from command line:

```
pip install python-c
```
To install dependencies, run the following commands:
```
conda install -c anaconda python
conda install -c bioconda subread 
conda install -c bioconda seqtk
conda install -c bioconda samtools 
conda install -c bioconda blobtools 
conda install -c bioconda spades 
conda install -c bioconda bbmap 
conda install -c bioconda hmmer 
conda install -c bioconda cath-tools 

```
For SSPACE, please download the source code at:https://github.com/nsoranzo/sspace_basic


# Notes on the code:
The pipeline is run in three steps:<br />
<br />

**1. Identifying reads derived from polymorphic genes: This step removes any reads mapping to human and P.falciparum core (non-polymorphic) genes**<br />
  <br />
  Assuming reads are in the same directory as Identify_reads_from_var_genes.sh, run the following command: <br />
  ```sh Identify_reads_from_var_genes.sh ```<br />
  This will identify reads derived from polymorphic genes for all paired fq files in the current directory <br />
  
The output of this step are several fq files for each set of paired end reads:
- *_human_unmapped_1.fq is a fq contaning all the reads that were not mapped to the human genome <br />
-  *_Pf_unmapped_reads.txt is a txt file containing the read ids that are unmapped to the Pf genome (with var removed) <br />
-  *_read_mapped_ids.txt contains the read ids that map to var3kb  <br />
  
*_polymorphic_reads_1.fq are the fq files of the identified polymorphic (non-core) reads, from which var assembly can be performed <br />
<br />

**2. Assembling the var transcripts:** <br />
This is run in several steps: <br />
- rnaSPAdes (k-71) assembly <br />
- bbmap to estimate insert sizes for SSPACE <br />
- SSPACE for contig extension and scaffolding <br />

Assuming the polymorphic reads are in the current directory, run the following command:<br />
 ```sh var_assembly.sh ```<br />
 This will perform var de novo assembly for all *_polymorphic_reads* paired end fq files in the directory <br />

*_SPAdes71_SSPACE files represent the unfiltered assembled transcripts <br />

**3. Annotating the var transcripts**<br /> This step annotates the assembled transcripts with domain annotations defined in Rask et al., 2010. It currently filters for transcripts >= 1500nt in length and containing at least 3 significantly annotated var domains<br /><br />
Run the following command to annotate all the rnaSPAdes assembled transcripts (this will run for all *_SPAdes71_SSPACE files in the directory)<br />
 ```sh Annotate_assembled_var_transcripts.sh ```<br />
- *assembled_id_and_var_annotation.csv is a csv file with the assembled sequence ID and the corresponding var domain annotation<br />
- *_sig_var_transcripts.fasta is a fasta file of the sequences of the significantly annotated var transcripts 
