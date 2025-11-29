FROM ghcr.io/linuxserver/baseimage-selkies:ubuntunoble

# set version label
ARG BUILD_DATE
ARG VERSION
ARG MELONDS_VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="thelamer"

# title
ENV TITLE=melonDS

RUN \
  echo "**** add icon ****" && \
  curl -o \
    /usr/share/selkies/www/icon.png \
    https://raw.githubusercontent.com/linuxserver/docker-templates/master/linuxserver.io/img/melonds-logo.png && \
  echo "**** install packages ****" && \
  apt-get update && \
  apt-get install -y \
    libqt6multimedia6 \
    libenet7 \
    ibsdl2-2.0-0 \
    libfaad2 \
    libqt6widgets6 \
    unzip && \
  if [ -z ${MELONDS_VERSION+x} ]; then \
    MELONDS_VERSION=$(curl -sX GET "https://api.github.com/repos/melonDS-emu/melonDS/releases/latest" \
    | awk '/tag_name/{print $4;exit}' FS='[""]'); \
  fi && \
  curl -o \
    /tmp/melon.zip -L \
    "https://github.com/melonDS-emu/melonDS/releases/download/${MELONDS_VERSION}/melonDS-${MELONDS_VERSION}-ubuntu-x86_64.zip" && \
  cd /tmp && \
  unzip melon.zip && \
  mv \
    melonDS \
    /usr/bin && \
  mkdir -p \
    /usr/share/icons/hicolor/128x128/apps && \
  cp \
    /usr/share/selkies/www/icon.png \
    /usr/share/icons/hicolor/128x128/apps/melonds.png && \
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
EXPOSE 3001
VOLUME /config
