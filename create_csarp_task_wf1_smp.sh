#!/bin/bash
#SBATCH -t 0:10:00
#SBATCH -p smp
#SBATCH --mem-per-cpu=4608
##12288 4999
##  Enlarge the stacksize, just to be on the safe side.
ulimit -s unlimited

MCRROOT=$HOME"/local/MATLAB/MATLAB_Runtime/v92"
LD_LIBRARY_PATH=.:${MCRROOT}/runtime/glnxa64
LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${MCRROOT}/bin/glnxa64
LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${MCRROOT}/sys/os/glnxa64
LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${MCRROOT}/sys/opengl/lib/glnxa64

srun $HOME"/v92_executables/csarp_task_ollie" $1 $2 $3 $4 $5 $6
exit
