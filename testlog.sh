#!/bin/sh
chk_res=`ls -l testgoogle.log | awk '{ print $5 }'`
if [ $chk_res -gt 10000000 ]
then
  echo 'size:'$chk_res
  rm logs.tar.bz2
  tar -cvjf logs.tar.bz2 *.log
  rm *.log
fi
