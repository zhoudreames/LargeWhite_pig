#!/bin/bash

#BUSCO Genome Completeness Assessment
dir2=/home/jxlabgdp/02.GenomeIndex/mammalia_odb12
ref=`sed -n "${line0}p" ${OUTPUT}/fafiles|awk '{print $2}'`
ID=`sed -n "${line0}p" ${OUTPUT}/fafiles|awk '{print $1}'`
####Busco
seqkit seq -w 60 $ref >$ID.reseq.fa
busco --in  $ID.reseq.fa  -o ${ID}_BUSCO -c 50 -l  $dir2 -m genome --offline -f
rm $ID.reseq.fa
