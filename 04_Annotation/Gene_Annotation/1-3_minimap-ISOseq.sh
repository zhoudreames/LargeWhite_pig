#!/bin/bash
ref=/home/jxlabgdp/02.GenomeIndex/13.T2T-LW/D01E57.T2T-FaHap.fa

ID=`sed -n "${line0}p" ${output}/LW.Isoseq.fqfiles|awk '{print $1}'`
fq=`sed -n "${line0}p" ${output}/LW.Isoseq.fqfiles|awk '{print $2}'`

#1.ISOseq mapping
RG="@RG\tID:"$ID"\tDS:"$ID"\tSM:ISO-seq"
minimap2 -t 50 -ax splice:hq -uf --MD  $ref $fq -R $RG |samtools sort -m 2G  -@30 - > $ID.sort.bam
samtools index $ID.sort.bam &
samtools view -q 10 -F 2304 -hb $ID.sort.bam -@30 > $ID.filter.bam
samtools index -@20 $ID.filter.bam
