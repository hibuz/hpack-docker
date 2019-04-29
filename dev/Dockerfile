FROM hibuz.com/cid:1.0.13

MAINTAINER @hibuz


##### define default environments
# apps
ENV GOROOT $HPACK_APPS/go
ENV NODE_PATH $HPACK_APPS/node
ENV HPACK_RUBY $HPACK_APPS/ruby
ENV HPACK_MONGO $HPACK_APPS/mongo
ENV HPACK_REDIS $HPACK_APPS/redis
ENV HPACK_ELASTIC $HPACK_APPS/elastic
ENV KAFKA_HOME $HPACK_APPS/kafka

# data
ENV HPACK_DB_MONGO $HPACK_DB/mongo
ENV HPACK_DB_REDIS $HPACK_DB/redis
ENV HPACK_DB_ELASTIC $HPACK_DB/elastic
ENV HPACK_WS $HPACK_DATA/workspace
ENV GOPATH $HPACK_WS/go

# etc
ENV BUNDLE_APP_CONFIG $XDG_CONFIG_HOME/ruby
ENV GEM_SPEC_CACHE $XDG_CACHE_HOME/gem
ENV LD_LIBRARY_PATH $LD_LIBRARY_PATH:$HPACK_RUBY/lib

ENV PATH $PATH:$GOROOT/bin:$GOPATH/bin:$NODE_PATH/bin:$HPACK_RUBY/bin


##### install dependencies
RUN sudo apt-get update && sudo apt-get install -y bash-completion libgdbm-dev libffi-dev libreadline6-dev


##### go #####   https://golang.org/doc/devel/release.html
#go1.7.4 (released 2016/12/01)
RUN APP=go1.7.4.linux-amd64 && \
  wget https://storage.googleapis.com/golang/$APP.tar.gz && tar xf $APP.tar.gz && rm $APP.tar.gz

RUN go get github.com/revel/cmd/revel github.com/tools/godep


##### nodejs #####     https://nodejs.org/en/blog/
#05 Jan Node v6.9.4 (LTS)
RUN APP_VER=6.9.4 && APP=node-v$APP_VER-linux-x64 && \
  wget https://nodejs.org/dist/v$APP_VER/$APP.tar.xz && tar xf $APP.tar.xz && mv $APP $NODE_PATH && rm $APP.tar.xz && \
  cd $NODE_PATH/lib && ln -s node_modules node && npm config set cache $NODE_PATH/tmp --global && npm i -g express angular-cli grunt && npm cache clean


##### Ruby frameworkd:Rails build:RubyGems #####     https://www.ruby-lang.org/en/
#Ruby 2.4.0 Released 25 Dec 2016
RUN \
  wget http://jaist.dl.sourceforge.net/project/tcl/Tcl/8.5.19/tcl8.5.19-src.tar.gz && tar xf tcl8.5.19-src.tar.gz && \
  cd tcl8.5.19/unix && ./configure --enable-threads && make && sudo make install && \
  wget http://jaist.dl.sourceforge.net/project/tcl/Tcl/8.5.19/tk8.5.19-src.tar.gz && tar xf tk8.5.19-src.tar.gz && \
  cd tk8.5.19/unix && ./configure --enable-threads && make && sudo make install && rm -rf $HPACK_APPS/tcl*

RUN APP_VER=2.4 && APP=ruby-$APP_VER.0 && \
  wget https://cache.ruby-lang.org/pub/ruby/$APP_VER/$APP.tar.gz && tar xf $APP.tar.gz && cd $APP && \
  ./configure --prefix=$HPACK_RUBY && make && make install && \
  rm -rf $HPACK_APPS/$APP*

RUN gem install rails && gem update --system && gem update -f


##### python framework:Django #####     https://www.djangoproject.com/download/
#1.10.5 December 1, 2016
RUN pip install virtualenv django


##### php framework:Laravel #####     https://laravel-news.com/
#Laravel v5.3.19 OCT 18, 2016
RUN composer global require "laravel/installer"


##### spring boot #####     https://spring.io/blog/category/releases
#1.4.3.RELEASE 12/23, 2016
RUN \
  /bin/echo "y" | $SDKMAN_DIR/bin/sdkman.sh install springboot && \
  echo "source $SDKMAN_DIR/candidates/springboot/current/shell-completion/bash/spring" >> ~/.bashrc


