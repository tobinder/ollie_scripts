#!/bin/sh
#This script changes the frames to be considered in the static_param matlab struct. 
#Inputs: $1: old filename of static_param.mat file
#	 $2: new filename of static_param.mat file with changed frames
#	 $3: frames to be considered as string with commas as delimiter, e.g. '1,2,3' if frames 1, 2 and 3 should be considered
MCRROOT=$HOME"/local/MATLAB/MATLAB_Runtime/v94"
LD_LIBRARY_PATH=.:${MCRROOT}/runtime/glnxa64
LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${MCRROOT}/bin/glnxa64
LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${MCRROOT}/sys/os/glnxa64
LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${MCRROOT}/sys/opengl/lib/glnxa64
export LD_LIBRARY_PATH;

eval $HOME"/v94_executables/change_static_param_frm" $1 $2 $3

