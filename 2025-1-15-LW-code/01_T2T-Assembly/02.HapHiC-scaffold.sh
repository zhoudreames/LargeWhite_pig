#!/bin/sh

contig=D01E57.trio-hifiasm-T2T.hap1.p_ctg.fa
chr_num=19
HiC_fq_R1=$1
HiC_fq_R2=$2

#1.Align Hi-C data to the assembly, remove PCR duplicates and filter out secondary and supplementary alignments
bwa index $contig
bwa mem -5SP -t 60 $contig $HiC_fq_R1 $HiC_fq_R2 | samblaster | samtools view - -@ 14 -S -h -b -F 3340 -o HiC.bam

#2.Filter the alignments with MAPQ 1 (mapping quality ≥ 1) and NM 3 (edit distance < 3)
/HapHiC/utils/filter_bam HiC.bam 1 --nm 3 --threads 14 | samtools view - -b -@ 14 -o HiC.filtered.bam

#3.Run HapHiC scaffolding pipeline
/HapHiC/haphic pipeline  $contig  HiC.filtered.bam $chr_num  --threads 30 
#after manually adjusting scaffold sequence with juicebox, we got a LW draft genome(LW.draft.fa)  
