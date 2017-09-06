#!/bin/bash
#This script checks if every create_wf_chan_task.sh job was completed. If not, the jobs are restartet. As soon as all jobs have been completed, create_wf_chan_task2.sh is called.
date=
segment=
steady_param='jobs/csarp_'$date'_'$segment'_steady_param.mat'
file_tmp="failed_combine_jobs_tmp.txt"
counter='run1'

n_jobs=$(sudo get_my_jobs.sh | grep 'combine_'$date'_'$segment'_'$counter | wc -l)
n_completed=$(sudo get_my_jobs.sh | grep 'combine_'$date'_'$segment'_'$counter | grep 'COMPLETED' | wc -l)
echo $n_jobs jobs found, $n_completed completed

if [ $n_jobs -eq 0 ]; then exit; fi

if [ $n_completed -eq $n_jobs ]; then 
	echo All jobs completed, combine chunks/waveforms
	./create_combine_wf_chan_task2.sh $steady_param
#elif [ $n_completed -lt 2 ]; then	
#	echo "No or very few jobs have been completed. Please check the time limit!"
else
	while [ $(sudo get_my_jobs.sh | grep 'combine_'$date'_'$segment'_'$counter | grep 'FAILED\|TIMEOUT\|CANCELLED' | wc -l) -gt 0 ]; do
		sudo get_my_jobs.sh | grep 'combine_'$date'_'$segment'_'$counter | grep 'FAILED\|TIMEOUT\|CANCELLED' > $file_tmp
		nr=$(cat $file_tmp | wc -l)
		counter=$(date +%s)
		echo Re-submitting $nr jobs
		sbatch -J 'combine_'$date'_'$segment'_'$counter --array=1-${nr}%100 --output=$HOME/combine_%A_%a.out ./create_failed_combine_wf_chan_task.sh $steady_param $file_tmp	
		sleep 60
		while true; do
			if [ $(sudo get_my_jobs.sh | grep 'combine_'$date'_'$segment'_'$counter | grep 'RUNNING' | wc -l) -gt 0 ]; then
				sleep 60
			else	break
			fi
		done
	rm $file_tmp
	done
	echo All jobs completed, combine chunks/waveforms
	./create_combine_wf_chan_task2.sh $steady_param
fi 
