#!/bin/bash

#1.Repeat Masking with Custom Library
fa=D01M57.Female.Hap1.fa
ID=D01M57.Female.Hap1
chrSet=(`fgrep ">" $fa |sed 's/>//g' |awk '{print $1}'`)
chr=`echo ${chrSet[$PBS_ARRAYID]}`
seqkit grep -p $chr $fa >$chr.fa
singularity exec ~/01.Biosoft/03.Sif/repeatmask.simg bash -c "source activate repeat &&  /repeatmakser/RepeatMasker/RepeatMasker  -pa 100  -xsmall -small -dir split_chr $chr.fa -lib hap1.genome_custom_repeat.lib "
