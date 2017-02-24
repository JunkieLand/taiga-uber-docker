FROM ubuntu:16.04

ENV DEBIAN_FRONTEND noninteractive

RUN useradd --create-home taiga

RUN \
  apt-get update -qq && \
  apt-get install -y --no-install-recommends apt-utils && \
  apt-get install -y python3 perl git vim less sudo mlocate curl && \
  curl -sL https://deb.nodesource.com/setup_6.x > /tmp/node.sh && chmod +x /tmp/node.sh && /tmp/node.sh && \
  echo "taiga    ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

ENV SCHEME http
ENV TAIGA_HOSTNAME localhost
ENV DEBUG True
ENV PUBLIC_REGISTER_ENABLED True

USER taiga
WORKDIR /home/taiga

ENV DEBIAN_FRONTEND noninteractive

COPY scripts/envTaiga.sh /usr/bin/
COPY scripts/install.sh /tmp/
COPY scripts/startTaiga.sh /usr/bin/

COPY conf/taiga_back_local.py.sh /tmp/
COPY conf/taiga_front_conf.json.sh /tmp/
COPY conf/taiga_events_config.json.sh /tmp/
COPY conf/circus_conf_taiga.ini.sh /tmp/
COPY conf/circus_conf_taiga-events.ini.sh /tmp/
COPY conf/nginx_taiga_conf.sh /tmp/

RUN /tmp/install.sh

VOLUME ["/home/taiga/logs", "/home/taiga/taiga-back/static", "/home/taiga/taiga-back/media"]

CMD /usr/bin/startTaiga.sh

EXPOSE 80