#!/bin/bash

expand() {
	TITLE="$1"
	cat <<-"EOF"
<html lang="en">
  <head>
<script async src="https://www.googletagmanager.com/gtag/js?id=G-NNVCQZB6LN"></script>
<script>
  window.dataLayer = window.dataLayer || [];
  function gtag(){dataLayer.push(arguments);}
  gtag('js', new Date());

  gtag('config', 'G-NNVCQZB6LN');
</script>

	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<meta charset="UTF-8">
	<link rel="stylesheet" type="text/css" href="/style.css">
	<title>
	EOF

	echo "      $TITLE"

	cat <<-"EOF"
	</title>
	<link rel="alternate" type="application/rss+xml"
		title="RSS Feed for vmatveeva.com" href="/rss.xml" />
	<link rel="icon" href="/favicon.ico" type="image/x-icon" />
	<link rel="shortcut icon" href="/favicon.ico" type="image/x-icon" />
  </head>
  <body>
	<div id="header">
	  <a href="/">Valeriya Matveeva</a>
	</div>
	<div id="menu">
		<a href="/">home</a>
		<a href="/contact">contact</a>
	</div>
	<div id="content">
EOF
	cat
	cat <<-"EOF"
	</div>
  </body>
</html>
	EOF
}

if [ -z "$1" ]; then
	echo "Missing page title"
	exit 1
fi

if [ -z "$2" ] && [ -t 0 ]; then
	echo "Missing page body"
	exit 1
fi

if [ ! -t 0 ]; then
	expand "$1"
	exit 0
fi

expand "$1" < "$2"
