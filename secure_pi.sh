#!/bin/bash

# Exit if any command fails
set -e

# Variables
SSH_PORT=2222  # Ensure this matches your existing SSH configuration

echo "Securing and updating the system..."

# Update and install necessary packages
echo "Updating system and installing required packages..."
sudo apt update && sudo apt full-upgrade -y
sudo apt install ufw fail2ban unattended-upgrades -y

# Enable and configure unattended upgrades
echo "Configuring unattended updates..."
sudo dpkg-reconfigure --priority=low unattended-upgrades

echo "Enabling and configuring unattended upgrades..."
sudo tee /etc/apt/apt.conf.d/50unattended-upgrades > /dev/null <<EOF
Unattended-Upgrade::Allowed-Origins {
    "\${distro_id}:\${distro_codename}-security";
    "\${distro_id}:\${distro_codename}-updates";
};
Unattended-Upgrade::Automatic-Reboot "true";
EOF

sudo tee /etc/apt/apt.conf.d/20auto-upgrades > /dev/null <<EOF
APT::Periodic::Update-Package-Lists "1";
APT::Periodic::Unattended-Upgrade "1";
EOF

# Verify unattended-upgrades
echo "Verifying unattended-upgrades configuration..."
sudo systemctl status unattended-upgrades | grep "active (running)" || echo "Unattended-upgrades did not start correctly!"

# Set up UFW firewall
echo "Configuring UFW..."
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow "$SSH_PORT"/tcp
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw allow 51820/udp  # WireGuard VPN
sudo ufw enable

# Install and configure Fail2Ban
echo "Configuring Fail2Ban..."
sudo apt install fail2ban -y

# Create custom Fail2Ban jail configuration
cat <<EOF | sudo tee /etc/fail2ban/jail.local
[DEFAULT]
bantime = 10m
findtime = 10m
maxretry = 5

[sshd]
enabled = true
port = $SSH_PORT
EOF

# Restart Fail2Ban service
sudo systemctl restart fail2ban

# Verify Fail2Ban status
echo "Verifying Fail2Ban service..."
sudo systemctl status fail2ban | grep "active (running)" || echo "Fail2Ban did not start correctly!"

echo "System updates applied successfully!"
echo "Firewall and Fail2Ban protections are in place!"
echo "Unattended updates have been configured and enabled!"
