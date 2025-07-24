# syntax=docker/dockerfile:1

FROM ghcr.io/linuxserver/baseimage-selkies:debianbookworm

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
    /usr/share/selkies/www/icon.png \
    https://raw.githubusercontent.com/linuxserver/docker-templates/master/linuxserver.io/img/librewolf-logo.png && \
  echo "**** install packages ****" && \
  apt-get update && \
  if [ -z ${LIBREWOLF_VERSION+x} ]; then \
    LIBREWOLF_VERSION=$(curl -sL https://repo.librewolf.net/dists/librewolf/main/binary-amd64/Packages \
      | grep -A 4 'Package: librewolf' \
      | awk '/Version:/ {print $2}' \
      | sort -V \
      | tail -1); \
  fi && \
  curl -o \
    /tmp/librewolf.deb -L \
    "https://repo.librewolf.net/pool/librewolf-${LIBREWOLF_VERSION}-linux-x86_64-deb.deb" && \
  apt install -y --no-install-recommends \
    /tmp/librewolf.deb && \
  printf "Linuxserver.io version: ${VERSION}\nBuild-date: ${BUILD_DATE}" > /build_version && \
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
