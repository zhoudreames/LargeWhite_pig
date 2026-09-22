#!/bin/bash

protein=longest-trans.prot.fa
#1.eggNOG-mapper Functional Annotation
singularity exec ~/01.Biosoft/03.Sif/eggNOG-mapper.simg emapper.py -m diamond -i $protein  --cpu 100 --data_dir ~/02.GenomeIndex/04.ProteinDB/03.eggnog/ --dmnd_db ~/02.GenomeIndex/04.ProteinDB/03.eggnog/eggnog_proteins.dmnd --output_dir ./ -o eggNOG-mapper -d euk

#2.Homology Searches (Diamond BLASTP)
singularity exec -B /home/data/GoldenPigGenomes_project/Al_Data/uniprot/:/home/data/GoldenPigGenomes_project/Al_Data/uniprot/ ~/01.Biosoft/03.Sif/diamond.simg diamond blastp --db /home/data/GoldenPigGenomes_project/Al_Data/uniprot/uniprot-diamond -q $protein -o all-uniprot.diamond --threads 100 -e 1e-5 -k 1 --subject-cover 0.5 --sensitive --block-size 40.0 --index-chunks 1
#swiss uniprot
singularity exec ~/01.Biosoft/03.Sif/diamond.simg diamond blastp --db /home/jxlabgdp/02.GenomeIndex/04.ProteinDB/02.uniprot/uniprot_sprot-diamond -q $protein -o swiss-uniprot.diamond --threads 100 -e 1e-5 -k 1 --subject-cover 0.5 --sensitive --block-size 50.0 --index-chunks 1
#sus11 protein
singularity exec ~/01.Biosoft/03.Sif/diamond.simg diamond blastp --db /home/jxlabgdp/02.GenomeIndex/04.ProteinDB/Sus_scrofa.Sscrofa11.1-diamond -q $protein -o Sus11.diamond --threads 100 -e 1e-5 -k 1 --subject-cover 0.5 --sensitive --block-size 50.0 --index-chunks 1

#3.InterProScan Domain Analysis
seqkit split2 -p 100 $protein
proteinSet=(`/usr/bin/ls $protein.split/*`)
fa=`echo ${proteinSet[${PBS_ARRAYID}]}`
#all uniprot
singularity exec -B /home/data/GoldenPigGenomes_project/Al_Data/interproscan/interproscan-5.68-100.0/data/:/opt/interproscan/data ~/01.Biosoft/03.Sif/interproscan.simg /opt/interproscan/interproscan.sh --input $fa --output-dir . --cpu 30 --disable-precalc
