#!/bin/bash

#Download files from dnbshare.com

if [[ $* == "" ]]; then
	echo "Usage: $0 <url> [options] (-h for help)"
	exit
fi

DIRECTORY="$2"

while getopts ":d:" arg; do
  case $arg in
    d) DIRECTORY="$OPTARG";;
  esac
done

if [[ $* == "-h" ]]; then
	echo "dnbshare-download by Czechball, part of dnbshare-cli"
	echo "https://github.com/Czechball/dnbshare-cli"
	echo
	printf "Usage:\n	%s <url>\nExample:\n	%s -d ~/Music https://dnbshare.com/download/Tsuki_Subsonic_-_Messiah_Madge_VIP_FREE_DOWNLOAD.mp3.html\n" "$0" "$0"
	echo
	exit
fi

URL="$1"
PAGE_CONTENT=$(curl -s "$URL")
DLFORM_FILENAME=$(echo "$PAGE_CONTENT" | grep -Po 'dlform-file" value="\K[^"]+')
DLFORM_PAYLOAD=$(echo "$PAGE_CONTENT" | grep -Po 'dlform-payload" value="\K[^"]+')
FILE_URL="$1?file=$DLFORM_FILENAME&payload=$DLFORM_PAYLOAD"
mkdir -p "$DIRECTORY"

if [[ DIRECTORY == "" ]]; then
	wget --content-disposition -q --show-progress "$FILE_URL"
else
	wget --content-disposition -q --show-progress -P "$DIRECTORY" "$FILE_URL"
fi
