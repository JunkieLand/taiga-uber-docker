FROM ubuntu:16.04

ENV DEBIAN_FRONTEND noninteractive

RUN useradd --create-home --uid 1042 taiga

RUN \
  apt-get update -qq && \
  apt-get install -y --no-install-recommends apt-utils && \
  apt-get install -y python3 perl git vim less sudo mlocate curl && \
  curl -sL https://deb.nodesource.com/setup_6.x > /tmp/node.sh && chmod +x /tmp/node.sh && /tmp/node.sh && \
  echo "taiga    ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

ENV TAIGA_PORT 80
ENV DEBUG False
ENV PUBLIC_REGISTER_ENABLED True
ENV EMAIL_ENABLED False
ENV EMAIL_DEFAULT_FROM "noreply@example.com"
ENV EMAIL_USE_TLS False
ENV EMAIL_HOST "localhost"
ENV EMAIL_PORT 25
ENV EMAIL_HOST_USER "user"
ENV EMAIL_HOST_PASSWORD "password"


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

VOLUME ["/home/taiga/logs", "/home/taiga/taiga-back/static", "/home/taiga/taiga-back/media", "/var/lib/postgresql/9.5/main"]

CMD /usr/bin/startTaiga.sh

EXPOSE 80