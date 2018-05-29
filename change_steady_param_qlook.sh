#!/bin/sh
MCRROOT=$HOME"/local/MATLAB/MATLAB_Runtime/v94"
LD_LIBRARY_PATH=.:${MCRROOT}/runtime/glnxa64
LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${MCRROOT}/bin/glnxa64
LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${MCRROOT}/sys/os/glnxa64
LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${MCRROOT}/sys/opengl/lib/glnxa64
export LD_LIBRARY_PATH;
ch1=0
ch2=0
ch3=0
ch4=0
ch5=0
ch6=0
ch7=0
ch8=0
ch9=0
ch10=0
ch11=0
ch12=0
ch13=0
ch14=0
ch15=0
ch16=0
ch17=0
ch18=0
ch19=0
ch20=0
ch21=0
ch22=0
ch23=0
ch24=0

for ((i=4;i<=$#;i++))
do
    if [ ${!i} == 1 ]; then ch1=1; fi
    if [ ${!i} == 2 ]; then ch2=1; fi
    if [ ${!i} == 3 ]; then ch3=1; fi
    if [ ${!i} == 4 ]; then ch4=1; fi
    if [ ${!i} == 5 ]; then ch5=1; fi
    if [ ${!i} == 6 ]; then ch6=1; fi
    if [ ${!i} == 7 ]; then ch7=1; fi
    if [ ${!i} == 8 ]; then ch8=1; fi
    if [ ${!i} == 9 ]; then ch9=1; fi
    if [ ${!i} == 10 ]; then ch10=1; fi
    if [ ${!i} == 11 ]; then ch11=1; fi
    if [ ${!i} == 12 ]; then ch12=1; fi
    if [ ${!i} == 13 ]; then ch13=1; fi
    if [ ${!i} == 14 ]; then ch14=1; fi
    if [ ${!i} == 15 ]; then ch15=1; fi
    if [ ${!i} == 16 ]; then ch16=1; fi
    if [ ${!i} == 17 ]; then ch17=1; fi
    if [ ${!i} == 18 ]; then ch18=1; fi
    if [ ${!i} == 19 ]; then ch19=1; fi
    if [ ${!i} == 20 ]; then ch20=1; fi
    if [ ${!i} == 21 ]; then ch21=1; fi
    if [ ${!i} == 22 ]; then ch22=1; fi
    if [ ${!i} == 23 ]; then ch23=1; fi
    if [ ${!i} == 24 ]; then ch24=1; fi
    if [ "${!i}" == "all" ] || [ "${!i}" == "center" ]; then
        ch9=1;
        ch10=1;
        ch11=1;
        ch12=1;
        ch13=1;
        ch14=1;
        ch15=1;
        ch16=1;
    fi
    if [ "${!i}" == "all" ]; then
        ch1=1;
        ch2=1;
        ch3=1;
        ch4=1;
        ch5=1;
        ch6=1;
        ch7=1;
        ch8=1;
        ch17=1;
        ch18=1;
        ch19=1;
        ch20=1;
        ch21=1;
        ch22=1;
        ch23=1;
        ch24=1;
    fi
done
eval $HOME"/v94_executables/change_steady_param_qlook" $1 $2 $3 $ch1 $ch2 $ch3 $ch4 $ch5 $ch6 $ch7 $ch8 $ch9 $ch10 $ch11 $ch12 $ch13 $ch14 $ch15 $ch16 $ch17 $ch18 $ch19 $ch20 $ch21 $ch22 $ch23 $ch24
exit
