FROM hibuz.com/base:1.0.0

MAINTAINER @hibuz

##### define default environments
# env
ARG HPACK_ID=admin
ARG HPACK_PW=hpack
ENV HPACK_PORT_APACHE 8100

# apps
ENV HPACK_NGINX $HPACK_APPS/nginx
ENV HPACK_APACHE $HPACK_APPS/apache2
ENV HPACK_PHP $HPACK_APPS/php
ENV PYTHONHOME $HPACK_APPS/python
ENV HPACK_SVN $HPACK_APPS/svn
ENV HPACK_GIT $HPACK_APPS/git
ENV MYSQL_HOME $HPACK_APPS/mysql

# data
ENV HPACK_DB $HPACK_DATA/db
ENV HPACK_DB_MYSQL $HPACK_DB/mysql
ENV HPACK_PRJ $HPACK_DATA/project
ENV HPACK_DATA_APACHE $HPACK_DATA/htdocs
ENV HPACK_DATA_NGINX $HPACK_DATA/html
ENV HPACK_PRJ_TRAC $HPACK_PRJ/trac
ENV HPACK_PRJ_SVN $HPACK_PRJ/svn
ENV HPACK_PRJ_GIT $HPACK_PRJ/git
ENV HPACK_TEMPLATE $HPACK_DATA/template

# app data
ENV HPACK_REPO $HPACK_HOME/.repo
ENV XDG_DATA_HOME $HPACK_HOME/.local/share
ENV XDG_CACHE_HOME $HPACK_HOME/.cache
ENV XDG_CONFIG_HOME $HPACK_HOME/.config
ENV PYTHON_EGG_CACHE $XDG_CACHE_HOME/eggs

# etc
ENV TRAC_ENV_PARENT_DIR $HPACK_PRJ_TRAC
ENV LD_LIBRARY_PATH $PYTHONHOME/lib:/usr/lib

ENV PATH $MYSQL_HOME/bin:$PYTHONHOME/bin:$HPACK_SVN/bin:$HPACK_GIT/bin:$HPACK_GIT/libexec/git-core:$HPACK_APACHE/bin:$HPACK_PHP/bin:$XDG_CONFIG_HOME/composer/vendor/bin:$PATH

WORKDIR $HPACK_APPS


##### install dependencies
RUN \
  sudo apt-get update && \
  sudo apt-get install -y sqlite3 swig gettext libaio1 \
  libperl-dev libssl-dev libpcre3-dev libpng12-dev libxml2-dev libserf-dev libsqlite3-dev libcurl4-openssl-dev libxslt-dev libgd2-xpm-dev libgeoip-dev


##### nginx #####     http://nginx.org/
#nginx-1.13.5  2017-09-05
RUN APP=nginx-1.13.5 && \
  wget http://nginx.org/download/$APP.tar.gz && tar xf $APP.tar.gz && cd $APP && \
  ./configure --prefix=$HPACK_NGINX \
              --sbin-path=$HPACK_NGINX/bin/nginx \
              --http-client-body-temp-path=$HPACK_NGINX/tmp/client_temp \
              --http-proxy-temp-path=$HPACK_NGINX/tmp/proxy_temp \
              --http-fastcgi-temp-path=$HPACK_NGINX/tmp/fastcgi_temp \
              --http-uwsgi-temp-path=$HPACK_NGINX/tmp/uwsgi_temp \
              --http-scgi-temp-path=$HPACK_NGINX/tmp/scgi_temp \
              --user=$HPACK_USER \
              --group=$HPACK_USER \
              --with-http_ssl_module \
              --with-http_realip_module \
              --with-http_addition_module \
              --with-http_sub_module \
              --with-http_dav_module \
              --with-http_flv_module \
              --with-http_mp4_module \
              --with-http_gunzip_module \
              --with-http_gzip_static_module \
              --with-http_random_index_module \
              --with-http_secure_link_module \
              --with-http_stub_status_module \
              --with-http_auth_request_module \
              --with-http_xslt_module=dynamic \
              --with-http_image_filter_module=dynamic \
              --with-http_geoip_module=dynamic \
              --with-http_perl_module=dynamic \
              --with-threads \
              --with-stream \
              --with-stream_ssl_module \
              --with-http_slice_module \
              --with-mail \
              --with-mail_ssl_module \
              --with-file-aio \
              --with-http_v2_module \
              --with-ipv6 && make && sudo make install && \
  sudo mkdir $HPACK_NGINX/tmp && ln -s $HPACK_NGINX/bin/nginx nginx && sudo mv nginx /usr/local/sbin && sudo rm -rf $HPACK_APPS/$APP*


