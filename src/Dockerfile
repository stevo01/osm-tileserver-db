FROM debian:10

# Based on
# giggls/tileserver-scripts
# https://github.com/giggls/tileserver-scripts

# Install dependencies
RUN apt-get update && apt-get install --no-install-recommends -y \
  postgis \
  postgresql \
  postgresql-postgis \
  postgresql-postgis-scripts \
  postgresql-contrib \
  sudo \
  nano mc psmisc \
&& apt-get clean autoclean \
&& apt-get autoremove --yes \
&& rm -rf /var/lib/{apt,dpkg,cache,log}

# Configure PosgtreSQL
COPY postgresql.custom.conf.tmpl /etc/postgresql/11/main/
RUN chown -R postgres:postgres /var/lib/postgresql \
  && chown postgres:postgres /etc/postgresql/11/main/postgresql.custom.conf.tmpl \
  && echo "\ninclude 'postgresql.custom.conf'" >> /etc/postgresql/11/main/postgresql.conf
RUN echo "host all all 0.0.0.0/0 md5" >> /etc/postgresql/11/main/pg_hba.conf \
      && echo "host all all ::/0 md5" >> /etc/postgresql/11/main/pg_hba.conf

# Start running
USER root
COPY run.sh /
ENTRYPOINT ["/run.sh"]
CMD []
