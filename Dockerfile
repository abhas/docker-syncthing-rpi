FROM mazzolino/armhf-ubuntu
MAINTAINER Abhas Abhinav <abhas@deeproot.in>

RUN useradd --no-create-home -g users --uid 22000 syncthing
# grab gosu for easy step-down from root
RUN apt-get update -qq \
  && apt-get install curl -y \
  && gpg --keyserver pgp.mit.edu --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
  && curl -o /usr/local/bin/gosu -SL "https://github.com/tianon/gosu/releases/download/1.4/gosu-$(dpkg --print-architecture)" \
  && curl -o /usr/local/bin/gosu.asc -SL "https://github.com/tianon/gosu/releases/download/1.4/gosu-$(dpkg --print-architecture).asc" \
  && gpg --verify /usr/local/bin/gosu.asc \
  && rm /usr/local/bin/gosu.asc \
  && chmod +x /usr/local/bin/gosu

# get syncthing
## ADD https://github.com/syncthing/syncthing/releases/download/v0.11.1/syncthing-linux-amd64-v0.11.1.tar.gz /srv/syncthing.tar.gz
ADD https://github.com/syncthing/syncthing/releases/download/v0.11.1/syncthing-linux-arm-v0.11.1.tar.gz /srv/syncthing.tar.gz
WORKDIR /srv
RUN tar -xzvf syncthing.tar.gz \
  && rm -f syncthing.tar.gz \
  && mv syncthing-linux-arm-v* syncthing \
  && chown -R syncthing:users syncthing \
  && mkdir -p /srv/config \
  && mkdir -p /srv/data \

VOLUME ["/srv/data", "/srv/config"]

ADD ./start.sh /srv/start.sh
RUN chmod 770 /srv/start.sh

ENTRYPOINT ["/srv/start.sh"]

