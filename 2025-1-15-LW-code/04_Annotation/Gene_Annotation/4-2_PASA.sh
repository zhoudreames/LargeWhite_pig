fa=Hap2.softmask.fa
trans_fa=transcripts.fasta
EVM=EVM.gff3
config1=alignAssembly.config
config2=annotCompare.config
#1.Transcript Alignment and Assembly
singularity exec -B $PWD ~/01.Biosoft/pasapipeline.v2.5.3.simg  /usr/local/src/PASApipeline/Launch_PASA_pipeline.pl -c $config1 -C -R -g $fa -t $trans_fa.clean -T -u $trans_fa --ALIGNERS blat --CPU 100
#2.Load Existing Gene Annotations
singularity exec -B $PWD ~/01.Biosoft/pasapipeline.v2.5.3.simg  /usr/local/src/PASApipeline/scripts/Load_Current_Gene_Annotations.dbi \
     -c $config1 -g $fa \
     -P $EVM
#3.Annotation Comparison and Update
singularity exec -B $PWD ~/01.Biosoft/pasapipeline.v2.5.3.simg  /usr/local/src/PASApipeline/Launch_PASA_pipeline.pl \
        -c $config2 -A \
        -g $fa \
        -t $trans_fa.clean \
        --CPU 100 

