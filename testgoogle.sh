if [ -f "testgoogle.tag" ]
then
	echo test already running!
	exit 1
fi
touch testgoogle.tag
echo nameserver 8.8.8.8 > /etc/resolv.conf
ping -c 10 www.google.com
if [ $? -eq 0 ]
then
	echo pingok
	ping -c 10 t66y.com
	if [ $? -eq 0 ]
	then
        	echo pingok2
		rm /root/testgoogle.log
	else
	        echo ping t66y failed vpn maybe off
	        expressvpn disconnect
	        sh /root/testvpn.sh > /root/testvpn.log
	        cat /root/testvpn.log
        	echo vpn running done
	fi
else
	echo ping google failed vpn maybe off
	expressvpn disconnect
	sh /root/testvpn.sh > /root/testvpn.log
	cat /root/testvpn.log
	echo vpn running done
	expressvpn refresh
fi
rm testgoogle.tag
sh /root/testddns.sh > testddns.log
echo test shutdown
