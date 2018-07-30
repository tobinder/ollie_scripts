#!/bin/bash
#This script checks if every create_qlook_task.sh job was completed. If not, the jobs are restartet. As soon as all jobs have been completed, create_qlook_task2.sh is called.
date=
segment=
static_param=$HOME'/jobs/qlook_'$date'_'$segment'_static_param.mat'
dynamic_param=$HOME'/jobs/qlook_'$date'_'$segment'_dynamic_param.mat'
file_tmp="failed_qlook_jobs_tmp.txt"
counter='run1'

n_jobs=$(sudo get_my_jobs.sh | grep 'ql_'$counter | wc -l)
n_completed=$(sudo get_my_jobs.sh | grep 'ql_'$counter | grep 'COMPLETED' | wc -l)
echo $n_jobs jobs found, $n_completed completed

if [ $n_jobs -eq 0 ]; then exit; fi

if [ $n_completed -eq $n_jobs ]; then 
	echo All jobs completed, combine breaks/waveforms
	./create_qlook_task2.sh  $static_param
elif [ $n_completed -lt 2 ]; then	
	echo "No or very few jobs have been completed. Please check the time limit!"
else 	
	while [ $(sudo get_my_jobs.sh | grep 'ql_'$counter | grep 'FAILED\|TIMEOUT\|CANCELLED' | wc -l) -gt 0 ]; do
		sudo get_my_jobs.sh | grep 'ql_'$counter | grep 'FAILED\|TIMEOUT\|CANCELLED' > $file_tmp
		nr=$(cat $file_tmp | wc -l)
		counter=$(date +%s)
		echo Re-submitting $nr jobs
		sbatch -J 'ql_'$counter --array=1-$nr%100 --output=$HOME/qlook_%A_%a.out ./create_failed_qlook_task.sh $static_param $dynamic_param $file_tmp
		sleep 60
		while true; do
			if [ $(sudo get_my_jobs.sh | grep 'ql_'$counter | grep 'RUNNING' | wc -l) -gt 0 ]; then
				sleep 60
			else	break
			fi
		done
	rm $file_tmp
	done
	echo All jobs completed, combine breaks/waveform
	./create_qlook_task2.sh $static_param 
fi 
