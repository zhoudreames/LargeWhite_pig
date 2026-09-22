#!/bin/bash
#1. Partition the genome into smaller segments
fa=Hap2.softmask.fa
singularity exec ~/01.Biosoft/03.Sif/evidencemodeler.simg /usr/local/bin/EvmUtils/partition_EVM_inputs.pl \
           --genome $fa \
           --gene_predictions gene_predictions.gff3 \
           --segmentSize 1000000 --overlapSize 200000 \
           --partition_listing partitions_list.out \
           --partition_dir ./ \
#2.Generate raw EVM execution commands
singularity exec ~/01.Biosoft/03.Sif/evidencemodeler.simg /usr/local/bin/EvmUtils/write_EVM_commands.pl --genome $fa --weights $input/weights.txt \
      --gene_predictions gene_predictions.gff3 \
      --output_file_name evm.out  --partitions partitions_list.out > commands.list
awk '{print "singularity exec ~/01.Biosoft/03.Sif/evidencemodeler.simg "$0}' commands.list >commands.list2
mv commands.list2 commands.list

#3.Parallel execution of EVM segments
files=commands.list
n=30
num0=`awk -v n=$n -v line0=$line0 'BEGIN{print n*line0}'`
num1=`awk -v n=$n -v line0=$line0 'BEGIN{print n*(line0-1)+1}'`
sed -n ${num1},${num0}p commands.list >list.part$num0
parallel --jobs 31 < list.part$num0
#4.generate EVM gtf
singularity exec ~/01.Biosoft/03.Sif/evidencemodeler.simg /usr/local/bin/EvmUtils/recombine_EVM_partial_outputs.pl --partitions partitions_list.out --output_file_name evm.out
singularity exec ~/01.Biosoft/03.Sif/evidencemodeler.simg /usr/local/bin/EvmUtils/convert_EVM_outputs_to_GFF3.pl  --partitions partitions_list.out --output evm.out  --genome $fa
find . -regex ".*evm.out.gff3" -exec cat {} \; | bedtools sort -i - > EVM.all.gff
