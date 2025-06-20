#!/bin/bash

DB_HOST="localhost"
DB_PORT="5432"
DB_NAME="data_collect"
DB_USER="data_collect"
DB_PASSWORD="data_collect"

echo "Checking if PostgreSQL service is running via Docker Compose..."

CONTAINER_ID=$(docker compose ps -q db)

HEALTH_STATUS=$(docker inspect --format='{{.State.Health.Status}}' "$CONTAINER_ID" 2>/dev/null)

if [[ "$HEALTH_STATUS" != "healthy" ]]; then
    echo "PostgreSQL service 'db' is not healthy. Current health status: '$HEALTH_STATUS'"
    echo "Please ensure the service is started and healthy using: docker compose up -d"
    exit 1
fi
echo "PostgreSQL service is running and healthy."

export PGPASSWORD=$DB_PASSWORD
psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME

unset PGPASSWORD

echo "Exited psql. To execute a specific command, use:"
echo "PGPASSWORD=\$DB_PASSWORD psql -h \$DB_HOST -p \$DB_PORT -U \$DB_USER -d \$DB_NAME -c \"SELECT * FROM data_collect LIMIT 5;\""

