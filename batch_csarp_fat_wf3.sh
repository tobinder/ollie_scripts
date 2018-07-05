#!/bin/bash
#This script performs SAR processing of UWB radar data.
#For a given segment, the number of jobs is derived from the job parameter file.
#Then the create_csarp_task are called for all jobs.
#Only 96 wf3 jobs are allowed in queue, delay submission of further jobs
date=20180508
segment=01
echo ----------------------------------
echo SAR processing segment $date'_'$segment
echo ----------------------------------
file=$HOME'/jobs/csarp_'$date'_'$segment'_parameters.txt'
static_param=$HOME'/jobs/csarp_'$date'_'$segment'_static_param.mat'
dynamic_param=$HOME'/jobs/csarp_'$date'_'$segment'_dynamic_param.mat'
tail -n +2 "$file" > "${file}_tmp" #skip header
file_tmp="${file}_tmp"
while read frm chunk wf adc
do  
  while true; do
          if test $(squeue | grep tbinder | grep "fat c" |  wc -l) -gt 95; then
            sleep 60
            else break
          fi
      done
  if [ $wf -eq 3 ]; then
    if test -e '/work/ollie/tbinder/Scratch/rds/2018_Greenland_Polar6/CSARP_out/'$date'_'$segment'/fk_data_'$frm'_01_01/wf_03_adc_'$adc'_chk_'$chunk'.mat'
            then
             echo 'File fk_data_'$frm'_01_01/wf_03_adc_'$adc'_chk_'$chunk'.mat already exists.'
            else 
             sbatch -J 'c'${frm#0}''$chunk''$adc ./create_csarp_task_wf3.sh $static_param $dynamic_param $frm $chunk $wf $adc
    fi
  fi 
  sleep 1
done < $file_tmp
rm $file_tmp
