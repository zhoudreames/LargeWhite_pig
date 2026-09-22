#!/bin/bash

#1.Fst
singularity exec -B ${vcf_dir}:${vcf_dir} /home/guilu/software/087.vcftools.sif  vcftools --gzvcf $vcf_dir/$chr.890id.beagle.vcf.gz --weir-fst-pop LW. --weir-fst-pop EW.14id --out LWVsEW.$chr.Fst --fst-window-size 50000 --fst-window-step 10000
#2.θπ ratio
singularity exec -B ${vcf_dir}:${vcf_dir} /home/guilu/software/087.vcftools.sif  vcftools --gzvcf $vcf_dir/$chr.630id.beagle.vcf.gz --window-pi 50000 --window-pi-step 10000 --keep LW. --out LW.$chr.pi
singularity exec -B ${vcf_dir}:${vcf_dir} /home/guilu/software/087.vcftools.sif  vcftools --gzvcf $vcf_dir/$chr.630id.beagle.vcf.gz --window-pi 50000 --window-pi-step 10000 --keep EW.14id --out EW.$chr.pi
#3.XP-EHH
#map
zcat $vcf_dir/$chr.890id.beagle.vcf.gz  |cut -f 1,3,2 |awk '{print $1,$3,$2*0.00000112,$2}' |fgrep -v "#" >$chr.map
#extar
bcftools view  $vcf_dir/$chr.890id.beagle.vcf.gz -S LW. --threads=30 -Oz -o $chr.LW..vcf.gz --force-samples
bcftools view  $vcf_dir/$chr.890id.beagle.vcf.gz -S EW.14id --threads=30 -Oz -o $chr.EW.14id.vcf.gz --force-samples
#XP-EHH
singularity exec ~/01.Biosoft/03.Sif/selscan.simg selscan --xpehh --vcf $chr.LW..vcf.gz --vcf-ref $chr.EW.14id.vcf.gz --map $chr.map --threads 100 --out $chr.xpehh

