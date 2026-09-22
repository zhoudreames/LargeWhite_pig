#1. braker3 pipline
fa=Hap2.softmask.fa
chrSet=(`fgrep ">" $fa |sed 's/>//g' |awk '{print $1}'`)
chr=`echo ${chrSet[$PBS_ARRAYID]}`

for  i in `awk '{print $1}' bamfiles`
do
  bam=`fgrep $i bamfiles |awk '{print $2}'`
  samtools view $bam $chr  -@10  -o $i.$chr.bam
  samtools index -@10 $i.$chr.bam
done
mkdir -p $chr
mv *.$chr.bam* $chr
cd $chr
seqkit grep -p $chr $fa >$chr.fa
perl /opt/BRAKER/scripts/braker.pl --genome  $chr.fa --prot_seq $input/six_species_ensembl_107.fa --bam `/usr/bin/ls *bam |tr "\n" ","` --threads 100  --gff3  --skipOptimize


