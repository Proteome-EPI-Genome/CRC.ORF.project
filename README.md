# CRC.ORF.project

Processing ...

Will be ready soon

### 1. Ribo-seq Data Processing


### 2. Screen Library Design


### 3. Screen Data Processing & Analysis


### 4. RNA-seq Data Processing & Analysis

STEP 1: Trim for adaptor sequence and mask for low-complexity and low-quality sequence

STEP 2: Map to the human genome (GRCh38) and GENCODE V22 transcriptome

STAR v.2.6.1b with the parameters: “--outSAMunmapped Within --outFilterType BySJout --twopassMode Basic --outSAMtype BAM SortedByCoordinate”.

STEP 3: Expression Read Count

The gene-level raw read-counts were calculated using htseq-count function of HTSeq (0.11.0), based on the aligned and sorted bam files.

STEP 4: Normalization & Differential Expression Analysis

The normalization of read counts and differential gene expression analysis were performed, using DESeq2(1.22.2). The filters of

`basemean >= 1 && |log2Fold-Change| >= log2(1.5) && FDR <= 0.05`   

were used to define differentially expressed genes for downstream analysis.


### 5. ChIP-seq Data Processing & Analysis

STEP 1: Reads QC and Trim Adaptor
ChIP-seq reads were first trimmed by Trim Galore (v0.6.5) (https://www.bioinformatics.babraham.ac.uk/projects/trim_galore/), a wrapper around two tools: cutadapt v2.8 (https://github.com/marcelm/cutadapt/) and FastQC v0.11.5 (https://github.com/chgibb/FastQC0.11.5/; https://www.bioinformatics.babraham.ac.uk/projects/fastqc/).
STEP 2: Mapping
Reads were then mapped to the human genome (GRCh38), using Bowtie2 (v2.4.1). The resulting sorted BAM files were converted into bedGraph and bigWig formats using BEDTools (v2.24.0) and UCSC bedGraphToBigWig (v4).
STEP 3: PEAK Calling
The ChIP-seq peaks were identified by MACS2 (v2.1.2) with the parameters `macs2 callpeak -t ChIP.bam -c INPUT.bam -g hs --outdir output -n NAME 2> NAME.callpeak.log`. BETA (v1.0.7) was used to annotate the peaks that are associated with genes of interest (FDR0.05).


### 6. TCGA Expression & Clinical Data Correlation Analysis

TCGA and GTEx RNA-seq data joint analysis was performed based on the combined cohort: TCGA TARGET GTEx, from UCSC Toil RNA-seq Recompute Normalized gene expression in TPM and clinical information were extracted with customized script, for the differential gene expression analysis between tumor and tissues, and among different cancer types. The Wilcoxon Rank Sum Test was used to identify the genes with deregulated expression between tumors and the corresponding normal tissues.


### 7. Functional Annotation & Gene Functional Enrichment Analysis

The gene ontology enrichment analysis was performed in DAVID.

