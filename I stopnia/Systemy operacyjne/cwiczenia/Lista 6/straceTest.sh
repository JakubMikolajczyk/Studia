#!/bin/bash

OPTS="-l 100 -t 100"

runtest() {
  echo "Method: $1"
  strace -c ./writeperf $OPTS $1 > test
  md5sum test
  rm test
  echo ""
}

runtest write
runtest fwrite
runtest fwrite-line
runtest fwrite-full
runtest writev
