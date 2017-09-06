#!/bin/bash
#This script performs qlook processing of UWB radar data.
date=
segment=
file='jobs/qlook_'$date'_'$segment'_parameters.txt'
steady_param='jobs/qlook_'$date'_'$segment'_steady_param.mat'
dynamic_param='jobs/qlook_'$date'_'$segment'_dynamic_param.mat'
nr=$(cat ${file} | wc -l)
sbatch -J 'qlook_'$date'_'$segment'_run1' --array=1-$(($nr - 1))%100 --output=$HOME/qlook_%A_%a.out ./create_qlook_task.sh $steady_param $dynamic_param $file
