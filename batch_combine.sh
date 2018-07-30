#!/bin/bash
#This script performs the wf combine step after SAR processing of UWB radar data.
date=
segment=
file=$HOME'/jobs/csarp_'$date'_'$segment'_parameters.txt'
static_param=$HOME'/jobs/csarp_'$date'_'$segment'_static_param.mat'
dynamic_param=$HOME'/jobs/csarp_'$date'_'$segment'_dynamic_param.mat'

#Choose this, if all frames listed in parameters txt file should be processed
nr=$(cat ${file} | awk -v frame=$frame '{if ($3== '01' && $4== '01') print $0}' | wc -l)

#Choose this, if only one frame listed in parameters txt file should be processed
#frame=011
#nr=$(cat ${file} | awk -v frame=$frame '{if ($1== frame && $3== '01' && $4== '01') print $0}' | wc -l)

sbatch -J 'comb_run1' --array=1-$nr%100 --output=$HOME/combine_%A_%a.out ./create_combine_wf_chan_task.sh $static_param $dynamic_param $file
