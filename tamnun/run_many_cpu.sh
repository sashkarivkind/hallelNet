#!/bin/sh

try=1
maxtry=`expr $1 + 1`

while [ $try -lt $maxtry ]
do
echo qsub -v try=$try, -q barak_q run_1_cpu.sh
qsub -v try=$try run_1_cpu.sh
try=`expr $try + 1`
done

