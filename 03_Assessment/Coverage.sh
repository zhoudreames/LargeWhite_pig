#!/bin/bash

ref=D01E57.v4.combined.polishing.fa
ID=`echo $ref |awk -F . '{print $1".HiFi"}'`
fq=/home/data/GoldenPigGenomes_project/LW-project/01.LW/00.T2T-LW/00.Data/01.D01E57a0L/D01E57_HiFi_CCS.fastq.gz
#1 Perform alignment with Minimap2
~/01.Biosoft/minimap2-2.29/minimap2 --split-prefix --MD -ax map-hifi $ref $fq -t100  > $ID.sam
samtools sort -@20 -o $ID.sorted.bam $ID.sam
samtools index $ID.sorted.bam &
samtools view -F0x104 -h $ID.sorted.bam -@20   |samtools sort -@20  - >$ID.sorted_primary.bam
samtools index -@20  $ID.sorted_primary.bam

#2.Coverage and Heterozygosity Analysis (NucFreq)
chr=`fgrep ">" $fa |sed 's/>//g' |sed -n ${line0}p`
samtools  view -h $bam $chr -@20 -o $chr.hifi.bam
samtools index $chr.hifi.bam -@20
singularity exec  ~/01.Biosoft/03.Sif/NucFreq.simg /NucFreq/NucPlot.py  -t 10  --obed $chr.Het.bed --minobed 2 $chr.hifi.bam $chr.hifi.png 
