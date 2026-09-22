#!/bin/bash

#1.PCA
gcta64 --bfile LW.PCAsel.proune  --make-grm --make-grm-alg 0 --out kinship
gcta64 --grm kinship --pca 4 --out gcta
#2.Neighbor-joining tree 
/home/jxlabgdp/01.Biosoft/VCF2Dis-1.52/bin/VCF2Dis_multi -InPut LW.raw.vcf.gz -OutPut LW.raw.p_dis.mat
#3.Admiture
admixture --cv LW.PCAsel.proune.bed $line0 -j100
