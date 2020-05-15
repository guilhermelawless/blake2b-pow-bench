#!/bin/bash

multiplier=${1:-"1.0"}
N=${2:-50}
worker=${3:-"127.0.0.1:7076"}
use_peers=${4:-"true"}

printf "\n${N} requests @ ${multiplier} multiplier\nworker at ${worker}"
if [ $use_peers = "true" ]; then
  printf " using work peers"
fi
printf "\n\n"

function pow {
  hash=`cat /dev/urandom | LC_CTYPE=C tr -dc 'A-E0-9' | fold -w 64 | head -n 1`
  curl $worker -s -d """{\"action\":\"work_generate\", \"hash\":\""${hash}"\", \"multiplier\": \""${multiplier}"\", \"use_peers\": \"${use_peers}\"}""" > /dev/null
}

function run () {
  for i in `seq $1`; do
    pow;
    if [ $? -eq 0 ]; then
        printf "$i ";
    else
        printf "ERROR: Worker not found\n\n"
        exit 1
    fi
  done
  printf "\n\n"
}

START=$(date +%s)
run $N
END=$(date +%s)
DIFF=`expr $END - $START`

echo "Took $DIFF seconds"
