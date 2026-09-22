#!/bin/bash

#1. Run StringTie
ID=`sed -n "${line0}p" ${OUTPUT}/LW.1657id.bamfiles|awk '{print $1}'`
BAM=`sed -n "${line0}p" ${OUTPUT}/LW.1657id.bamfiles|awk '{print $2}'` #hisat2 BAM
INPUT=`dirname $BAM`
stringtie -p 40  -o ${ID}.gtf  $BAM -c 3 -s 6
