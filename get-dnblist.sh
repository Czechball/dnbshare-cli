curl 'https://dnbshare.com/ajax/ajax_filelisting.php' \
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
  --data-raw 'latest=1'
# latest: 'latest=1'
# search: 'filter=string'
# trending: 'trending=1'
# popular: 'popular=1'
# top: 'top=1'