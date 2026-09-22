#!/bin/bash

#1.Generate HiFi reads from subreads
singularity exec -B $dir:$dir  ~/01.Biosoft/03.Sif/ccsmeth.simg  bash -c "source activate ccsmethenv && ccsmeth call_hifi --subreads $BAM --threads 100 --output $ID.hifi.bam"

#2.Call DNA modifications (5mCpG)
singularity exec   --nv   ~/01.Biosoft/03.Sif/ccsmeth.simg  bash -c "source activate ccsmethenv && CUDA_VISIBLE_DEVICES=0 ccsmeth call_mods \
  --input $ID.hifi.bam \
  --model_file  /ccsmeth/models/model_ccsmeth_5mCpG_call_mods_attbigru2s_b21.v3.ckpt \
  --output $ID.hifi.call_mods \
  --threads 30 --threads_call 5 --model_type attbigru2s \
  --mode denovo"

#3.Align modification-tagged HiFi reads
dir=/home/tmpdir/Zhoumeng/01.LW-project/
singularity exec -B $dir:$dir  ~/01.Biosoft/03.Sif/ccsmeth.simg  bash -c "source activate ccsmethenv && ccsmeth align_hifi \
  --hifireads $ID.hifi.call_mods.bam \
  --ref $ref \
  --output $ID.hifi.call_mods.modbam.pbmm2.bam \
  --threads 100 "
#4.Calculate methylation frequency
singularity exec   ~/01.Biosoft/03.Sif/ccsmeth.simg  bash -c "source activate ccsmethenv && ccsmeth call_freqb \
  --input_bam $ID.hifi.call_mods.modbam.pbmm2.bam \
  --ref $ref \
  --output $ID.call_mods.modbam.pbmm2.freq \
  --threads 100 --sort --bed \
  --call_mode aggregate \
  --aggre_model /ccsmeth/models/model_ccsmeth_5mCpG_aggregate_attbigru_b11.v2p.ckpt "

