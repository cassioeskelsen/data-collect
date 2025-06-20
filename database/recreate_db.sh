#!/bin/bash

echo "Stopping and removing the PostgreSQL service and its data volume..." 
docker compose down --volumes

if [ $? -ne 0 ]; then
    echo "Failed to stop and remove PostgreSQL service. Exiting."
    exit 1
fi

echo "Starting the PostgreSQL service again. This will recreate the database and run init.sql." 
docker compose up -d

if [ $? -ne 0 ]; then
    echo "Failed to start PostgreSQL service. Please check Docker logs."
    exit 1
fi

echo "Waiting for PostgreSQL service to be healthy..." 
until docker inspect --format='{{.State.Health.Status}}' $(docker compose ps -q db) | grep -q "healthy"; do
    printf '.'
    sleep 5
done

echo "PostgreSQL service is now healthy. Database recreated successfully."
echo "You can now connect using ./run.sh"