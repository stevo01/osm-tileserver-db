#!/bin/bash

# set -x

STOP_CONT="no"

function createPostgresConfig() {
  cp /etc/postgresql/11/main/postgresql.custom.conf.tmpl /etc/postgresql/11/main/postgresql.custom.conf
  cat /etc/postgresql/11/main/postgresql.custom.conf
}

function setPostgresPassword() {

  if sudo -u postgres psql -t -c '\du' | cut -d \| -f 1 | grep -qw renderer; then
      # user exists
      # $? is 0
      echo "pgsql user renderer exists"
  else
    service postgresql start
    sudo -u postgres createuser renderer
    sudo -u postgres createdb -E UTF8 -O renderer gis
    sudo -u postgres psql -d gis -c "CREATE EXTENSION postgis;"
    sudo -u postgres psql -d gis -c "CREATE EXTENSION hstore;"
    sudo -u postgres psql -d gis -c "ALTER TABLE geometry_columns OWNER TO renderer;"
    sudo -u postgres psql -d gis -c "ALTER TABLE spatial_ref_sys OWNER TO renderer;"
  fi

  sudo -u postgres psql -c "ALTER USER renderer PASSWORD '${PGPASSWORD:-renderer}'"
}


# handler for term signal
function sighandler_TERM() {
    echo "signal SIGTERM received\n"

    echo "terminate postgresql"
    service postgresql stop

    STOP_CONT="yes"
}


if [ "$#" -ne 1 ]; then
    echo "usage: <import|run>"
    echo "commands:"
    echo "    run: pgsql"
    echo "environment variables:"
    echo "    THREADS: defines number of threads used for importing / tile rendering"
    echo "    UPDATES: consecutive updates (enabled/disabled)"
    echo "    RENDERERAPP: select render application renderd (default) or tirex"
    exit 1
fi

if [ "$1" = "run" ]; then
    # add handler for signal SIHTERM
    trap 'sighandler_TERM' 15

    # Fix postgres data privileges
    chown postgres:postgres /var/lib/postgresql -R

    # Initialize PostgreSQL and Apache
    createPostgresConfig
    service postgresql start
    setPostgresPassword

    echo "wait for terminate signal"
    while [  "$STOP_CONT" = "no"  ] ; do
      sleep 1
    done

    exit 0
fi

echo "invalid command"
exit 1
