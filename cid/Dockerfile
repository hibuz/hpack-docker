FROM hibuz.com/prj:1.0.13

MAINTAINER @hibuz


##### define default environments
# apps
ARG HPACK_ID=admin
ARG HPACK_PW=hpack

ENV SDKMAN_DIR $HPACK_APPS/sdkman
ENV CATALINA_HOME $HPACK_APPS/tomcat
ENV SONARQUBE_HOME $HPACK_APPS/sonar
ENV JAVA_HOME $HPACK_APPS/jdk8x64

# data
ENV HPACK_CID $HPACK_DATA/cid
ENV JENKINS_HOME $HPACK_CID/jenkins
ENV PLEXUS_NEXUS_WORK $HPACK_CID/nexus
ENV HPACK_CID_SONAR $HPACK_CID/sonar
ENV HPACK_DATA_WEBAPPS $HPACK_DATA/webapps

# etc
ENV GRADLE_USER_HOME $HPACK_REPO/gradle
ENV SONAR_USER_HOME $XDG_CACHE_HOME/sonar

ENV PATH $JAVA_HOME/bin:$PATH

##### jdk #####   http://www.oracle.com/technetwork/java/javase/8u-relnotes-2225394.html
#8u111 October 18, 2016
RUN APP_VER=8u111 && APP=$APP_VER-b14 && \
  wget --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/$APP/jdk-$APP_VER-linux-x64.tar.gz -O jdk.tgz && \
  tar xf jdk.tgz && rm jdk.tgz && mv jdk1* $JAVA_HOME


#### sdkman #####     https://github.com/sdkman/sdkman-cli/releases
#sdkman 5.5.2 2017-01-01
RUN curl -s "https://get.sdkman.io" | bash


##### tomcat #####     https://tomcat.apache.org/index.html
#8.0.39 Released 2017-05-17
RUN APP_VER=8.0.44 && APP=apache-tomcat-$APP_VER && \
  wget http://mirror.navercorp.com/apache/tomcat/tomcat-8/v$APP_VER/bin/$APP.tar.gz && tar xf $APP.tar.gz && rm $APP.tar.gz && \
  sed -i 's@webapps@'"$HPACK_DATA_WEBAPPS"'@g' $APP/conf/server.xml && \
  mv $APP $CATALINA_HOME && mv $CATALINA_HOME/webapps $HPACK_DATA_WEBAPPS


##### jenkins #####     https://jenkins.io/changelog-stable/
#2.32.1 (2016-12-24)
RUN cd $HPACK_DATA_WEBAPPS && wget http://mirrors.jenkins-ci.org/war-stable/latest/jenkins.war


##### nexus #####     https://support.sonatype.com/hc/en-us/articles/213464368-Nexus-Repository-Manager-2-Release-Notes-Index
#2.14.2 December 13, 2016
RUN cd $HPACK_DATA_WEBAPPS && wget -nc -O nexus.war http://www.sonatype.org/downloads/nexus-latest.war


##### sonar #####     http://www.sonarqube.org/downloads/
#5.6.4 (LTS) Dec. 12, 2016
RUN APP=sonarqube-5.6.4 && \
  wget https://sonarsource.bintray.com/Distribution/sonarqube/$APP.zip && unzip $APP.zip && rm $APP.zip && \
  sed -i 's@#sonar.jdbc.url=jdbc:mysql@sonar.jdbc.url=jdbc:mysql@g' $APP/conf/sonar.properties && \
  sed -i 's@#sonar.jdbc.username=@sonar.jdbc.username='"$HPACK_ID"'@g' $APP/conf/sonar.properties && \
  sed -i 's@#sonar.jdbc.password=@sonar.jdbc.password='"$HPACK_PW"'@g' $APP/conf/sonar.properties && \
  sed -i 's@#sonar.path.data=data@sonar.path.data='"$HPACK_CID_SONAR"'@g' $APP/conf/sonar.properties && \
  sed -i 's@#sonar.web.context=@sonar.web.context=/sonar@g' $APP/conf/sonar.properties && mv $APP $SONARQUBE_HOME


##### add files
ADD entrypoint* /
ADD bin $HPACK_HOME/bin
ADD apps $HPACK_APPS

RUN \
  sudo chown -R $HPACK_USER:$HPACK_USER $HPACK_HOME/bin $SDKMAN_DIR $HPACK_NGINX /entrypoint* && chmod +x /entrypoint* $SDKMAN_DIR/bin/sdkman.sh && \
  sed -i 's@$HPACK_DATA_NGINX@'"$HPACK_DATA_NGINX"'@g' $HPACK_NGINX/conf/nginx.conf && \
  mkdir $HPACK_REPO


##### java build tools #####
#ant 1.9.7
#maven 3.3.9
#gradle 3.2.3
RUN \
  /bin/echo "y" | $SDKMAN_DIR/bin/sdkman.sh install ant && \
  /bin/echo "y" | $SDKMAN_DIR/bin/sdkman.sh install maven && \
  /bin/echo "y" | $SDKMAN_DIR/bin/sdkman.sh install gradle
ADD maven/settings.xml $SDKMAN_DIR/candidates/maven/current/conf/
RUN sudo chown -R $HPACK_USER:$HPACK_USER $SDKMAN_DIR/candidates/maven/current/conf/*


##### clean
RUN rm -rf $XDG_CACHE_HOME && sudo rm -rf /var/lib/apt/lists/*


EXPOSE 8080 9000


ENTRYPOINT ["/entrypoint-cid.sh"]

