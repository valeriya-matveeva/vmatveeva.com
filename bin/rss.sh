#!/bin/bash

remove_nbsp() {
	sed 's#\&nbsp;# #g'
}

date_rfc_822() {
        if [[ "$OSTYPE" == "darwin"* ]]; then
                date -j '+%a, %d %b %Y %H:%M:%S %z'
        else
                date '+%a, %d %b %Y %H:%M:%S %z'
        fi
}

date_to_rfc_822() {
        if [[ "$OSTYPE" == "darwin"* ]]; then
                date -f "%Y-%m-%dT%H:%M:%SZ" -j '+%a, %d %b %Y %H:%M:%S %z' "$1T00:00:00Z"
        else
                date '+%a, %d %b %Y %H:%M:%S %z' -d "$1T00:00:00Z"
        fi
}

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

list_items() {
	DIR="$1"

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

		echo "$FDATE $PAGE $SUBJECT"
	done	
	popd > /dev/null
}

render_item() {
	base_url="$1"
	item="$2"

	site_url="$(echo "$base_url"| sed 's#\(.*//.*\)/.*#\1#')"

	date=$(echo "$item"|awk '{print $1}')
	url=$(echo "$item"|awk '{print $2}')
	title=$(echo "$item"| cut -d ' ' -f 3- )

	guid="$base_url/$(echo "$url" | sed 's#^/##')"

	cat <<-EOF
		<item>
		<guid>$guid</guid>
		<link>$guid</link>
		<pubDate>$(date_to_rfc_822 "$date")</pubDate>
		<title>$title</title>
		</item>

	EOF
}

render_items() {
	base_url="$1"

	while read -r i
	do render_item "$1" "$i"
	done
}

render_feed() {
	url="$1"
	title=$(echo "$2" | remove_nbsp)
	description="$3"

	base_url="$(echo "$url" | cut -d '/' -f1-3)"

	cat <<-EOF
		<?xml version="1.0" encoding="UTF-8"?>
		<rss version="2.0" xmlns:atom="http://www.w3.org/2005/Atom">
		<channel>
		<atom:link href="$url" rel="self" type="application/rss+xml" />
		<title>$title</title>
		<description>$description</description>
		<link>$base_url/</link>
		<lastBuildDate>$(date_rfc_822)</lastBuildDate>
		$(cat)
		</channel></rss>
	EOF
}

list_items "$1" | sort | render_items "$2$3" | render_feed "$2" "Valeriya Matveeva" "Valeriya Matveeva's personal site"
