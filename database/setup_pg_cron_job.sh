#!/bin/bash

DB_HOST="localhost"
DB_PORT="5432"
DB_NAME="data_collect"
DB_USER="data_collect"
DB_PASSWORD="data_collect"

echo "Checking if PostgreSQL service is running and healthy before setting up pg_cron job..."

CONTAINER_ID=$(docker compose ps -q db)

MAX_ATTEMPTS=12
ATTEMPT_NUM=1
SUCCESS=0

while [ $ATTEMPT_NUM -le $MAX_ATTEMPTS ]; do
    echo "Attempt $ATTEMPT_NUM/$MAX_ATTEMPTS to connect..."
    PGPASSWORD=$DB_PASSWORD \
    psql -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" -d "$DB_NAME" -f init/pg_cron_job.sql >/dev/null 2>&1
    if [ $? -eq 0 ]; then
        SUCCESS=1
        break
    else
        sleep 5
        ATTEMPT_NUM=$((ATTEMPT_NUM + 1))
    fi
done

unset PGPASSWORD

if [ $SUCCESS -eq 0 ]; then
    echo "Failed to set up pg_cron job."
    exit 1
fi

echo "pg_cron job setup complete."