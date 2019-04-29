FROM hibuz.com/dev:1.0.13

MAINTAINER @hibuz


##### define default environments
# apps
ENV SCALA_HOME $HPACK_APPS/scala

ENV PATH $PATH:$SCALA_HOME/bin


##### install dependencies
#RUN sudo apt-get update && sudo apt-get install -y 


##### Scalar #####     https://www.scala-lang.org/news/#announcements--changelog
#Scala 2.12.1 DECEMBER 05, 2016
RUN APP_VER=2.12.1 && APP=scala-$APP_VER && \
  wget http://downloads.lightbend.com/scala/$APP_VER/$APP.tgz && tar xf $APP.tgz && mv $APP $SCALA_HOME && rm $APP.tgz


##### add files
ADD entrypoint* /
ADD bin $HPACK_HOME/bin
ADD apps $HPACK_APPS
RUN sudo chown -R $HPACK_USER:$HPACK_USER $HPACK_HOME/bin $HPACK_NGINX /entrypoint* && chmod +x /entrypoint*
RUN mkdir -p $HPACK_DB_MONGO $HPACK_DB_REDIS $HPACK_DB_ELASTIC && \
    mkdir -p $HPACK_MONGO/logs $HPACK_REDIS/logs


##### init default projects
#RUN mkdir -p $HPACK_WS/python/hello && cd $HPACK_WS/python/hello && django-admin startproject hello .

##### clean
RUN rm -rf $XDG_CACHE_HOME && sudo rm -rf /var/lib/apt/lists/*


# 27017(mongo) 
EXPOSE 

ENTRYPOINT ["/entrypoint-aim.sh"]

