#!/bin/bash

#1.introgression analysis
rfmix -f $ID.vcf.gz \
-r $i.ref.vcf.gz \
-m reference.map2 \
-g Genetic_map.bed \
-o $ID.$i.rfmix \
--chromosome=${i} \
--n-threads=100

