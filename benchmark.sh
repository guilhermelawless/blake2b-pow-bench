#!/bin/bash


multiplier=${1:-"1.0"}
N=${2:-50}
worker=${3:-"[::1]:7076"}
hash=`cat /dev/urandom | tr -dc 'A-E0-9' | fold -w 64 | head -n 1`

printf "\n${N} requests @ ${multiplier} multiplier\nworker at ${worker}\n\n"

function pow {
  curl $worker -s -d """{\"action\":\"work_generate\", \"hash\":\""${hash}"\", \"multiplier\": \""${multiplier}"\"}""" > /dev/null
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

START=$(date +%s.%N)
run $N
END=$(date +%s.%N)
DIFF=$(echo "$END - $START" | bc)

echo "Took $DIFF seconds"
