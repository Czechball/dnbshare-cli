#!/bin/bash

#Get file info url list from dnbshare.com

# -- VARIABLES --

# Set current date in ISO 8601 format for directory names
DATE=$(date --iso-8601)

# -- CODE --

# Check if arguments are supplied
if [[ $* == "" ]]; then
  echo "Missing arguments, use -h for help"
  exit
fi

# Parse arguments s, l, t, p, o, h and invalid cases
while getopts "s: l t p o h *:" arg; do
  case ${arg} in
    s )
        QUERY="$OPTARG"
        MODE="filter=$QUERY"
        NAME="Search-$QUERY.$DATE"
    ;;
    l )
        MODE="latest=1"
        NAME="Latest-$DATE"
    ;;
    t )
        MODE="trending=1"
        NAME="Trending-$DATE"
    ;;
    p )
        MODE="popular=1"
        NAME="Popular-$DATE"
    ;;
    o )
        MODE="top=1"
        NAME="Top-$DATE"
    ;;
    h )
        echo "get-dnblist by Czechball, part of dnbshare-cli"
        echo "https://github.com/Czechball/dnbshare-cli"
        echo
        printf "Usage:\n  %s <argument> (search query)\n\
Example:\n\
  %s -l (this will download all uploads from the Latest page)\n\
All available options:\n\
  -s <string> - search dnbshare for <string> and download matching uploads\n\
  -l          - download all uploads from the Latest page\n\
  -t          - download all uploads from the Trending page\n\
  -p          - download all uploads from the Popular page\n\
  -o          - download all uploads from the Top page\n\
  -h          - show this screen and exit"\
        "$0" "$0"
        echo
        exit
    ;;
  \? )
        echo "Invalid argument. Use -h for help"; exit
    ;;
    * )
        echo "Invalid argument. Use -h for help"; exit
    ;;
  esac
done
shift $((OPTIND -1))

# Sanity check if mode is set, else exit
if [[ $MODE == "" ]]; then
  echo -e "\e[91mError: No download mode spcified\e[0m"
  exit
fi

# Get contents of the file list directly, as seen on for example https://dnbshare.com/download/?list=latest
# This is done by accessing ajax_filelisting.php
PAGE_CONTENT=$(curl -s 'https://dnbshare.com/ajax/ajax_filelisting.php' \
  -H 'authority: dnbshare.com' \
  -H 'accept: text/html, */*; q=0.01' \
  -H 'x-requested-with: XMLHttpRequest' \
  -H 'user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/86.0.4240.198 Safari/537.36' \
  -H 'content-type: application/x-www-form-urlencoded; charset=UTF-8' \
  -H 'origin: https://dnbshare.com' \
  -H 'sec-fetch-site: same-origin' \
  -H 'referer: https://dnbshare.com/download/' \
  --data-raw "$MODE")

# Inserting link list into an array using mapfile
mapfile -t LINKS < <(echo "$PAGE_CONTENT" | grep -Po 'class="file"><a href="\K[^"]+')

# Getting comment on ajax_filelisting.php, shows info about when was the list last updated
PAGE_COMMENT=$(echo "$PAGE_CONTENT" | grep -Po '<!-- \K[^>]+')
PAGE_INFO=${PAGE_COMMENT%--}

# Checking if comment exists and printing it (it's not included on the search query page)
if [[ $PAGE_INFO != "" ]]; then
  echo -e "Info: \e[92m$PAGE_INFO\e[0m"
fi

# Checking if link list is empty
if [[ $LINKS == "" ]]; then
  echo -e "\e[91mError: Query returned no results\e[0m"
  exit
fi

# Iterating through file list and calling ./dnbshare-download.sh to download the files
C=1
for FILE in "${LINKS[@]}"; do
  FILENAME=${FILE:10:-5}
  echo "Downloading file $C/${#LINKS[@]}"
  # Checking if file already exists, skip download if it does
  if test -f "$NAME/$FILENAME"; then
    echo "$FILENAME already exists, skipping"
    C=$((C + 1))
  else
    ./dnbshare-download.sh "https://dnbshare.com$FILE" "$NAME"
    C=$((C + 1))
  fi
done

echo -e "\e[92mAll done!\e[0m"