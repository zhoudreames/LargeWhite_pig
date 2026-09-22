#!/bin/bash

#1.monomer identification with centroAnno
ref=Centromere.fa
mom=336bp.Monomer.fa
chr=`fgrep ">" $ref |sed 's/>//g' |awk '{print $1}' |sed -n ${line0}p `
seqkit grep -p $chr $ref >$chr.cen.fa
singularity exec ~/01.Biosoft/centroAnno.simg centroAnno $chr.cen.fa -o $chr.cen.denove -x anno-asm -t 40 
awk -F , '$NF=="336"{print }' $chr.cen.denove/${chr}_decomposedResult.csv |head -1 |tr "," "\t" |cut -f 1,3,4 >$chr.336mom.bed
seqkit subseq --bed $chr.336mom.bed $chr.cen.fa >$chr.336mom.fa
singularity exec ~/01.Biosoft/centroAnno.simg centroAnno $chr.cen.fa -o $chr.cen.denove_mom -x anno-asm -t 40 -m $chr.336mom.fa
singularity exec ~/01.Biosoft/centroAnno.simg python3 /centroAnno/misc/misc/cautils.py $chr.cen.denove_mom $chr.cen.denove_mom.plot

