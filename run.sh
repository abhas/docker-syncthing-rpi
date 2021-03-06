docker rm -f syncthing
docker rm -f bud

docker run -d --restart=always \
  -v /srv/sync:/srv/data \
  -v /srv/syncthing:/srv/config \
  -p 22000:22000  -p 21025:21025/udp \
  --name syncthing \
  joeybaker/syncthing

sleep 1
docker run -d --restart=always \
  -v /srv/bud:/data \
  -p 443:443 \
  --name bud \
  --link syncthing:backend \
  joeybaker/bud-tls
