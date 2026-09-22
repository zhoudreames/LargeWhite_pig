#!/bin/bash

ref=/home/tmpdir/Zhoumeng/01.LW/04.ScientificData/02.Analysis/03.annotation/03.Gene/02.Hap2/01.RNA-BAM/D01M57.Female.Hap2.softmask
ID=`sed -n "${line0}p" ${INPUT}/fq.files|awk '{print $1}'`
fq1=`sed -n "${line0}p" ${INPUT}/fq.files|awk '{print $2}'`
fq2=`sed -n "${line0}p" ${INPUT}/fq.files|awk '{print $3}'`
#1.Quality Control and Filtering
fastp --thread=40  -l 75 -c -i $fq1  -o ${ID}_RNAClean_1.fq.gz -I  $fq2  -O ${ID}_RNAClean_2.fq.gz -j ${ID}.json -h ${ID}.html

#2. RNAseq mapping
/home/jxlabgdp/01.Biosoft/hisat2-2.2.0/hisat2 -x $ref -p 100 -I 0 --qc-filter -X 500 --dta -1 \
${ID}_RNAClean_1.fq.gz -2  ${ID}_RNAClean_2.fq.gz -S ${ID}.sam
samtools sort -@30 ${ID}.sam -o ${ID}.sorted.bam
samtools index -@30 ${ID}.sorted.bam
sambamba markdup  -t 5  ${ID}.sorted.bam ${ID}.sorted.markdup.bam --overflow-list-size 600000
samtools index ${ID}.sorted.markdup.bam -@30


