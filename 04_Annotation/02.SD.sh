#!/bin/bash

mkdir -p Masked
#1. Use the RM2Bed utility to convert the .out file to a BED file
/gxn/Mzhou2/1.Biosoft/miniconda3/envs/repeatmodeler2/share/RepeatMasker/util/RM2Bed.py \
    Hap2.repeatmask.out -d .
bedtools sort -i Hap2.repeatmask_rm.bed > D01M57.Female.Hap2_repeatmasker.out.bed
mv D01M57.Female.Hap2_repeatmasker.out.bed Masked/

#2. Tandem Repeat Finder (TRF)
snakemake --cores 40 \
    -s /gxn/Mzhou2/1.Biosoft/assembly_workflows/workflows/mask_pig.smk \
    --config sample=D01M57.Female.Hap2 \
    fasta=/gxn/Mzhou2/13.SD/01.SD/04.LW/02.Hap2/D01M57.Female.Hap2.fa \
    --until trf &
#3. Segmental Duplication (SD) Annotation
snakemake --cores 60 \
    -s sedef_pig.smk \
    --config sample=D01M57.Female.Hap2 \
    fasta=/gxn/Mzhou2/13.SD/01.SD/04.LW/01.Hap2/D01M57.Female.Hap2.fa \
    -p sedef
