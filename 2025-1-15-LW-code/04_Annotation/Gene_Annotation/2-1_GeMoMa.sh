#!/bin/bash

#1. Execute GeMoMa Pipeline
genome=$dataDir2/Hap2.softmask.fa
bam=$dataDir2/alltiussues.RNA.merged.bam

java -Xmx300g -jar /home/jxlabgdp/01.Biosoft/03.Sif/GeMoMa/GeMoMa-1.9.jar  CLI GeMoMaPipeline threads=100 AnnotationFinalizer.r=NO AnnotationFinalizer.u=YES p=false o=true \
t=$genome outdir=$input/6Species-2 \
s=own i=Human a=$dataDir/02.homo/01.GeMoMa/01.Genome-gtf/Homo_sapiens.GRCh38.107.gff3 g=$dataDir/02.homo/01.GeMoMa/01.Genome-gtf/Homo_sapiens.GRCh38.dna.toplevel.fa w=2 \
s=own i=Pig a=$dataDir/02.homo/01.GeMoMa/01.Genome-gtf/Sus_scrofa.Sscrofa11.1.107.gff3 g=$dataDir/02.homo/01.GeMoMa/01.Genome-gtf/Sus_scrofa.Sscrofa11.1.dna.toplevel.fa w=6 \
s=own i=Mouse a=$dataDir/02.homo/01.GeMoMa/01.Genome-gtf/Mus_musculus.GRCm39.107.gff3 g=$dataDir/02.homo/01.GeMoMa/01.Genome-gtf/Mus_musculus.GRCm39.dna.toplevel.fa w=2 \
s=own i=Cattle a=$dataDir/02.homo/01.GeMoMa/01.Genome-gtf/GCF_002263795.3_ARS-UCD2.0_genomic.rm-ncRNA.gff3 g=$dataDir/02.homo/01.GeMoMa/01.Genome-gtf/GCF_002263795.3_ARS-UCD2.0_genomic.fa w=2 \
s=own i=Sheep a=$dataDir/02.homo/01.GeMoMa/01.Genome-gtf/GCF_016772045.2_ARS-UI_Ramb_v3.0_genomic.rm-ncRNA.gff3 g=$dataDir/02.homo/01.GeMoMa/01.Genome-gtf/GCF_016772045.2_ARS-UI_Ramb_v3.0_genomic.fa w=1 \
s=own i=Dog a=$dataDir/02.homo/01.GeMoMa/01.Genome-gtf/GCF_011100685.1_UU_Cfam_GSD_1.0_genomic.rm-ncRNA.gff3 g=$dataDir/02.homo/01.GeMoMa/01.Genome-gtf/GCF_011100685.1_UU_Cfam_GSD_1.0_genomic.fa w=1 \
r=MAPPED ERE.m=$bam 
