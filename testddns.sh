#!/bin/sh
testdns(){
  if [ -f 'ns'$1'.log' ]
  then
  	cp 'ns'$1'.log' checkdns.log
  else
  	touch checkdns.log
  fi
  oldip=`cat checkdns.log`
  newip=`sh /root/testip.sh $1`
  if [ "$newip" = "" ]
  then
  	echo $1' not resolved! do nothing.'
  else
    echo 'oldip:'$oldip', newip:'$newip
    if [ "$oldip" = "$newip" ]
    then
    	echo $1' is not changed! do nothing.'
    else
    	echo $1' is changed! changing route.'
    	if [ ! "$oldip" = "" ]
    	then
    		testroute checkdns.log del
    	fi
    	testroute 'ns'$1'.log' add
    fi
  fi
  rm checkdns.log

  return $errno
}

testroute(){
  errno=0
  cat $1 | while read line1
  do
  	if [ ! "$line" = "" ]
  	then
  		echo 'doing route '$2' -host '$line1' gw 172.19.172.253'
  		/sbin/route $2 -host $line1 gw 172.19.172.253
      #echo 'errno:'$?
  		errno=`expr $errno + $?`
  	fi
  done

  return $errno
}

errno=0
cat tracker.lst | while read line
do
	if [ ! "$line" = "" ]
	then
    testdns $line
    if [ $errno -gt 0 ]
    then
      echo failed!
    fi
	fi
done
exit 0
