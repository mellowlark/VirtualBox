#!/bin/bash

bigthree () {
  for i in ctlnode node-0 node-1; do
   echo ssh $i sudo shutdown now
    done
}

all () {
  bigthree
 echo ssh base shutdown now
}

ans=$1
echo $ans
function runfun {
	echo found it

if [[ "$ans" = "all" ]]
  then
    all
  elif [[ "$ans" = "kthw" ]]
  then
    bigthree
  else
  printf "wrong "
  sleep 1
  printf "Wrong "
  sleep 1
  printf "WRONG!!!!!\n\n"
  sleep 1
  fi
}

runfun
