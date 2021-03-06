#!/bin/bash
# strict mode http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail
IFS=$'\n\t'

# if this if the first run, generate a useful config
if [ ! -f /srv/config/config.xml ]; then
  echo "generating config"
  /srv/syncthing/syncthing --generate="/srv/config"
  # don't take the whole volume with the default so that we can add additional folders
  sed -e 's/root\/Sync/srv\/data/' -i /srv/config/config.xml
  # ensure we can see the web ui outside of the docker container
  sed -e 's/127.0.0.1:8384/0.0.0.0:8080/' -i /srv/config/config.xml
fi

# set permissions so that we have access to volumes
chown -R syncthing:users /srv/config /srv/data 
chmod -R 770 /srv/config /srv/data

gosu syncthing /srv/syncthing/syncthing -home=/srv/config

