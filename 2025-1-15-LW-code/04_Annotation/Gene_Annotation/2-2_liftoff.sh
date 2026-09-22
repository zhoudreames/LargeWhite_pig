#!/bin/bash

#1.liftoff based on Sscrofa11.1.107 GTF
input_gtf=/home/jxlabgdp/02.GenomeIndex/03.Sus11.1/Sus_scrofa.Sscrofa11.1.107.gff3
input_fa=/home/jxlabgdp/02.GenomeIndex/03.Sus11.1/Sus_scrofa.Sscrofa11.1.dna.toplevel.fa
output_fa=Hap2.softmask.fa
liftoff -g $input_gtf -copies -sc 0.95 -polish -exclude_partial -p 100 -dir ${output_fa%%.fa} -o ${output_fa%%.fa}.liftoff.gff3 $output_fa $input_fa
