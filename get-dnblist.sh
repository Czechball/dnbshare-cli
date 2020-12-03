#!/bin/bash

#Get file info url list from dnbshare.com

DATE=$(date --iso-8601)

if [[ $* == "" ]]; then
  echo "Error: Specify a list to download"
  echo "Usage: $0 <-l/-t/-p/-o/-s string>"
  exit
fi

while getopts ":s:*:" arg; do
  case $arg in
    s) QUERY="$OPTARG";;
    *) SINGLE_OPTS="$OPTARG";;
  esac
done

case $SINGLE_OPTS in
    l)
        MODE="latest=1"
        NAME="Latest-$DATE";;
    t)
        MODE="trending=1"
        NAME="Trending-$DATE";;
    p)
        MODE="popular=1"
        NAME="Popular-$DATE";;
    o)
        MODE="top=1"
        NAME="Top-$DATE";;
esac

if [[ $1 == "-s" ]]; then
  MODE="filter=$QUERY"
  NAME="Search-$QUERY.$DATE"

fi

echo "$NAME"

PAGE_CONTENT=$(curl -s 'https://dnbshare.com/ajax/ajax_filelisting.php' \
  -H 'authority: dnbshare.com' \
  -H 'accept: text/html, */*; q=0.01' \
  -H 'x-requested-with: XMLHttpRequest' \
  -H 'user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/86.0.4240.198 Safari/537.36' \
  -H 'content-type: application/x-www-form-urlencoded; charset=UTF-8' \
  -H 'origin: https://dnbshare.com' \
  -H 'sec-fetch-site: same-origin' \
  -H 'sec-fetch-mode: cors' \
  -H 'sec-fetch-dest: empty' \
  -H 'referer: https://dnbshare.com/download/' \
  --data-raw "$MODE")

mapfile -t LINKS < <(echo "$PAGE_CONTENT" | grep -Po 'class="file"><a href="\K[^"]+')

PAGE_COMMENT=$(echo "$PAGE_CONTENT" | grep -Po '<!-- \K[^>]+')
PAGE_INFO=${PAGE_COMMENT%--}

echo -e "\e[92m$PAGE_INFO\e[0m"

C=1
for FILE in ${LINKS[@]}; do
  echo "Downloading file $C/${#LINKS[@]}"
  if (test $FILE); then
    echo "$FILE already exists, skipping"
    C=$(expr $C + 1)
  else
    ./dnbshare-download.sh "https://dnbshare.com$FILE" "$NAME"
    C=$(expr $C + 1)
  fi
done