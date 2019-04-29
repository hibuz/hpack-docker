#!/bin/bash

if [ "x$1" = "x" ]; then
  echo "$LOG_HEADER[ERROR] Usage: $0 <ProjectName>"
elif [ -d "$HPACK_PRJ_SVN/$1" ]; then
  echo "$LOG_HEADER [WARN] $1 Subversion project already exist."
else

  svnadmin create --fs-type=fsfs "$HPACK_PRJ_SVN/$1"
  svn mkdir -m "initial import" file:///$HPACK_PRJ_SVN/$1/trunk file:///$HPACK_PRJ_SVN/$1/branches file:///$HPACK_PRJ_SVN/$1/tags file:///$HPACK_PRJ_SVN/$1/releases 
  if [ -d "$HPACK_PRJ_SVN/$1" ]; then
    echo "$LOG_HEADER [INFO] Subversion repository [$1] created."
  fi
fi
