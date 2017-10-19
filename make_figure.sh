#!/bin/bash
#SBATCH -t 0:05:00
#SBATCH --qos=short

MCRROOT=$HOME"/local/MATLAB/MATLAB_Runtime/v92"
LD_LIBRARY_PATH=.:${MCRROOT}/runtime/glnxa64
LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${MCRROOT}/bin/glnxa64
LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${MCRROOT}/sys/os/glnxa64
LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${MCRROOT}/sys/opengl/lib/glnxa64

csarp_folder='/work/ollie/tbinder/Scratch/rds/2016_Greenland_Polar6/CSARP_standard/'
segment='20160627_08'
frame=14
min_depth=500
max_depth=1200
max_length=5
output_folder='/home/ollie/miller/'

srun $HOME"/v92_executables/make_figure" $csarp_folder $segment $frame $min_depth $max_depth $max_length $output_folder
exit