FROM debian:wheezy

MAINTAINER Goldy

# Build dockerfile

ENV		LD_LIBRARY_PATH /usr/local/lib

ADD . /zbar

WORKDIR /zbar

RUN	 apt-get update && apt-get install -y build-essential libmagick++-dev gettext libtool autoconf automake
RUN	 autoreconf --install
RUN	 ./configure --with-x=no --with-jpeg=no --enable-video=no --with-python=no --with-gtk=no --with-qt=no
RUN	 make && make install-exec
