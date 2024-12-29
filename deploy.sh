#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Check if .env exists
if [ ! -f .env ]; then
    echo "Error: .env file not found!"
    exit 1
fi

# Step 1: Build the hash generator image
echo "Build hash generator"
docker build --network=host -t hashgen:latest ./hash_generator

# Step 2: Run the hash generator container to create .env.caddy
echo "Running hash generator..."
docker compose -f docker-compose.hashgen.yml run --rm hashgen

# Verify that .env.caddy was created
if [ ! -f hashes/.env.caddy ]; then
    echo "Error: hashes/.env.caddy was not created."
    exit 1
fi

# Step 3: Start all services
echo "Starting Docker Compose services..."
docker compose up -d

echo "Deployment complete."
