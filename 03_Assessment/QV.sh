#!/bin/bash

#1. QV caculate
ref=$1
name=`echo $ref |sed 's/.fa*//g'`
db=/home/tmpdir/Zhoumeng/01.LW-project/01.T2T-assembly/03.polishing/mequry/D01E57a0L_child.k21.meryl/

mkdir $ref.QV
cp $ref $ref.QV
cd $ref.QV
dir=`dirname $db`
singularity exec -B ${dir}:${dir} ~/01.Biosoft/03.Sif/merqury.simg /opt/merqury/merqury.sh $db $ref ${ref%%.fa}.merqury
