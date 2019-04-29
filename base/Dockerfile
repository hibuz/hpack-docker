FROM ubuntu:xenial

MAINTAINER @hibuz


##### define default environments
ENV HPACK_USER ubuntu
ENV HPACK_HOME /home/$HPACK_USER/hpack
ENV HPACK_NAME="Hibuz Pack" HPACK_SITE="hibuz.com"
ENV HPACK_VER="1.0.13" HPACK_RELEASE="2017-10-06"
#en, ko
ENV HPACK_LANG "ko"
ENV HPACK_APPS $HPACK_HOME/apps
ENV HPACK_DATA $HPACK_HOME/data
ENV HPACK_BACKUP $HPACK_DATA/backup

ENV PATH $HPACK_HOME/bin:$PATH

##### install dependencies
RUN sed -i 's/archive.ubuntu.com/ftp.daumkakao.com/g' /etc/apt/sources.list

RUN \
  apt-get update && apt-get upgrade -y && apt-get install -y apt-utils sudo locales vim ntp rsync zip curl wget net-tools build-essential openssh-server pkg-config && \
  rm -rf /var/lib/apt/lists/*

##### Set the locale and timezone
ENV TZ Asia/Seoul
RUN locale-gen en_US.UTF-8
ENV LANG=en_US.UTF-8 LANGUAGE=en_US:en LC_ALL=en_US.UTF-8


##### add default user
RUN \
  groupadd -r $HPACK_USER --gid=1000 && useradd -r -g $HPACK_USER --uid=1000 -m -s /bin/bash $HPACK_USER && \
  chmod u+w /etc/sudoers && echo "ubuntu        ALL=(ALL)       NOPASSWD: ALL" >> /etc/sudoers && chmod u-w /etc/sudoers

RUN mkdir -p $HPACK_HOME/bin $HPACK_APPS $HPACK_DATA
ADD set_env.sh $HPACK_HOME/bin
RUN chown -R $HPACK_USER:$HPACK_USER /home/$HPACK_USER

USER $HPACK_USER
RUN /bin/echo -e "$HPACK_USER\n$HPACK_USER\n" | sudo passwd $HPACK_USER && . $HPACK_HOME/bin/set_env.sh

VOLUME $HPACK_DATA

WORKDIR $HPACK_HOME

EXPOSE 22

CMD ["bash"]
