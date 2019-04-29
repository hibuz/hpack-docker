#!/bin/bash

export HPACK_USER=`whoami`

if ! grep -q "set_env.sh" /home/$HPACK_USER/.bashrc; then
  echo "# Added by Hibuz Pack" >> /home/$HPACK_USER/.bashrc
  echo "source /home/$HPACK_USER/hpack/bin/set_env.sh" >> /home/$HPACK_USER/.bashrc
fi

# hibuz pack
export LOG_HEADER="[HPACK] "
#export JAVA_HOME=$HPACK_APPS/jdk8x64

#export PATH=$HPACK_HOME/bin:$HPACK_SVN/bin:$HPACK_GIT/bin:$HPACK_GIT/libexec/git-core:$HPACK_APACHE/bin:$PATH

cd $HPACK_HOME

echo "$LOG_HEADER [INFO] ENV ready."
