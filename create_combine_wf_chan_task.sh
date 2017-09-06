#!/bin/bash
#SBATCH -t 0:15:00
#SBATCH -p smp
#SBATCH --mem-per-cpu=9999

##  Enlarge the stacksize, just to be on the safe side.
ulimit -s unlimited

echo "SLURM_JOBID: "$SLURM_JOBID
echo "SLURM_ARRAY_TASK_ID: "$SLURM_ARRAY_TASK_ID
echo "SLURM_ARRAY_JOB_ID: "$SLURM_ARRAY_JOB_ID

MCRROOT=$HOME"/local/MATLAB/MATLAB_Runtime/v92"
LD_LIBRARY_PATH=.:${MCRROOT}/runtime/glnxa64
LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${MCRROOT}/bin/glnxa64
LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${MCRROOT}/sys/os/glnxa64
LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${MCRROOT}/sys/opengl/lib/glnxa64

#Choose this, if all frames listed in parameters txt file should be processed
frm=$(cat ${2} | awk '{if ($3== '01' && $4== '01') print $0}' | awk -v line=$SLURM_ARRAY_TASK_ID '{if (NR== line) print $1}')
chunk=$(cat ${2} | awk '{if ($3== '01' && $4== '01') print $0}' | awk -v line=$SLURM_ARRAY_TASK_ID '{if (NR== line) print $2}')

#Choose this, if only one frame listed in parameters txt file should be processed
#frm=015
#chunk=$(cat ${2} | awk -v frm=$frm '{if ($1== frm && $3== '01' && $4== '01') print $0}' | awk -v line=$SLURM_ARRAY_TASK_ID '{if (NR== line) print $2}')

echo "FRAME: "$frm 
echo "CHUNK: "$chunk

srun $HOME"/v92_executables/combine_wf_chan_ollie" $1 $frm $chunk
exit
