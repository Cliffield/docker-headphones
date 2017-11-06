FROM cliffield/alpine-base:latest

MAINTAINER Cliffield <cliffield@protonmail.com>

LABEL image.version="0.1" \
      image.description="Docker image for Headphones, based on docker image of Alpine" \
      image.date="2017-11-06" \
      url.docker="https://hub.docker.com/r/cliffield/docker-headphones" \
      url.github="https://github.com/Cliffield/docker-headphones"
	  
# copy patches folder
COPY patches/ /tmp/patches/
	  
# Set basic environment settings
ENV \
    # - VERSION: the docker image version (corresponds to the above LABEL image.version)
    VERSION="0.1" \
    
    # - PUSER, PGROUP: the APP user and group name
    PUSER="headphones" \
    PGROUP="headphones" \

    # - APP_NAME: the APP name
    APP_NAME="Headphones" \

    # - APP_HOME: the APP home directory
    APP_HOME="/headphones" \

    # - APP_REPO, APP_BRANCH: the APP GitHub repository and related branch
    # for related branch or tag use e.g. master
    APP_REPO="https://github.com/rembo10/headphones.git" \
    APP_BRANCH="master" \
	
    # - PKG_*: the needed applications for installation
    PKG_ADD="ffmpeg flac" \
    PKG_DEV="g++ gcc make tar gzip" \
    PKG_PYTHON="python"
	
RUN \
    # create temporary directories
    mkdir -p /tmp && \
    mkdir -p /var/cache/apk && \

    # update the package list
    apk -U upgrade && \

    # install the needed applications
    apk -U add --no-cache $PKG_ADD $PKG_DEV $PKG_PYTHON && \
	
    # compile shntool
    mkdir -p \
        /tmp/shntool && \
    tar xf /tmp/patches/shntool-3.0.10.tar.gz -C \
        /tmp/shntool --strip-components=1 && \
    cp /tmp/patches/config.* /tmp/shntool && \
    cd /tmp/shntool && \
    ./configure \
        --infodir=/usr/share/info \
        --localstatedir=/var \
        --mandir=/usr/share/man \
        --prefix=/usr \
        --sysconfdir=/etc && \
    make && \
    make install && \

    # remove not needed packages
    apk del --purge $PKG_DEV && \

    # create headphones folder structure
    mkdir -p $APP_HOME/app && \
    mkdir -p $APP_HOME/config && \
    mkdir -p $APP_HOME/data && \

    # cleanup temporary files
    rm -rf /tmp && \
    rm -rf /var/cache/apk/*

# set the working directory for the APP
WORKDIR $APP_HOME/app

# copy files to the image
COPY *.sh /init/

# Set volumes for the Data files
VOLUME /config /data /downloads /music

# Expose ports
EXPOSE 8181	