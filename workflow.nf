#!/usr/bin/env nextflow

// Define parameters
params.reads = "$PWD/raw_reads/*_{1,2}.fastq.gz"
params.outdir = "$PWD/Results"

// Create a channel for paired-end reads
reads_ch = Channel
    .fromFilePairs(params.reads, size: 2, checkIfExists: true)
    .map { pair_id, paths -> tuple(pair_id, paths[0], paths[1]) }
    .set { paired_reads }

// Process 1: Run FastQC (on raw reads)
process fastqc {
    publishDir "${params.outdir}/01_Raw_fastqc", mode: 'copy'

    input:
    tuple val(pair_id), path(forward), path(reverse)

    output:
    path "*_fastqc.*", emit: fastqc_out

    script:
    """
    fastqc ${forward} ${reverse} --outdir=.
    """
}

// Process 2: Run Trimmomatic
process trimmomatic {
    publishDir "${params.outdir}/02_Trimmed_reads", mode: 'copy'

    input:
    tuple val(pair_id), path(forward), path(reverse)

    output:
    tuple val(pair_id), path("${pair_id}_trimmed_1.fastq.gz"), path("${pair_id}_trimmed_2.fastq.gz")

    script:
    """
    java -jar /home/ubuntu/TEST/01_tools/Trimmomatic-0.39/trimmomatic-0.39.jar PE \\
        -threads 15 \\
        ${forward} ${reverse} \\
        ${pair_id}_trimmed_1.fastq.gz ${pair_id}_forward_unpaired.fastq.gz \\
        ${pair_id}_trimmed_2.fastq.gz ${pair_id}_reverse_unpaired.fastq.gz \\
        LEADING:30 TRAILING:30 MINLEN:60
    """
}

// Process 3: Run FastQC (on trimmed reads)
process fastqc_trimmed {
    publishDir "${params.outdir}/03_Trimmed_fastqc", mode: 'copy'

    input:
    tuple val(pair_id), path(trimmed_1), path(trimmed_2)

    output:
    path "*_fastqc.*", emit: trimmed_fastqc_out

    script:
    """
    fastqc ${trimmed_1} ${trimmed_2} --outdir=.
    """
}

// Workflow definition
workflow {
    // Step 1: Run FastQC on raw reads
    fastqc(paired_reads)

    // Step 2: Run Trimmomatic
    trimmed_reads = trimmomatic(paired_reads)

    // Step 3: Run FastQC on trimmed reads
    fastqc_trimmed(trimmed_reads)

}