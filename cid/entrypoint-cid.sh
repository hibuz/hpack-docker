#!/bin/bash

echo "$LOG_HEADER [INFO] $HPACK_NAME for Continuous Integration & Delivery Starting..."

CMD_OPT=start

if [ "x$1" != "x" ]; then
  CMD_OPT=$1
fi

if [ "x$CMD_OPT" == "xrestart" ]; then
  $CATALINA_HOME/bin/shutdown.sh && $CATALINA_HOME/bin/startup.sh
elif [ "x$CMD_OPT" == "xstart" ]; then
  $CATALINA_HOME/bin/startup.sh
else
  $CATALINA_HOME/bin/shutdown.sh
fi

$SONARQUBE_HOME/bin/linux-x86-64/sonar.sh $CMD_OPT

echo "Jenkins password: cat $JENKINS_HOME/secrets/initialAdminPassword"
echo "Nexus   password: admin/admin123"
echo "Sonar   password: admin/admin"

/entrypoint-prj.sh $1
