#!/bin/bash

bed=$input/D01E57.100k.bed
ref=/home/tmpdir/Zhoumeng/01.LW-project/02.Annotation/04.centromere/01.Centromere_Location/D01E57.v4.combined.polishing.fa
chr=`awk '{print $1}' $ref.fai |sed -n ${line0}p `

#1.kmer repetitiveness analysisi for centromere identification
mkdir $chr
cd $chr
fgrep -w $chr $bed  >$chr.bed
num=`cat $chr.bed | wc -l`
for  i in `seq 1 $num`
do
sed -n ${i}p $chr.bed >$chr.$i.bed
seqkit subseq --bed $chr.$i.bed  $ref >$chr.$i.fa
kmc -k15 -m24 -ci1 -fm $chr.$i.fa $chr.$i ./
kmc_tools transform   $chr.$i histogram $chr.$i.txt
total_kmers=`awk '{print $1*$2}' $chr.$i.txt | paste -sd+ |bc`
single_kmers=`awk '$1==1{print $2}' $chr.$i.txt`
single_ratio=`echo "scale=3; $single_kmers/$total_kmers" | bc`
Loc=`cat $chr.$i.bed`
echo  $Loc  $single_kmers $total_kmers $single_ratio >  $chr.${i}.ratio.txt
done
cat *ratio.txt >$chr.SUK.bed
cd ..

#2.The centromere regions were defined as windows with k-mer repetitiveness greater than 80% and satellite sequence content greater than 80%.
cat allchr.SUK.bed |awk '{$4=1-$4;print }' |grep -E "Hap1|chrX" |sed 's/_Hap[1-2]//g' |awk '$NF>0.8{print }' |tr " " "\t" |bedtools merge -d 100000 >centromere.SUK08.bed
fgrep "Sate" LW.repeatmask_rm.bed |cut -f 1-3 >Centromere.Satellite.bed
bedtools makewindows -b centromere.SUK08.bed -w 1000 -s 500 > centromere.SUK08.1kb.bed
bedtools coverage -a Centromere.Satellite.bed -b centromere.SUK08.1kb.bed |awk '$NF >0.8{print }' |bedtools merge -d 10000 | awk '($3-$2) >100000{print }'  >Centromere.SUK08.SAT08.bed

#3. HiC coverage
#Align Hi-C data to the assembly, remove PCR duplicates and filter out secondary and supplementary alignments
RG="@RG\\tID:${ID}\\tPL:ILLUMINA\\tSM:${ID}\\tLB:${ID}\\tPU:1"
bwa mem -5SP -t 100 $ref $fq1 $fq2  -R ${RG} | samblaster \
| samtools view -Shb -@30 -o ${ID}.HiC.raw.bam -
samtools sort -@ 100 -o ${ID}.HiC.sorted.bam  ${ID}.HiC.raw.bam -m 2G
samtools index ${ID}.HiC.sorted.bam -@30
#2.depth
mosdepth -t 10 -b genome.window.bed ${ID}.HiC.sorted_depth ${ID}.HiC.sorted.bam -n -Q 1

