#!/bin/bash
date=20180411
segment=05
file=$HOME'/jobs/csarp_'$date'_'$segment'_parameters.txt'
echo "wf1 Jobs in Queue: " $(squeue | grep tbinder | grep "smp a" |  wc -l)
echo "wf2 Jobs in Queue: " $(squeue | grep tbinder | grep "smp b" |  wc -l)
echo "wf3 Jobs in Queue: " $(squeue | grep tbinder | grep "smp c" |  wc -l)
echo "---"
echo "Finished wf1 Jobs: " $(ls -1 /work/ollie/tbinder/Scratch/rds/2018_Greenland_Polar6/CSARP_out/"${date}"_"${segment}"/fk*/wf_01* | wc -l) "/" $(awk '{print $3}' "${HOME}"/jobs/csarp_"${date}"_"${segment}"_parameters.txt | grep '01' | wc -l)
echo "Finished wf2 Jobs: " $(ls -1 /work/ollie/tbinder/Scratch/rds/2018_Greenland_Polar6/CSARP_out/"${date}"_"${segment}"/fk*/wf_02* | wc -l) "/" $(awk '{print $3}' "${HOME}"/jobs/csarp_"${date}"_"${segment}"_parameters.txt | grep '02' | wc -l)
echo "Finished wf3 Jobs: " $(ls -1 /work/ollie/tbinder/Scratch/rds/2018_Greenland_Polar6/CSARP_out/"${date}"_"${segment}"/fk*/wf_03* | wc -l) "/" $(awk '{print $3}' "${HOME}"/jobs/csarp_"${date}"_"${segment}"_parameters.txt | grep '03' | wc -l)
echo "---"
echo "Fehlermeldungen"
sudo get_my_jobs.sh | grep 'FAILED'
sudo get_my_jobs.sh | grep 'TIMEOUT'
grep 'rror' slurm*
grep 'Getötet' slurm*
