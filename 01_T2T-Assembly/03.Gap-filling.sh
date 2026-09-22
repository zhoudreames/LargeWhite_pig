#!/bin/sh

ref=LW.draft.fa
#################  Step1 local assembly based gap filling #################
#1.Generate Contig set verkko with HiFi data
#1.1. Count k-mers for the trio (Father, Mother, Child) to identify hapmers
/home/guilu/software/014.merfin.sif meryl count compress k=30 threads=100  00.Data/03.D01B57a1L/D01B57*fastq.gz output D01B57.Father_compress.k30.meryl
/home/guilu/software/014.merfin.sif meryl count compress k=30 threads=100  00.Data/02.D01M57a0L/D01M57*fastq.gz output D01M57.Mother_compress.k30.meryl
/home/guilu/software/014.merfin.sif meryl count compress k=30 threads=100  00.Data/01.D01E57a0L/D01E57*fastq.gz output D01E57a0L_child_compress.k30.meryl
/merqury-1.3/trio/hapmers.sh D01M57.Mother_compress.k30.meryl  D01B57.Father_compress.k30.meryl D01E57a0L_child_compress.k30.meryl
#1.2 Generate a haplotype-resolved assembly using HiFi and ONT reads
/opt/conda/envs/verkko-v2.0/bin/verkko -d Verkko-trio --hifi D01E57_HiFi_CCS.fq.gz  --nano  D01E57a0L.UlONT.J002.fq.gz  --threads 104 --hap-kmers D01B57.Father_compress.k30.hapmer.meryl D01M57.Mother_compress.k30.hapmer.meryl trio
#1.3 Gap-filling using Verkko-generated contigs
/quarTeT/quartet.py GapFiller -d $ref -g Vekkko.contig.fa -t 100 -p $contig
#1.4 Gap-filling using raw HiFi reads via TGS-GapCloser
/tgsgapcloser/bin/tgsgapcloser  \
        --scaff  $ref2 #Sequence after contig filling \
        --reads  $HiFi_fq \
        --output HiFi-gapfill  \
        --ne \
        --tgstype pb \
        --minmap_arg '-x asm20' \
        --thread 80

#2.1 Generate Contig set flye with ONT data
flye --nano-raw D01E57a0L.UlONT.J002.fq.gz --out-dir ONT.flye --threads 80 -g 2.7g
#2.2 Gap-filling using Flye-generated ONT contigs
/quarTeT/quartet.py GapFiller -d $ref -g ONT.flye.contig.fa -t 100 -p $contig
#####################################################################################

################# Step2: graph resolution based gap filling #########################
gapbed=gap.bed #the gap ± 500kb regions
#1.1 Extract sequences for the gap regions
seqkit subseq --bed $gagbed $ref >$gapbed.fa
#1.2 Homopolymer Compression
awk -v SEQ="" '{if (match($1, ">") && $1 != NAME) { if (SEQ != "") { print NAME; print SEQ; } SEQ=""; NAME=$1; } else {SEQ=SEQ""$1;} } END { print NAME; print SEQ}' | sed -r 's/A{1,}+/A/g;s/G{1,}+/G/g;s/T{1,}+/T/g;s/C{1,}+/C/g'  $gapbed.fa >$gapbed.compress.fa
#1.3 Align compressed sequences to the Verkko Assembly Graph
awk '/^S/{print ">"$2;print $3}' assembly.homopolymer-compressed.gfa >assembly.homopolymer-compressed.fa
blastn -query $gapbed.compress.fa -subject assembly.homopolymer-compressed.fa -evalue 1e-200 -perc_identity 98 -outfmt "6 qacc qlen sacc slen pident length mismatch gapopen qstart qend sstart send evalue bitscore" -out $gapbed.compress.blastn
#1.4 Manual Path Selection
"chr15 <utg000080l<utg000186l>utg000225l, ..." >pathway.txt
#1.5 Generate Sequence from the Path
verkko -d chr15_selpath --hifi D01E57_HiFi_CCS.fq.gz --nano D01E57a0L.UlONT.J002.fq.gz --paths pathway.txt --assembly Verkko-trio
#####################################################################################

