#!/bin/bash

#1.SV Calling with Manta with each samples
RG="@RG\\tID:${ID}\\tPL:ILLUMINA\\tSM:${ID}\\tLB:${ID}\\tPU:1"
$manta  --referenceFasta=$ref_fa --bam=$BAM --runDir=${ID}_manta
cd ${ID}_manta
./runWorkflow.py

#2. Convert Inversions and Filter
/usr/bin/python2 /home/jxlabgdp/01.Biosoft/manta-1.6.0.centos6_x86_64/libexec/convertInversion.py /home/jxlabgdp/01.Biosoft/bin/samtools $ref $vcf > $ID.vcf
grep "#" ${ID}.vcf > ${ID}.vcf_hd
awk '{if($6>=30 && $7=="PASS") print $0}' ${ID}.vcf > ${ID}.vcf_gt
cat ${ID}.vcf_hd ${ID}.vcf_gt > ${ID}.SVfilter.vcf
rm ${ID}.vcf_hd ${ID}.vcf_gt ${ID}.vcf
/home/jxlabgdp/01.Biosoft/bin/bgzip ${ID}.SVfilter.vcf -@20
/home/jxlabgdp/01.Biosoft/bin/tabix ${ID}.SVfilter.vcf.gz
#3.Graph-based SV Genotyping with graphtype
/home/yangbin/bin/graphtyper genotype_sv $ref SV.merged.vcf.gz --sams=bamlist --verbose --region=$input --threads=$nproc
/home/yangbin/bin/graphtyper vcf_concatenate ./sv_results/$chr/*.vcf.gz > ${geno}.vcf
#4.Final SV Filtering and Formatting
find . -name "*dedup.vcf.gz" |sort >vcf_file_list
bcftools concat --naive --file-list vcf_file_list -Oz -o SVs.vcf.gz --threads=100
zcat SVs.vcf.gz |awk '{if($0~/#/)print ;else if($3!~/\./)print }' |bgzip -@20 >SV.rmdup.vcf.gz
tabix -p vcf SV.rmdup.vcf.gz
bcftools view -i 'filter="PASS"'  SV.rmdup.vcf.gz -Oz > SVs.PASS.vcf.gz
tabix SVs.PASS.vcf.gz
bcftools stats SVs.PASS.vcf.gz --threads=20 >SV.PASS.vcf.gz.stats
zcat SVs.PASS.vcf.gz | awk 'BEGIN{OFS="\t"} /^#/ {print; next} {if($3~/\:OG$/); if($5~/[\[\]]/) $5="<BED>"; else if($5~/^<[^:>]+:/)$5=gensub(/^<([^:>]+):.*>$/,"<\\1>","g",$5); print}' | bgzip -c -@20 > SVs.PASS.cleaned.vcf.gz
bcftools view -S 942.id.selIDs SVs.PASS.cleaned.vcf.gz --threads=40 | bcftools filter -e 'AC=0' -Oz -o Population.SVs.vcf.gz --threads=40
/home/guilu/software/087.vcftools.sif vcftools --gzvcf Population.SVs.vcf.gz --recode --recode-INFO-all --max-missing 0.4 --maf 0.01 --out LW.942id.SVs.finally.vcf.gz
p
