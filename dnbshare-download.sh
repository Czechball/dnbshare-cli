#!/bin/bash

#Download files from dnbshare.com

URL="$1"
PAGE_CONTENT=$(curl "$URL")
DLFORM_FILENAME=$(echo "$PAGE_CONTENT" | grep -Po 'file" value="\K[^"]+')
DLFORM_PAYLOAD=$(echo "$PAGE_CONTENT" | grep -Po 'payload" value="\K[^"]+')

FILE_URL="$1?file=$DLFORM_FILENAME&payload=$DLFORM_PAYLOAD"

wget --content-disposition "$FILE_URL"