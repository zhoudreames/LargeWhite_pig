#!/bin/bash
ref=$1
name=`echo $ref |sed 's/.fa*//g'`
child_yak=/home/tmpdir/Zhoumeng/01.LW-project/01.T2T-assembly/01.Assembly/J002/D01E57.child.yak
fa_yak=/home/tmpdir/Zhoumeng/01.LW-project/01.T2T-assembly/01.Assembly/J002/D01B57a1L.Father.yak
mo_yak=/home/tmpdir/Zhoumeng/01.LW-project/01.T2T-assembly/01.Assembly/J002/D01M57a0L.Mother.yak

#1.Phasing accuracy
yak trioeval -t100 $fa_yak $mo_yak $ref >$name.yak_phasing.txt