##### apache2 #####   https://httpd.apache.org/download.cgi
# 2.4.28 (released 2017-10-05)
#apache 2.4  Allow from all -> Require all granted
#  wget http://mirror.navercorp.com/apache//apr/apr-1.5.2.tar.gz && tar xf apr-1.5.2.tar.gz && mv apr-1.5.2 srclib/apr && \
#  wget http://mirror.navercorp.com/apache//apr/apr-util-1.5.4.tar.gz && tar xf apr-util-1.5.4.tar.gz && mv apr-util-1.5.4 srclib/apr-util && \
RUN APP=httpd-2.4.28 && \
  wget http://mirror.navercorp.com/apache//httpd/$APP.tar.gz && tar xf $APP.tar.gz && cd $APP && \
  ./configure --prefix=$HPACK_APACHE --enable-so --enable-dav --enable-dav-fs --enable-rewrite && make && make install && \
  rm -rf $HPACK_APPS/$APP*


##### python #####   https://www.python.org/downloads/
# Python 2.7.14 2017-09-16
RUN APP_VER=2.7.14 && APP=Python-$APP_VER && \
  wget https://www.python.org/ftp/python/$APP_VER/$APP.tgz && tar xf $APP.tgz && cd $APP && \
  ./configure --prefix=$PYTHONHOME --enable-shared && make && make install && \
  rm -rf $HPACK_APPS/$APP*

# https://pypi.python.org/pypi/mod_wsgi
RUN wget https://pypi.python.org/packages/28/a7/de0dd1f4fae5b2ace921042071ae8563ce47dac475b332e288bc1d773e8d/mod_wsgi-4.5.7.tar.gz && tar xf mod_wsgi-4.5.7.tar.gz && cd mod_wsgi-4.5.7 && \
  ./configure --with-apxs=$HPACK_APACHE/bin/apxs && make && make install && \
  rm -rf $HPACK_APPS/mod*


