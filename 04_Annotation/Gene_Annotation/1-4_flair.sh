#!/bin/bash
output=`pwd`
ref=/home/jxlabgdp/02.GenomeIndex/13.T2T-LW/D01E57.T2T-FaHap.fa
gtf=liftoff.gtf
#1. bam2bed for RNAseq data
bam2Bed12 -i $BAM > $ID.bed
#2.Correct splice junctions using GTF annotation
flair correct \
 -g $ref -q $ID.bed \
 -t 50 --gtf $gtf \
 -o ${ID}_correct
#3.Construct High-Confidence Isoforms with fair
flair collapse \
-g $ref --gtf $gtf \
-q ${ID}_correct_all_corrected.bed -r $fq \
--stringent --check_splice --generate_map --annotation_reliant generate \
-t 50 --temp_dir ./ -o $ID.flair 
