#!/bin/bash

#1. π Nucleotide diversity
singularity exec /home/guilu/software/087.vcftools.sif vcftools --gzvcf Population.beagle.vcf.gz --keep $IDS --window-pi 100000 --out $IDS.pi
#2. LD decay
/home/jxlabgdp/01.Biosoft/PopLDdecay/PopLDdecay -InVCF Population.beagle.vcf.gz -OutStat $IDS.LDdecay -SubPop $IDS
#3. ROH
plink --vcf Population.beagle.vcf.gz  --homozyg-density 50 --homozyg-gap 100 --homozyg-kb 500 --homozyg-snp 50 -homozyg-window-het 1 --homozyg-window-snp 50 --homozyg-window-threshold 0.05 --out  LW.630id.ROH  --allow-extra-chr

