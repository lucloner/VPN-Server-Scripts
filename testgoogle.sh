#!/bin/sh
ret=0
testns(){
	ret=0
	vpn_stat=0
	ip=`sh /root/testip0.sh $1 8.8.8.8 | sed -n 1p`
	ping -c 10 $ip
	if [ $? -eq 0 ]
	then
		echo 'ping '$1' ok'
		rm test*.tag
		expressvpn refresh
		return 0
	else
		ret=1
		echo ping $1 failed vpn maybe off
		testconn
		vpn_stat=$?
		if [ $vpn_stat -eq 0 ]
		then
			echo nameserver 8.8.8.8 > /etc/resolv.conf
		fi
		if [ $vpn_stat -eq 1 ]
		then
			expressvpn status
			rm testgoogle.tag
			exit 0
		fi
		if [ ! -f 'test'$1'.tag' ]
		then
    	touch 'test'$1'.tag'
			return 1
		else
			echo lookup for status
			tags=`ls -l test*.tag  |grep "^-"|wc -l`
			if [ $tags -ge 3 ]
			then
				echo all failed disconnecting
				expressvpn disconnect
				if [ $vpn_stat -le 1 ]
				then
					expressvpn connect
				fi
			fi
			if [ $vpn_stat -ge 2 ]
			then
				rm test*.tag
				sh /root/testvpn.sh > /root/testvpn.log
				cat /root/testvpn.log
				rm testgoogle.tag
				exit 0
			fi
		fi
		echo vpn running done
	fi
	if [ $vpn_stat -eq 4 ]
	then
			rm test*.tag
	fi
}

testconn(){
	chk_vpn=`expressvpn status | grep 'Connected to'`
	if [ ! -z "$chk_vpn" ]
	then
		echo '0:'$chk_vpn
		return 0
	else
		expressvpn status 2> expressvpn.log
		chk_vpn=`cat expressvpn.log | grep 'Unable to connect'`
		if [ ! -z "$chk_vpn" ]
		then
			echo '1:'$chk_vpn
			return 3
		fi
	fi
	chk_vpn=`expressvpn status | grep 'onnecting'`
	if [ ! -z "$chk_vpn" ]
	then
		echo '4:'$chk_vpn
		return 1
	fi
	chk_vpn=`expressvpn status | grep 'Not connected'`
	if [ ! -z "$chk_vpn" ]
	then
		echo '5:'$chk_vpn
		return 5
	fi
	chk_vpn=`expressvpn status | grep 'onnect'`
	if [ ! -z "$chk_vpn" ]
	then
		echo '2:'$chk_vpn
		return 4
	fi
	return 2
}

if [ -f "testgoogle.tag" ]
then
	echo test already running!
	expressvpn diagnostics
	sh /root/testddns.sh
	exit 1
fi
touch testgoogle.tag
testns www.google.com
testns www.facebook.com
testns www.twitter.com
testns t66y.com
rm testgoogle.tag
#sh /root/testddns.sh > testddns.log
echo test shutdown