##### mongodb #####     https://www.mongodb.com/download-center#community
# 3.4.1 Dec 20, 2016
RUN APP=mongodb-linux-x86_64-ubuntu1604-3.4.1 && \
  wget https://fastdl.mongodb.org/linux/$APP.tgz && tar xf $APP.tgz && mv $APP $HPACK_MONGO && rm $APP.tgz


##### Redis #####     http://redis.io/download
#Redis 3.2.6  Tue Dec 06
RUN APP=redis-3.2.6 && \
  wget http://download.redis.io/releases/$APP.tar.gz && tar xf $APP.tar.gz && mv $APP $HPACK_REDIS && cd $HPACK_REDIS && make && \
  sed -i 's/^\(bind .*\)$/# \1/' redis.conf && \
  sed -i 's/^\(daemonize .*\)$/# \1/' redis.conf && \
  sed -i 's@^\(dir .*\)$@# \1\ndir '"$HPACK_DB_REDIS"'/@' redis.conf && \
  sed -i 's@^\(logfile .*\)$@# \1\nlogfile '"$HPACK_REDIS"'/logs/redis.log@' redis.conf && \ 
  mv src bin && rm $HPACK_APPS/$APP*


##### elasticsearch #####     https://www.elastic.co/downloads/elasticsearch
#5.1.2 January 12, 2017
RUN APP=elasticsearch-5.1.1 && \
  wget https://artifacts.elastic.co/downloads/elasticsearch/$APP.tar.gz && tar xf $APP.tar.gz && mv $APP $HPACK_ELASTIC && rm $APP.tar.gz && \
  sed -i 's@#path.data: /path/to/data@path.data: '"$HPACK_DB_ELASTIC"'@g' elastic/config/elasticsearch.yml && \ 
  mkdir $HPACK_ELASTIC/utils && cd $HPACK_ELASTIC/utils && git clone git://github.com/mobz/elasticsearch-head.git && cd elasticsearch-head && npm install


##### Kafka #####      http://kafka.apache.org/downloads
RUN VER=0.10.1.1 && APP=kafka_2.11-$VER && \
  wget http://mirror.apache-kr.org/kafka/$VER/$APP.tgz && tar xf $APP.tgz && mv $APP $KAFKA_HOME && \
  rm $HPACK_APPS/$APP*


##### add files
ADD entrypoint* /
ADD bin $HPACK_HOME/bin
ADD apps $HPACK_APPS
ADD data $HPACK_DATA
RUN sudo chown -R $HPACK_USER:$HPACK_USER $HPACK_HOME/bin $HPACK_NGINX $HPACK_DATA_NGINX /entrypoint* && chmod +x /entrypoint*
RUN mkdir -p $HPACK_DB_MONGO $HPACK_DB_REDIS $HPACK_DB_ELASTIC && \
    mkdir -p $HPACK_MONGO/logs $HPACK_REDIS/logs
RUN \
  sed -i 's@$HPACK_DATA_NGINX@'"$HPACK_DATA_NGINX"'@g' $HPACK_NGINX/conf/nginx.conf && \
  sed -i 's@$HPACK_DATA_NGINX@'"$HPACK_DATA_NGINX"'@g' $HPACK_NGINX/conf/nginx-dev.conf


##### init default projects
RUN mkdir -p $HPACK_WS/python/hello && cd $HPACK_WS/python/hello && django-admin startproject hello . && \
  python manage.py migrate && sed -i 's@= \[\]@= \[\x27*\x27\]@' hello/settings.py
RUN mkdir $HPACK_WS/ruby && cd $HPACK_WS/ruby && rails new hello
RUN mkdir $HPACK_WS/php
RUN cd $GOPATH && revel new hibuz.com/hpack/hello && cd src/hibuz.com/hpack/hello && godep save
RUN mkdir $HPACK_WS/eclipse && cd $HPACK_WS/eclipse && $SDKMAN_DIR/candidates/springboot/current/bin/spring init --build=gradle --dependencies=web hello
RUN mkdir $HPACK_WS/node && cd $HPACK_WS/node && ng new hello 

##### clean
RUN rm -rf $XDG_CACHE_HOME && sudo rm -rf /var/lib/apt/lists/*


# 2181(zookeeper), 9092(kafka), 9100,9200,9300(elastic), 6380(redis), 27017(mongo) 
EXPOSE 2181 9092 9100 9200 9300 6380 27017 3000-3010

ENTRYPOINT ["/entrypoint-dev.sh"]

