#!/bin/sh
HiFi_fq=$1
Illumina_fq=$2
ref=$3

#1.HiFi mapping with winnowmap2
meryl count k=15 output merylDB $ref
meryl print greater-than distinct=0.9998 merylDB > repetitive_k15.txt
winnowmap --MD  -W repetitive_k15.txt  -ax map-pb $ref $HiFi_fq  > HiFi.sam
samtools sort -@20 -o HiFi.sorted.bam HiFi.sam
samtools index HiFi.sorted.bam &
samtools view -F0x104 -h HiFi.sorted.bam -@20   |samtools sort -@20  - >HiFi.sorted_primary.bam
samtools index -@20  HiFi.sorted_primary.bam

#2.Prepare k-mer dataset files
yak count -o Illumina.k21.yak -k 21 -b 37 $Illumina_fq
yak count -o Illumina.k31.yak -k 31 -b 37 $Illumina_fq

#4.genome polishing with nextPolish2
nextPolish2 -r -t 100 HiFi.sorted_primary.bam $ref Illumina.k21.yak Illumina.k31.yak > LW.finally.fa
