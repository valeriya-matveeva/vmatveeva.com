#!/bin/bash

set -e

render() {
	NOTITLE="$1"
	LASTLINE=""
	TITLE=""

	while read -r line ; do
		if [[ "$line" =~ ^Subject:\ .*$ ]]; then
			TITLE="${line#* }"
		fi
		if [[ ! "$line" =~ ^[^\ ]*:\ .*$ ]]; then
			LASTLINE="$line"
			break
		fi
	done

	{
		[ "$NOTITLE" == "0" ] && echo "# $TITLE";
		echo "$LASTLINE";
		cat
	} | awk -f ./bin/markdown.awk | ./bin/page.sh "$TITLE"

}

NOTITLE=0

if [ "$1" == "--notitle" ]; then
	NOTITLE=1
fi

if [ -t 0 ]; then
	echo "Missing Markdown body"
	exit 1
fi

render "$NOTITLE"
