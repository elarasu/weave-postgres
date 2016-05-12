# postgres
#   docker build -t elarasu/weave-postgres .
#
FROM postgres:9.5
MAINTAINER elarasu@outlook.com

# Core updates
RUN  apt-get update \
  && apt-get install -yq wget curl openssl unzip sysstat lsof strace tcpdump dnsutils vim-tiny xz-utils ca-certificates libjansson4 --no-install-recommends \
  && sed -i '/ENABLED/ s/false/true/' /etc/default/sysstat \
  && apt-get autoremove -y \
  && apt-get clean -y \
  && rm -rf /tmp/* /var/tmp/* /var/lib/apt/lists/*

# update postgres with bottledwater
RUN mkdir -p /deploy
WORKDIR /deploy
RUN wget https://github.com/elarasu/bottledwater-pg/raw/master/tmp/bottledwater-ext.tar.gz -O bottledwater-ext.tar.gz
RUN wget https://github.com/elarasu/bottledwater-pg/raw/master/tmp/avro.tar.gz -O avro.tar.gz
RUN wget https://raw.githubusercontent.com/elarasu/bottledwater-pg/master/tmp/replication-config.sh -O replication-config.sh
RUN cd / && tar zxf deploy/bottledwater-ext.tar.gz && tar zxf deploy/avro.tar.gz && cp /usr/local/lib/libavro.so.* /usr/lib/x86_64-linux-gnu/
RUN cp replication-config.sh /docker-entrypoint-initdb.d/replication-config.sh

# install pg-web
# wget https://github.com/sosedoff/pgweb/releases/download/v0.9.1/pgweb_linux_amd64.zip

