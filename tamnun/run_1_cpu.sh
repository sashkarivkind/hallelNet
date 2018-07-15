#!/bin/sh

#PBS -N var_g
#PBS -q  barak_q  
#PBS -M hallels@campus.technion.ac.il

#PBS -m n

#
# running built-in MATLAB multithreading option on N cores of an available node 
# where N=<12  (no changes in the MATLAB code are required)
#-------------------------------------------------------------------------------
#PBS -l select=1:ncpus=1

PBS_O_WORKDIR=/u/omrilab/hallel/run/temp
cd $PBS_O_WORKDIR

MATLAB_COMMAND="disp(1);cpu_ind=$try;disp(2);run_matlab_script;disp(3);exit"
MATLAB_LOG="debugLOG_$try.log"
#echo $MATLAB_COMMAND
#MATLAB run command
#-----------------------
matlab -nojvm -nosplash -nodisplay -singleCompThread -logfile $MATLAB_LOG -r $MATLAB_COMMAND

 