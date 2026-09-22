#!/bin/bash
#Generate centromer visualization figures with StainedGlass
snakemake --use-conda --cores 100 --config sample=DRC_chrX fasta=/home/duhuipeng/DHP/StainedGlass/chrX.fa
snakemake --use-conda --cores 100 make_figures --config sample=DRC_chrX fasta=/home/duhuipeng/DHP/StainedGlass/chrX.fa
