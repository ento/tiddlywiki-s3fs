FROM node:5.7-slim

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get install -y \
  build-essential \
  libfuse-dev \
  libcurl4-openssl-dev \
  libssl-dev \
  libxml2-dev \
  pkg-config \
  mime-support \
  automake \
  libtool \
  curl \
  tar \
  python-pip \
  python-dev
RUN pip install supervisor
RUN curl -L https://github.com/s3fs-fuse/s3fs-fuse/archive/v1.79.tar.gz | tar zxv -C /usr/src
RUN cd /usr/src/s3fs-fuse-1.79 && ./autogen.sh && ./configure --prefix=/usr/local && make && make install

RUN npm install -g tiddlywiki --no-spin --no-color --silent

COPY supervisord.conf /etc/supervisord.conf
EXPOSE 80

ENTRYPOINT ["/usr/local/bin/supervisord"]
