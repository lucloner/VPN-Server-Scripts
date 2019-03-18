#!/bin/sh
nslookup $1 114.114.114.114 | grep -A 1 $1 | grep -E -o "([0-9]{1,3}[\.]){3}[0-9]{1,3}" > ns.log
chk_res=`ls -l ns.log | awk '{ print $5 }'`
if [ $chk_res -eq 0 ]
then
	rm ns.log
else
	mv ns.log 'ns'$1'.log'
fi
if [ ! -f 'ns'$1'.log' ]
then
	touch 'ns'$1'.log'
else
	cat 'ns'$1'.log'
fi
