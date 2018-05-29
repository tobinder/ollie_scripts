#!/bin/bash
#SBATCH -t 0:15:00
#SBATCH -p smp
#SBATCH --mem-per-cpu=9999

##  Enlarge the stacksize, just to be on the safe side.
ulimit -s unlimited

echo "SLURM_JOBID: "$SLURM_JOBID
echo "SLURM_ARRAY_TASK_ID: "$SLURM_ARRAY_TASK_ID
echo "SLURM_ARRAY_JOB_ID: "$SLURM_ARRAY_JOB_ID

MCRROOT=$HOME"/local/MATLAB/MATLAB_Runtime/v94"
LD_LIBRARY_PATH=.:${MCRROOT}/runtime/glnxa64
LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${MCRROOT}/bin/glnxa64
LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${MCRROOT}/sys/os/glnxa64
LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${MCRROOT}/sys/opengl/lib/glnxa64

task_id=$(cat ${2} | awk -v line=$SLURM_ARRAY_TASK_ID '{if (NR== line) print $1}')
frm=$(cat 'combine_'${task_id}'.out' | grep 'FRAME:' | awk -F ':' '{ print $2 }')
chunk=$(cat 'combine_'${task_id}'.out' | grep 'CHUNK:' | awk -F ':' '{ print $2 }')

echo "FRAME: "$frm 
echo "CHUNK: "$chunk

srun $HOME"/v94_executables/combine_wf_chan_ollie" $1 $frm $chunk
exit
