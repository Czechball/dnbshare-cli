# dnbshare-cli

A set of simple scripts for downloading files from [dnbshare.com](https://dnbshare.com/).

## Dependencies:

- curl

## Usage:  
### dnbshare-download.sh
Downloads uploaded file directly from a single dnbshare.com url

```sh
./dnbshare-download.sh <url> (-d directory)
```

#### Options:

* -d - directory to download to, optional - will be created if doesn't exist
* -h - show help

#### Examples:

```sh

./dnbshare-download.sh https://dnbshare.com/download/Phadix_Neil_Badboy_-_Believe_final.mp3.html
```

* download mp3 file from given url

```sh
./dnbshare-download.sh -d ~/Music https://dnbshare.com/download/Phadix_Neil_Badboy_-_Believe_final.mp3.html
```

* download mp3 file from given url in ~/Music will be created if doesn't exist

### get-dnblist.sh
Downloads all files from a dnbshare.com query. Files will be saved in a directory named after the query and current date (for example Latest-2020-12-07/)

```sh
./get-dnblist.sh <-s (string) / -l / -t / -p / -o / -h>
```

#### Options:

* -s (string) - search dnbshare.com for string and download results
* -l - download all files from the Latest page
* -t - download all files from the Trending page
* -p - download all files from the Popular page
* -o - download all files from the Top page
* -h - show help

#### Examples:

```sh
./get-dnblist.sh -p
```

* download all files from the Popular page and save them into ./Latest-YYYY-MM-DD/

```sh
./get-dnblist.sh -s Shadow
```

* search for "Shadow" and download all results into ./Search-Shadow.YYYY-MM-DD/