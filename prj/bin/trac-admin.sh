#!/bin/bash

if [ "x$1" = "x" ]; then
  echo "$LOG_HEADER [ERROR] Usage: $0 <ProjectName> <Commands>"
  exit
fi

trac-admin $HPACK_PRJ_TRAC/$1 $2 $3 $4 $5 $6
