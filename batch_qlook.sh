#!/bin/bash
#This script performs qlook processing of UWB radar data.
date=20160629
segment=03
file=$HOME'/jobs/qlook_'$date'_'$segment'_parameters.txt'
static_param=$HOME'/jobs/qlook_'$date'_'$segment'_static_param.mat'
dynamic_param=$HOME'/jobs/qlook_'$date'_'$segment'_dynamic_param.mat'
nr=$(cat ${file} | wc -l)
sbatch -J 'ql_run1' --array=1-$(($nr - 1))%100 --output=$HOME/qlook_%A_%a.out ./create_qlook_task.sh $static_param $dynamic_param $file
