#!/bin/bash

set -e

get_header() {
	HFILE="$1"
	HEADER="$2"

	FILTER="{ \
		if (match(\$0, /^$HEADER: /)) {print substr(\$0, RLENGTH+1, length(\$0) - RLENGTH)}; \
		if (\$0~/^$/) {exit}; \
		if (!\$0~/^[^ ]*: .*$/) {exit}; \
	}"

	awk "$FILTER" "$HFILE"
}

render() {
	NODATE="$1"
	DIR="$2"
	BASE="$3"

	pushd "$DIR" > /dev/null
	find . ! -path . -type d  | while read -r FN
	do
		PAGE="$(echo "$FN" | sed 's/^\.\///g')"
		#echo "FILE: $PAGE"

		MD="$PAGE/note.md"
		if [ ! -f "$MD" ]; then
			echo "$MD doesn't exist"
			exit 1;
		fi

		SUBJECT="$(get_header "$MD" "Subject")"
		FDATE="$(get_header "$MD" "X-Date" | sed 's/T.*$//g')"

		if [ -z "$SUBJECT" ]; then
			echo "No subject in $MD"
			exit 1
		fi

		if [ -z "$FDATE" ] && [ "$NODATE" == "0" ]; then
			echo "No date in $MD"
			exit 1
		fi

		if [ -z "$FDATE" ]; then
			echo "* [$SUBJECT]($BASE/$PAGE)"
		else

			echo "* $FDATE [$SUBJECT]($BASE/$PAGE)"
		fi
	done	
	popd > /dev/null

}

NODATE=0
if [ "$1" == "--nodate" ]; then
	NODATE=1
	shift
fi

if [ ! -d "$1" ]; then
	echo "Missing source directory"
	exit 1
fi

render "$NODATE" "$1" "$2" | sort -r 
