#!/bin/bash

OPTS="-l 10000 -t 10000"

runtest() {
  echo "Method: $1"
  time ./writeperf $OPTS $1 > test
  md5sum test
  rm test
  echo ""
}

runtest write
runtest fwrite
runtest fwrite-line
runtest fwrite-full
runtest writev
