FROM ghcr.io/linuxserver/baseimage-kasmvnc:debianbookworm

# set version label
ARG BUILD_DATE
ARG VERSION
ARG LIBREWOLF_VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="thelamer"

# title
ENV TITLE=LibreWolf

RUN \
  echo "**** add icon ****" && \
  curl -o \
    /kclient/public/icon.png \
    https://raw.githubusercontent.com/linuxserver/docker-templates/master/linuxserver.io/img/librewolf-logo.png && \
  echo "**** install packages ****" && \
  apt-get update && \
  if [ -z ${LIBREWOLF_VERSION+x} ]; then \
    LIBREWOLF_VERSION=$(curl -sL https://deb.librewolf.net/dists/bookworm/main/binary-amd64/Packages \
      | grep -A 4 'Package: librewolf' \
      | awk '/Version:/ {print $2}' \
      | sort -V \
      | tail -1); \
  fi && \
  curl -o \
    /tmp/librewolf.deb -L \
    "https://deb.librewolf.net/pool/bookworm/librewolf-${LIBREWOLF_VERSION}.en-US.debian12.x86_64.deb" && \
  apt install -y --no-install-recommends \
    /tmp/librewolf.deb && \
  echo "**** cleanup ****" && \
  apt-get autoclean && \
  rm -rf \
    /config/.cache \
    /var/lib/apt/lists/* \
    /var/tmp/* \
    /tmp/*

# add local files
COPY /root /

# ports and volumes
EXPOSE 3000

VOLUME /config
