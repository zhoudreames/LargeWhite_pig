#!/bin/bash

#1.Merge GTF files
gffcompare -i allgtf.list -o allGTF  -r $gtf -p MERGE
#2.Prepare transcript sequences and coordinate files for TransDecoder
/usr/local/bin//util/gtf_genome_to_cdna_fasta.pl allGTF.merged.gtf $fa > transcripts.fasta
/usr/local/bin//util/gtf_to_alignment_gff3.pl allGTF.merged.gtf > transcripts.gff3
/usr/local/bin/TransDecoder.LongOrfs -t transcripts.fasta
#3.Homology Searches (Diamond, BLASTP, and Pfam)
diamond blastp --db /home/data/GoldenPigGenomes_project/Al_Data/uniprot/uniprot-diamond -q transcripts.fasta.transdecoder_dir/longest_orfs.pep -o diamond-blastp.outfmt6 --threads 100 -e 1e-5 -k 1 --subject-cover 0.5 --sensitive --block-size 40.0 --index-chunks 1
blastp -query transcripts.fasta.transdecoder_dir/longest_orfs.pep -db /home/jxlabgdp/02.GenomeIndex/04.ProteinDB/02.uniprot/uniprot_sprot-blast  -max_target_seqs 1 -outfmt 6 -evalue 1e-5 -num_threads 100 > blastp.outfmt6
hmmscan --cpu 100 --domtblout pfam.domtblout /home/jxlabgdp/02.GenomeIndex/04.ProteinDB/01.Pfam/Pfam-A.hmm transcripts.fasta.transdecoder_dir/longest_orfs.pep
#4.Predict final coding regions (CDS)
/usr/local/bin/TransDecoder.Predict -t transcripts.fasta --retain_pfam_hits pfam.all --retain_blastp_hits blastp.outfmt6
#5.Map cDNA-based ORF coordinates back to the genome
/usr/local/bin//util/cdna_alignment_orf_to_genome_orf.pl \
     transcripts.fasta.transdecoder.gff3 \
     transcripts.gff3 \
     transcripts.fasta > transcripts.fasta.transdecoder.genome.gff3
