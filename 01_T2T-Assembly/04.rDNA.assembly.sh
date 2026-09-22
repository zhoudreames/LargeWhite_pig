#!/bin/bash

#1.rDNA Morph Identification
chr=chr8
# Define input paths for haplotype-specific HiFi and ONT reads
HiFi_fastq=chr8_Hap1.HiFi.fastq.gz
ONT_fastq=chr8_Hap1.ONT.fastq.gz

# Run ribotin-ref to identify rDNA variants
# --approx-morphsize: Expected size of one rDNA repeat (approx. 32kb-45kb in eukaryotes)
# -r: Reference rDNA consensus sequence
ribotin-ref \
 --approx-morphsize 32000 \
 -r rDNA_consensus.fa \
 -i $HiFi_fastq \
 --nano $ONT_fastq \
 -o $chr.ribotin \
 -t 100

#2. Map raw reads back to the consensus rDNA to check coverage.

#2.1 Map HiFi reads to the rDNA consensus
~/01.Biosoft/minimap2-2.29/minimap2 -ax map-hifi consensus.fa hifi_reads.fa -t 100 | \
samtools sort -@ 20 - -o HiFi.aln.bam

#2.2 Map ONT reads to the rDNA consensus
~/01.Biosoft/minimap2-2.29/minimap2 -ax map-ont consensus.fa ont_reads.fa -t 100 | \
samtools sort -@ 20 - -o ONT.aln.bam

#3. Copy Number Determination (K-mer based)
# 3.1 Build k-mer reference for the rDNA consensus
kmc -k31 -ci1 -cs10000 -fm consensus.fa rDNA.consensus.k31 .
kmc_tools transform rDNA.consensus.k31 dump rDNA.consensus.k31.txt

# Convert k-mer text to FASTA for alignment
awk 'BEGIN{i=0}{i+=1;print ">"i"_"$2"\n"$1}' rDNA.consensus.k31.txt > rDNA.consensus.k31.fa

# Index and map consensus k-mers to find their locations within the rDNA unit
/home/jxlabgdp/01.Biosoft/bowtie-1.3.1-linux-x86_64/bowtie-build -f consensus.fa consensus
/home/jxlabgdp/01.Biosoft/bowtie-1.3.1-linux-x86_64/bowtie -p 100 -v 0 -a -x consensus -f rDNA.consensus.k31.fa --sam > rDNA.consensus.k31.fa.sam

# Create a mapping table of k-mer locations and counts
fgrep -v "@" rDNA.consensus.k31.fa.sam | cut -f4,10 > rDNA.consensus.k31.fa.loc
csvtk join -Tt rDNA.consensus.k31.txt rDNA.consensus.k31.fa.loc -f "1;2" | sort -gk3 > rDNA.consensus.k31.ref

# 3.2 Calculate HiFi k-mer depth
kmc -k31 -ci1 -cs10000 -fm hifi_reads.fa hifi_reads.k31 .
kmc_tools transform hifi_reads.k31 dump hifi_reads.k31.txt

# Normalize rDNA k-mer depth by the global mean depth to estimate copy number
csvtk join -Tt -H rDNA.consensus.k31.ref hifi_reads.k31.txt --left-join --na "0" | \
awk '{print $0,$NF/$2}' | tr " " "\t" > hifi.rDNA.counts

# Determine average background depth from the whole chromosome
kmc -k31 -ci3 -cs10000 -fq $HiFi_fastq chr8.HiFi.k31 .
kmc_tools transform chr8.HiFi.k31 histogram chr8.HiFi.k31.histo.txt
mean=`cat chr8.HiFi.k31.histo.txt | sort -grk 2 | awk '$1>10{print $1/2}' | head -1`
awk -v mean=$mean '{print $0,$NF/mean}' hifi.rDNA.counts | tr " " "\t" > hifi.rDNA.counts.adjustDepth.txt

#4. Based on calculations (approx. 30 copies), expand the consensus unit 30 times
awk 'BEGIN{seq=""} /^>/ {header=$0; next} {seq=seq $0} END {printf "%s\n", header; for(i=1; i<=30; i++) printf "%s", seq; printf "\n"}' \
chr8.rDNA.consensus.fa | seqkit seq -w >chr8.30copies.rDNA.fa
