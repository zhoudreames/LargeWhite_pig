#!/bin/bash
fa=D01M57.Female.Hap1.fa
ID=D01M57.Female.Hap1
#1. Build the Sequence Database
singularity exec ~/01.Biosoft/03.Sif/repeatmask.simg /opt/conda/envs/repeat/bin/BuildDatabase -name ${ID}_db -engine ncbi $fa
#2. De Novo Repeat Modeling
singularity exec ~/01.Biosoft/03.Sif/repeatmask.simg bash -c "source activate repeat &&  /opt/conda/envs/repeat/bin/RepeatModeler -threads 100 -database ${ID}_db -engine ncbi " 

