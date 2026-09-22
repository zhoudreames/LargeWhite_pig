#!/bin/bash
#1. SNP calling with graphtyper
/home/yangbin/bin/graphtyper genotype $ref --sams=bamlist --verbose --region=$input --threads=35
/home/yangbin/bin/graphtyper vcf_concatenate ./results/$chr/*.vcf.gz > ${geno}.vcf
#2. SNP Quality Filtering
/usr/bin/ls s*gz  >$ID.list
bcftools concat --naive --file-list $ID.list -Oz -o $ID.vcf.gz  --thread=100
tabix -p vcf $ID.vcf.gz
bcftools view  $ID.vcf.gz  -i '(INFO/AAScore >0.5) & FILTER="PASS" ' --thread=100  -m 2 -M 2  -Oz -o $ID.filter.vcf.gz
