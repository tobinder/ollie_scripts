#!/bin/bash
##  Enlarge the stacksize, just to be on the safe side.
ulimit -s unlimited

MCRROOT=$HOME"/local/MATLAB/MATLAB_Runtime/v93"
LD_LIBRARY_PATH=.:${MCRROOT}/runtime/glnxa64
LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${MCRROOT}/bin/glnxa64
LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${MCRROOT}/sys/os/glnxa64
LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${MCRROOT}/sys/opengl/lib/glnxa64

srun -t 0:10:00 --qos=short -p smp --mem-per-cpu=4608 $HOME"/v93_executables/get_heights_combine_task_ollie" $1
exit
