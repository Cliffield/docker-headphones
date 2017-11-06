#!/bin/bash

# launch the APP
echo "[INFO] Launching $APP_NAME ..."
su-exec $PUSER:$PGROUP bash -c "/usr/bin/python $APP_HOME/app/Headphones.py --host 0.0.0.0 --datadir $APP_HOME/data --config $APP_HOME/config/headphones.ini"