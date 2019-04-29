#!/bin/bash

if [ "x$1" = "x" ]; then
  echo "$LOG_HEADER[ERROR] Usage: $0 <ProjectName>"
elif [ -d "$HPACK_PRJ_GIT/$1.git" ]; then
  echo "$LOG_HEADER [WARN] $1 Git repository already exist."
else

  git init --bare "$HPACK_PRJ_GIT/$1.git"
  echo "_" > $HPACK_PRJ_GIT/$1.git/git-daemon-export-ok
  echo "$LOG_HEADER [INFO] Git repository [$1] created."
fi
