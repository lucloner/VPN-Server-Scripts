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
	exit 0
fi
echo 'oldip:'$oldip', newip:'$newip
if [ "$oldip" = "$newip" ]
then
	echo $1' is not changed! do nothing.'
else
	echo $1' is changed! changing route.'
	if [ ! "$oldip" = "" ]
	then
		#route del -host $oldip gw 172.19.172.253
		sh /root/testroute.sh checkdns.log del
	fi
	#route add -host $newip gw 172.19.172.253
	sh /root/testroute.sh 'ns'$1'.log' add
fi
rm checkdns.log
