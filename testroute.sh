cat $1 | while read line
do
	if [ ! "$line" = "" ]
	then
		echo "doing route "$2" -host "$line" gw 172.19.172.253"
		route "$2" -host "$line" gw 172.19.172.253
	fi
done
