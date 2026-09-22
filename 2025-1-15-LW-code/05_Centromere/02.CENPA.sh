#!/bin/bash

#1.CHENPA chipseq mapping
bwa mem -t 100 $ref $fq1 $fq2 |samtools view -F 2308 -@ 70 -Sb > $ID.bam
samtools sort -@ 60 $ID.bam -o $ID.sorted.bam
samtools index $ID.sorted.bam -@20
#2.MACS2 peak calling
singularity exec /home/guilu/software/142.macs.sif macs2 callpeak -t no-input.sorted.bam -c input.sorted.bam -f BAM -q 0.05 -g 2.6e+9 --broad-cutoff 0.05 --outdir hap1.Macs2seq -n hap1.Macs2seq -B --nomodel
cut -f 1-3 hap1.Macs2seq_peaks.narrowPeak |bedtools merge -d 20000  >Activate.10k.bed
singularity exec /home/guilu/software/143.deeptools.sif bamCompare -b1 no-input.sorted.bam -b2 input.sorted.bam -o log2ratio.bw --operation log2 -p 100
