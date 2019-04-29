#!/bin/bash

echo "$LOG_HEADER [INFO] $HPACK_NAME for Project Management Starting..."

CMD_OPT=start

if [ "x$1" != "x" ]; then
  CMD_OPT=$1
fi

if [ "x$CMD_OPT" == "xstart" ]; then
  sudo nginx
elif [ "x$CMD_OPT" == "xrestart" ]; then
  sudo nginx -s reload
else
  sudo nginx -s $CMD_OPT
fi

mysql.server $CMD_OPT
httpd -DFOREGROUND
