# Nextflow_QC

# Genomics Workflow with Nextflow

This repository contains a **Nextflow-based workflow** designed for processing paired-end sequencing reads. The workflow handles several steps of genomics data preprocessing, including quality control (FastQC), trimming (Trimmomatic), and FastQC on trimmed reads.

## Workflow Overview

The workflow consists of the following steps:

1. **Raw Reads Quality Control (FastQC)**
   - Performs quality assessment of raw sequencing reads.
   
2. **Read Trimming (Trimmomatic)**
   - Removes low-quality bases from raw reads, ensuring improved downstream analysis.
   
3. **Quality Control on Trimmed Reads (FastQC)**
   - Reassesses trimmed reads to verify the quality improvements.
   
## Prerequisites

To use this workflow, ensure you have the following installed:

- **Nextflow**: [Download Nextflow](https://www.nextflow.io/)
- **FastQC**: [Download FastQC](https://www.bioinformatics.babraham.ac.uk/projects/fastqc/)
- **Trimmomatic**: [Download Trimmomatic](http://www.usadellab.org/cms/?page=trimmomatic)

### Input Requirements

1. **Raw Reads**: Paired-end fastq.gz files located in the directory specified by `params.reads`.

### Parameters

The script uses the following parameters:

- `params.reads`: Path to raw paired-end reads (e.g., `$PWD/raw_reads/*_{1,2}.fastq.gz`).
- `params.outdir`: Output directory (default: `$PWD/Results`).

## Usage

### Running the Workflow

To execute the workflow, use the following command:

```bash
nextflow run workflow.nf -with-dag workflow.html
```

## Workflow

<img src="https://github.com/sgr308/Nextflow_QC/blob/main/wrk.jpg?raw=true" height="500" />
