#!/bin/sh
start=$(cat /dev/urandom | head -n 10 | cksum | awk -F ' ' '{print $1}')
start=`expr $start % 7`
start="$start,\$p"
sed -n $start vpnservers.lst | while read line
do
  expressvpn connect $line >vpnstate.log
  cat vpnstate.log
  chk_res=`ls -l vpnstate.log | awk '{ print $5 }'`
  if  [ $chk_res -eq 0 ]
  then
          echo success
          exit 0
  else
          echo failed
  fi
done
exit 0
