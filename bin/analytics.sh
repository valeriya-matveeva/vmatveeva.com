#!/bin/bash


#awk -v today="$TODAY" '{print today}'

present() {
        grep "$TODAY" | grep GET | awk '($9 !~ /404/)' | awk '{print $7}' | sed 's/\?.*$//g' | grep -v -E "\.php|\.xml|http:|acme-challenge" | sed 's:\(.\)/$:\1:' | sort | uniq -c | sort -rn
}

if [ "$1" == "--today" ]; then
	TODAY="$(date "+%d/%b/%Y")"
	shift
else
	TODAY=""
fi

if [ -z "$1" ]; then
	LOGFILE="/var/log/nginx/access.log"
else
	LOGFILE="$1"
fi

if [ -t 0 ] && [ ! -f "$LOGFILE" ]; then
	echo "Logfile doesn't exist: $LOGFILE"
	exit 1
fi

if [ ! -t 0 ]; then
        present
else
        present < "$LOGFILE"
fi
