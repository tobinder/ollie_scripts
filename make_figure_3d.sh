#!/bin/bash
#SBATCH -t 0:05:00
#SBATCH --qos=short

MCRROOT=$HOME"/local/MATLAB/MATLAB_Runtime/v94"
LD_LIBRARY_PATH=.:${MCRROOT}/runtime/glnxa64
LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${MCRROOT}/bin/glnxa64
LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${MCRROOT}/sys/os/glnxa64
LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${MCRROOT}/sys/opengl/lib/glnxa64

csarp_folder='/work/ollie/tbinder/Scratch/rds/2016_Greenland_Polar6/CSARP_music/20160627_08_chk3500/'
segment='20160627_08'
frame=14
min_depth=500
max_depth=1200
max_length=5
min_along_track=0
max_along_track='end'
output_folder='/home/ollie/miller/'
plot_option=0
#0: Show consecutive parts of the whole scene with defined length (max_length)
#1: Show selected part of the scene (from min_along_track to max_along_track)

srun $HOME"/v94_executables/make_figure3d" $csarp_folder $segment $frame $min_depth $max_depth $max_length $min_along_track $max_along_track $output_folder $plot_option
exit
