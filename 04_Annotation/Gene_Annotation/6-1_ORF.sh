#!/bin/bash
#1.ORF Refinement with ORFanage
singularity exec ~/01.Biosoft/03.Sif/ORFannotate.simg orfanage --reference $ref_fa --output orfanage.gtf --query $isoform --stats orfanage.stats --threads 100 ~/02.GenomeIndex/14.Dip2-ref/T2T-DRC.dipRef.v2510.revise.gtf 
#2.ORF Refinement with CPC2
singularity exec ~/01.Biosoft/03.Sif/cpc2.simg python3 /CPC2_standalone-1.0.1/bin/CPC2.py -i alltranscripts.fa -o cpc2output.txt -r --ORF 

