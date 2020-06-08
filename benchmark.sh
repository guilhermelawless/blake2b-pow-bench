#!/bin/bash

if test "$#" -lt 3; then
  echo "Usage: $0 multiplier N worker_uri [use_peers=true] [simultaneous_processes=1]"
  exit
fi

multiplier=${1:-"1.0"}
N=${2:-50}
worker=${3:-"127.0.0.1:7076"}
use_peers=${4:-"true"}
M=${5:-1}

if (( N < 20 || N % M )); then
  printf "N must be at least 20, and a multiple of $M"
  exit
fi
printf "\n${N} requests @ ${multiplier} multiplier with ${M} simultaneous processes\nworker at ${worker}"
if [ $use_peers = "true" ]; then
  printf " using work peers"
fi
printf "\n\n"

function pow {
  hash=`cat /dev/urandom | LC_CTYPE=C tr -dc 'A-E0-9' | fold -w 64 | head -n 1`
  curl $worker -s -d """{\"action\":\"work_generate\", \"hash\":\""${hash}"\", \"multiplier\": \""${multiplier}"\", \"use_peers\": \"${use_peers}\"}""" > /dev/null
}

function one_run () {
  for i in `seq $1`; do
    pow;
    if [ $? -eq 0 ]; then
      printf ".";
    else
      printf "ERROR: Worker not found\n\n"
      exit 1
    fi
  done
}

function run () {
  par=$(($1 / $M))
  if ((M == 1)) ; then
    one_run $par 1
  else
    for i in `seq $M`; do
      one_run $par $i &
      # store pid in array to wait later
      pids[${i}]=$!
    done
    # wait for all pids
    for pid in ${pids[*]}; do
      wait $pid
    done
  fi

  printf "\n\n"
}

START=$(date +%s)
run $N
END=$(date +%s)
DIFF=`expr $END - $START`

echo "Took $DIFF seconds"
