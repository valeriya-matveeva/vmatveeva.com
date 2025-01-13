#!/bin/bash

expand() {
	TITLE="$1"
	cat <<-"EOF"
<html lang="en">
  <head>
<!-- Google Tag Manager -->
<script>(function(w,d,s,l,i){w[l]=w[l]||[];w[l].push({'gtm.start':
new Date().getTime(),event:'gtm.js'});var f=d.getElementsByTagName(s)[0],
j=d.createElement(s),dl=l!='dataLayer'?'&l='+l:'';j.async=true;j.src=
'https://www.googletagmanager.com/gtm.js?id='+i+dl;f.parentNode.insertBefore(j,f);
})(window,document,'script','dataLayer','GTM-WKVVNZ8F');</script>
<!-- End Google Tag Manager -->

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
<!-- Google Tag Manager (noscript) -->
<noscript><iframe src="https://www.googletagmanager.com/ns.html?id=GTM-WKVVNZ8F"
height="0" width="0" style="display:none;visibility:hidden"></iframe></noscript>
<!-- End Google Tag Manager (noscript) -->
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
