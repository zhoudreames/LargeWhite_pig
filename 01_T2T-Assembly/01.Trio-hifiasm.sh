#!/bin/bash

#1. Generate k-mer database for the parents to enable trio-binning
yak count -b37 -t80 -o D01M57.yak <(cat 00.Data/02.D01M57a0L/D01M57*fastq.gz) 
yak count -b37 -t80 -o D01B57.yak <(cat 00.Data/03.D01B57a1L/D01B57*fastq.gz)
#2. Phased haplotype-Resolved Assembly with Hifiasm
hifiasm -o D01E57.trio-hifiasm-T2T -t 100 -1 D01B57a1L.Father.yak -2 D01M57a0L.Mother.yak D01E57_HiFi_CCS.fq.gz --ul D01E57a0L.UlONT.J002.fq.gz --ul-rate 0.1  --dual-scaf  --telo-m CCCTAA

