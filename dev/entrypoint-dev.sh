#!/bin/bash

echo "$LOG_HEADER [INFO] $HPACK_NAME for DevOps Starting..."

sudo nginx -s stop
sudo nginx -c $HPACK_NGINX/conf/nginx-dev.conf

cd $HPACK_WS/ruby/hello && rails server -d -p 3000
cd $HPACK_WS/python/hello && python manage.py runserver 0:3001 > /dev/null &
cd $HPACK_WS/eclipse/hello && export SERVER_PORT=3002 && \
  $SDKMAN_DIR/candidates/gradle/current/bin/gradle bootRun > /dev/null &
cd $GOPATH && revel run hibuz.com/hpack/hello dev 3003 > /dev/null &
cd $HPACK_WS/node/hello && ng serve --host 0.0.0.0 --port 3004 > /dev/null &
if [ ! -d "$HPACK_WS/php/hello" ]; then
  cd $HPACK_WS/php && laravel new hello
fi
cd $HPACK_WS/php/hello && php artisan serve --host 0.0.0.0 --port 3005 > /dev/null &

cd $HPACK_ELASTIC/utils/elasticsearch-head && grunt server

