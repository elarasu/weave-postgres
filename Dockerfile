# postgres
#   docker build -t elarasu/weave-postgres .
#
FROM postgres:9.5
MAINTAINER elarasu@outlook.com

# Core updates
RUN  apt-get update \
  && apt-get install -yq wget curl openssl unzip sysstat lsof strace tcpdump dnsutils vim-tiny xz-utils ca-certificates --no-install-recommends \
  && sed -i '/ENABLED/ s/false/true/' /etc/default/sysstat

# update postgres with pglogical
RUN  echo "deb [arch=amd64] http://packages.2ndquadrant.com/pglogical/apt/ jessie-2ndquadrant main" >> /etc/apt/sources.list.d/2ndquadrant.list \
  && wget --quiet -O - http://packages.2ndquadrant.com/pglogical/apt/AA7A6805.asc | apt-key add -

RUN  apt-get update \
  && apt-get -yq install postgresql-9.5-pglogical \
  && apt-get autoremove -y \
  && apt-get clean -y \
  && rm -rf /tmp/* /var/tmp/* /var/lib/apt/lists/*

#  wal_level = logical
#  max_wal_senders = 8
#  wal_keep_segments = 4
#  max_replication_slots = 4
# todo
#RUN  sed -i '/wal_level/ s/minimal/logical/' /var/lib/postgresql/data/postgresql.conf \
#  && sed -i '/wal_level/ s/^#//' /var/lib/postgresql/data/postgresql.conf \
#  && sed -i '/max_wal_senders/ s/0/8/' /var/lib/postgresql/data/postgresql.conf \
#  && sed -i '/max_wal_senders/ s/^#//' /var/lib/postgresql/data/postgresql.conf \
#  && sed -i '/wal_keep_segments/ s/0/4/' /var/lib/postgresql/data/postgresql.conf \
#  && sed -i '/wal_keep_segments/ s/^#//' /var/lib/postgresql/data/postgresql.conf \
#  && sed -i '/max_replication_slots/ s/0/4/' /var/lib/postgresql/data/postgresql.conf \
#  && sed -i '/max_replication_slots/ s/^#//' /var/lib/postgresql/data/postgresql.conf

#sed -i '/wal_level/ s/minimal/logical/' /var/lib/postgresql/data/postgresql.conf   && sed -i '/wal_level/ s/^#//' /var/lib/postgresql/data/postgresql.conf   && sed -i '/max_wal_senders/ s/0/8/' /var/lib/postgresql/data/postgresql.conf   && sed -i '/max_wal_senders/ s/^#//' /var/lib/postgresql/data/postgresql.conf   && sed -i '/wal_keep_segments/ s/0/4/' /var/lib/postgresql/data/postgresql.conf   && sed -i '/wal_keep_segments/ s/^#//' /var/lib/postgresql/data/postgresql.conf   && sed -i '/max_replication_slots/ s/0/4/' /var/lib/postgresql/data/postgresql.conf   && sed -i '/max_replication_slots/ s/^#//' /var/lib/postgresql/data/postgresql.conf

# install pg-web
# wget https://github.com/sosedoff/pgweb/releases/download/v0.9.1/pgweb_linux_amd64.zip

# install postgrest
RUN mkdir -p /deploy
WORKDIR /deploy
RUN  wget https://github.com/begriffs/postgrest/releases/download/v0.3.0.4/postgrest-0.3.0.4-ubuntu.tar.xz \
  && tar xvf postgrest-0.3.0.4-ubuntu.tar.xz
