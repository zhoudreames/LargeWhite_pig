ref=Hap1.fa
#1.mapping WGS reads
RG="@RG\\tID:${ID}\\tPL:ILLUMINA\\tSM:${ID}\\tLB:${ID}\\tPU:1"
bwa mem -t $nproc -R ${RG} ${ref} $fq1 $fq2 \
| samtools view -Shb -o ${ID}.raw.bam -
samtools sort -@ 30 -m 2G -o ${ID}.sorted.bam ${ID}.raw.bam
samtools index ${ID}.sorted.bam -@30
samtools stats	${ID}.sorted.bam -@30 >$ID.mappingStats &
sambamba markdup -r -t 10  ${ID}.sorted.bam ${ID}.sorted.markdup.bam --overflow-list-size 600000
samtools index ${ID}.sorted.markdup.bam -@30
