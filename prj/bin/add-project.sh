#!/bin/bash

if [ "x$2" = "x" ]; then
  _THEME_FILE="trac-theme-default.sql"
else
  _THEME_FILE="trac-theme-$2.sql"
fi

if [ "x$1" = "x" ]; then
  echo "$LOG_HEADER[ERROR] Usage: $0 <ProjectName> <[Optional] Theme Name>"
  exit
elif [ ! -f "$HPACK_TEMPLATE/trac/$_THEME_FILE" ]; then
  echo "$LOG_HEADER[ERROR] no file: $HPACK_TEMPLATE/trac/$_THEME_FILE"
  exit
elif [ -d "$HPACK_PRJ_TRAC/$1" ]; then
  echo "$LOG_HEADER [WARN] $1 Trac project already exist."
  exit
fi

# Create Subversion Repository
add-svn.sh $1

# Create Git Repository
add-git.sh $1

_PROJECTNAME=$1
_DB="sqlite:db/trac.db"
_REPOSTYPE="svn"
_REPOSPATH=$HPACK_PRJ_SVN/$_PROJECTNAME
_TRACPATH=$HPACK_PRJ_TRAC/$_PROJECTNAME

trac-admin $_TRACPATH initenv --inherit=$HPACK_PRJ_TRAC/trac.ini $_PROJECTNAME $_DB $_REPOSTYPE $_REPOSPATH

if [ "$_THEME_FILE" = "trac-theme-default.sql" ]; then
 cp -rf $HPACK_TEMPLATE/trac/import/* $_TRACPATH
fi

python $HPACK_HOME/bin/rep-copy.py $_PROJECTNAME $HPACK_TEMPLATE/trac/trac.ini.tpl $_TRACPATH/conf/trac.ini
cp $HPACK_TEMPLATE/img/logo.png $_TRACPATH/htdocs
python $HPACK_HOME/bin/rep-copy.py $_PROJECTNAME $HPACK_TEMPLATE/trac/$_THEME_FILE $HPACK_TEMPLATE/trac/tmp.sql
sqlite3 $_TRACPATH/db/trac.db < $HPACK_TEMPLATE/trac/tmp.sql
rm $HPACK_TEMPLATE/trac/tmp.sql
trac-admin $_TRACPATH upgrade
trac-admin $_TRACPATH permission add administrator TRAC_ADMIN
trac-admin $_TRACPATH permission add administrator XML_RPC
trac-admin $_TRACPATH permission add admin administrator
if [ ! "x$2" = "xtest" ]; then
  trac-admin $_TRACPATH repository resync git
fi
echo "$LOG_HEADER [INFO] Theme file: $HPACK_TEMPLATE/trac/$_THEME_FILE"
echo "$LOG_HEADER [INFO] Trac repository [$_PROJECTNAME] created."
