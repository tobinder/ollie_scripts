#!/bin/bash
##  Enlarge the stacksize, just to be on the safe side.
ulimit -s unlimited

MCRROOT=$HOME"/local/MATLAB/MATLAB_Runtime/v94"
LD_LIBRARY_PATH=.:${MCRROOT}/runtime/glnxa64
LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${MCRROOT}/bin/glnxa64
LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${MCRROOT}/sys/os/glnxa64
LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${MCRROOT}/sys/opengl/lib/glnxa64

srun -t 1:30:00 -p fat $HOME"/v94_executables/combine_wf_chan_combine_task_ollie" $1
exit
