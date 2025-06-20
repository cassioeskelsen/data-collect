FROM postgres:16

RUN apt-get update && apt-get install -y --no-install-recommends \
    lsb-release \
    wget \
    ca-certificates \
    gnupg \
    && wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | gpg --dearmor | tee /etc/apt/trusted.gpg.d/apt.postgresql.org.gpg >/dev/null \
    && echo "deb http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
    postgresql-16-cron \
    postgresql-contrib \
    && rm -rf /var/lib/apt/lists/*

ENV POSTGRES_DB=data_collect
ENV POSTGRES_USER=data_collect
ENV POSTGRES_PASSWORD=data_collect

RUN echo "cron.database_name = 'data_collect'" >> /var/lib/postgresql/data/postgresql.conf

COPY init/*.sql /docker-entrypoint-initdb.d/

EXPOSE 5432