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

# Step 4: Set UFW to allow Docker networks
echo "Configuring UFW for Docker traffic via docker0..."

# Allow traffic on docker0
if ip link show docker0 &>/dev/null; then
  echo "Allowing traffic on docker0 interface..."
  sudo ufw allow in on docker0
  sudo ufw allow out on docker0
else
  echo "docker0 interface not found. Are Docker services running?"
  exit 1
fi

# Set forwarding policy to ACCEPT
echo "Setting UFW forwarding policy to ACCEPT..."
sudo sed -i 's/^DEFAULT_FORWARD_POLICY=.*/DEFAULT_FORWARD_POLICY="ACCEPT"/' /etc/default/ufw

# Reload UFW to apply changes
echo "Reloading UFW..."
sudo ufw reload

echo "UFW configured to allow Docker traffic on docker0 interface."

echo "Deployment complete."