##### svn #####   https://subversion.apache.org/news.html
# 1.9.5 2017-08-10
RUN APP=subversion-1.9.7 && \ 
  wget http://mirror.navercorp.com/apache/subversion/$APP.tar.gz && tar xf $APP.tar.gz && cd $APP && \
  ./configure --prefix=$HPACK_SVN --with-openssl --with-apxs --with-serf=/usr --without-berkeley-db && make && make install && \
  make swig-py && make check-swig-py && make install-swig-py && \
  mv $HPACK_SVN/lib/svn-python/* $PYTHONHOME/lib/python2.7 && \
  cp $HPACK_SVN/libexec/* $HPACK_APACHE/modules && \
  rm -rf $HPACK_APPS/$APP*


##### git #####   https://git-scm.com/downloads
# 2.14.2 2017-09-22
RUN APP=git-2.14.2 && \
  wget https://www.kernel.org/pub/software/scm/git/$APP.tar.gz && tar xf $APP.tar.gz && cd $APP && chmod +x configure && \
  ./configure --prefix=$HPACK_GIT --without-tcltk --with-curl --with-expat && make && make install && \
  rm -rf $HPACK_APPS/$APP*


##### trac #####
# 1.0.15 2017-06-15   https://trac.edgewall.org/browser/tags
RUN mkdir -p $PYTHON_EGG_CACHE && wget https://bootstrap.pypa.io/ez_setup.py -O - | python && \
  easy_install pip && pip install babel pygments docutils textile xlwt && \
  rm $HPACK_APPS/setuptools*

RUN pip install trac==1.0.15 && \
  easy_install https://trac-hacks.org/svn/xmlrpcplugin/trunk && \
  easy_install https://trac-hacks.org/svn/privatewikiplugin/0.11 && \
  easy_install https://trac-hacks.org/svn/accountmanagerplugin/trunk && \
  easy_install https://trac-hacks.org/svn/iniadminplugin/0.11 && \
  easy_install https://trac-hacks.org/svn/wikiganttchartplugin/0.12 && \
  easy_install https://trac-hacks.org/svn/svnauthzadminplugin/1.0 && \
  easy_install https://trac-hacks.org/svn/advancedticketworkflowplugin/1.2 && \
  easy_install https://trac-hacks.org/svn/workfloweditorplugin/trunk && \
  easy_install https://trac-hacks.org/svn/datefieldplugin/1.0 && \
  easy_install https://trac-hacks.org/svn/tracdragdropplugin/0.12 && \
  easy_install https://trac-hacks.org/svn/tracwysiwygplugin/0.12 && \
  easy_install https://trac-hacks.org/svn/autowikifyplugin/trunk && \
  easy_install https://trac-hacks.org/svn/navcontrolplugin/0.11 && \
  easy_install https://trac-hacks.org/svn/tagsplugin/trunk && \
  easy_install https://trac-hacks.org/svn/discussionplugin/1.0 && \
  easy_install https://trac-hacks.org/svn/tocmacro/0.11 && \
  easy_install https://trac-hacks.org/svn/timingandestimationplugin/branches/trac1.0 && \
  easy_install https://trac-hacks.org/svn/ticketcalendarplugin/0.12 && \
  easy_install https://trac-hacks.org/svn/navaddplugin/trunk && \
  easy_install https://trac-hacks.org/svn/worklogplugin/trunk && \
  easy_install https://trac-hacks.org/svn/fullblogplugin/0.11 && \
  easy_install https://trac-hacks.org/svn/exceldownloadplugin/0.12 && \
  easy_install https://trac-hacks.org/svn/componentdependencyplugin/0.11 && \
  easy_install https://trac-hacks.org/svn/ticketsidebarproviderplugin/0.11/ && \
  easy_install https://trac-hacks.org/svn/tracsqlhelperscript/0.12/ && \
  easy_install https://trac-hacks.org/svn/trachoursplugin/trunk/
  

##### php #####   http://php.net/downloads.php
# php-7.1.10  28 Sep 2017
RUN APP=php-7.1.10 && \
  wget -O $APP.tgz http://kr1.php.net/get/$APP.tar.gz/from/this/mirror && tar xf $APP.tgz && cd $APP && \
  ./configure --prefix=$HPACK_PHP --with-apxs2=$HPACK_APACHE/bin/apxs --with-gd --with-mysqli --with-zlib --with-openssl --with-curl --enable-mbstring --enable-zip && make && make install && \
  rm -rf $HPACK_APPS/$APP*
RUN \
  php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
  php composer-setup.php --install-dir=$HPACK_PHP/bin --filename=composer && \
  rm composer-setup.php


##### mysql #####     http://dev.mysql.com/doc/relnotes/mysql/5.7/en/
#MySQL 5.7.19 2017-07-17
RUN APP_VER=5.7 && APP=mysql-$APP_VER.19 && \
  wget https://dev.mysql.com/get/Downloads/MySQL-$APP_VER/$APP-linux-glibc2.5-x86_64.tar.gz && tar xf $APP*.tar.gz && \
  mv $APP-linux-glibc2.5-x86_64 $MYSQL_HOME && cd $MYSQL_HOME && mkdir mysql-files && chmod 750 mysql-files && \
  mkdir sbin && cd bin && mv mysql mysqld mysqladmin mysqlbinlog mysqld_safe mysqldump mysqlimport my_print_defaults mysql_install_db mysql_ssl_rsa_setup $MYSQL_HOME/sbin && \
  cd .. && rm -rf bin && mv sbin bin && rm lib/libmysqld-debug.a && \
  cp support-files/my-default.cnf my.cnf && cp support-files/mysql.server bin && \
  sed -i 's@^\(# basedir.*\)$@basedir = '"$MYSQL_HOME"'@' my.cnf && \
  sed -i 's@^\(# datadir.*\)$@datadir = '"$HPACK_DB_MYSQL"'\nbind-address = 127.0.0.1\nuser = '"$HPACK_USER"'@' my.cnf && \
  ln -s $MYSQL_HOME/bin/mysql mysql && sudo mv mysql /usr/local/sbin && sudo mv my.cnf /etc/ && \
  mkdir -p $HPACK_DB_MYSQL && bin/mysqld --initialize-insecure && bin/mysql_ssl_rsa_setup && \
  rm $HPACK_APPS/mysql-*


##### wordpress #####   https://ko.wordpress.org/releases/
#4.8.2	2017-09-20
RUN \
  wget https://wordpress.org/latest.tar.gz && tar xf latest.tar.gz && \
  rm $HPACK_APPS/latest*

RUN \
  cp wordpress/wp-config-sample.php wordpress/wp-config.php && \
  sed -i 's/database_name_here/wordpress/g' wordpress/wp-config.php && \
  sed -i 's@username_here@'"$HPACK_ID"'@g' wordpress/wp-config.php && \
  sed -i 's@password_here@'"$HPACK_PW"'@g' wordpress/wp-config.php && \
  sed -i 's/password_here/$HPACK_PW/g' wordpress/wp-config.php && \
  echo "if (\$_SERVER['HTTP_X_FORWARDED_PROTO'] == 'https')\n    \$_SERVER['HTTPS']='on';\n\nif (isset(\$_SERVER['HTTP_X_FORWARDED_HOST'])) {\n    \$_SERVER['HTTP_HOST'] = \$_SERVER['HTTP_X_FORWARDED_HOST'];\n}" >> wordpress/wp-config.php

RUN mkdir $HPACK_DATA_APACHE && mv wordpress/* $HPACK_DATA_APACHE && rmdir wordpress


##### add files
ADD entrypoint* /
ADD bin $HPACK_HOME/bin
ADD apps $HPACK_APPS
ADD data $HPACK_DATA
ADD tmp $HPACK_HOME/tmp
RUN sudo chown -R $HPACK_USER:$HPACK_USER $HPACK_HOME /entrypoint* && sudo chmod +x /entrypoint* $HPACK_HOME/bin/*.sh
RUN htpasswd -b -c $HPACK_DATA/secret/trac.htpasswd $HPACK_ID $HPACK_PW 

RUN \
  cd $HPACK_HOME/tmp/pagetohtml && python setup.py install && cd .. && \

  svn co https://github.com/trac-hacks/wikireportmacro/trunk wikireport > /dev/null && \
  cd wikireport && python setup.py install && cd .. && \

  svn co https://github.com/trac-hacks/tracsql/trunk tracsql > /dev/null && \
  cd tracsql && python setup.py install && cd .. && \

  svn co https://github.com/trac-hacks/trac-dashboard/trunk dashboard > /dev/null && \
  cd dashboard && python setup.py install && cd .. && \

  svn co https://trac-hacks.org/svn/customfieldadminplugin/0.11 custom > /dev/null && \
  cd custom && cp -rf $HPACK_HOME/tmp/traccustomfieldadmin/* customfieldadmin/locale && \
  python setup.py install && cd .. && \

  svn co http://svn.osdn.jp/svnroot/shibuya-trac/plugins/ganttcalendarplugin/trunk gantt > /dev/null && \
  cd gantt && cp -f $HPACK_HOME/tmp/ganttcalendar/* ganttcalendar && sed -i 's/ko_/en_/g' ganttcalendar/admin.py && \
  python setup.py install && cd ..

RUN \
  cp -rf $HPACK_TEMPLATE/img/trac*.* $PYTHONHOME/lib/python2.7/site-packages/trac/htdocs && \
  cp -rf $HPACK_TEMPLATE/img/favicon.ico $PYTHONHOME/lib/python2.7/site-packages/trac/htdocs/trac.ico && \
  cp -rf $HPACK_TEMPLATE/img/favicon.ico $HPACK_DATA_APACHE && \
  sed -e 's@HPACK_NAME@'"$HPACK_NAME"'@g;s@HPACK_VER@'"$HPACK_VER"'@g;s@HPACK_SITE@'"$HPACK_SITE"'@g;s@HPACK_DATA@'"$HPACK_DATA"'@g' \
  < $HPACK_HOME/tmp/trac.ini > $HPACK_TEMPLATE/trac/trac.ini && \
  sed -i 's@HPACK_ID@'"$HPACK_ID"'@g;s@HPACK_PW@'"$HPACK_PW"'@g' $HPACK_TEMPLATE/mysql/init.sql && \
  mv $HPACK_NGINX/html $HPACK_DATA && sed -i 's@$HPACK_DATA_NGINX@'"$HPACK_DATA_NGINX"'@g' $HPACK_NGINX/conf/nginx.conf && \
  rm -rf $HPACK_HOME/tmp


##### init default projects
RUN mysql.server start && sudo mysql mysql < $HPACK_TEMPLATE/mysql/init.sql
RUN \
  cd $HPACK_DATA_APACHE && composer create-project phpmyadmin/phpmyadmin --repository-url=https://www.phpmyadmin.net/packages.json --no-dev && \
  cd phpmyadmin && cp config.sample.inc.php config.inc.php && sed -i 's/localhost/127.0.0.1/g' config.inc.php

RUN \
  add-project.sh hpack && \
  git config --global user.email "$HPACK_USER@hibuz.com" && \
  git config --global user.name "$HPACK_USER"

##### clean
RUN rm -rf $XDG_CACHE_HOME && sudo rm -rf /var/lib/apt/lists/*

EXPOSE 80 3306 $HPACK_PORT_APACHE


ENTRYPOINT ["/entrypoint-prj.sh"]

