#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Check if .env exists
if [ ! -f .env ]; then
    echo "Error: .env file not found!"
    exit 1
fi

# Step 1: Run the hash generator container to create .env.caddy
echo "Running hash generator..."
docker compose run --rm hashgen

# Verify that .env.caddy was created
if [ ! -f hashes/.env.caddy ]; then
    echo "Error: hashes/.env.caddy was not created."
    exit 1
fi

# Step 2: Start all services
echo "Starting Docker Compose services..."
docker compose up -d

echo "Deployment complete."
