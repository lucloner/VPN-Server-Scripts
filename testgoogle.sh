#!/bin/sh
ret=0
testns(){
	ret=0
	ip=`sh /root/testip0.sh $1 8.8.8.8 | sed -n 1p`
	ping -c 10 $ip
	if [ $? -eq 0 ]
	then
		echo pingok
		return 0
	else
		echo ping $1 failed vpn maybe off
		expressvpn disconnect
		sh /root/testvpn.sh > /root/testvpn.log
		cat /root/testvpn.log
		echo vpn running done
		ret=1
	fi
}

if [ -f "testgoogle.tag" ]
then
	echo test already running!
	exit 1
fi
touch testgoogle.tag
testns www.google.com
if [ $ret -eq 0 ]
then
	if [ ! -f testt66y.tag ]
	then
		touch testt66y.tag
	else
		rm testt66y.tag
		testns t66y.com
	fi
fi
expressvpn refresh
rm testgoogle.tag
sh /root/testddns.sh > testddns.log
echo test shutdown
