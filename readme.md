# Raspbian
### Install Raspbian OS
Follow the instructions on the [Raspberry Pi website](https://www.raspberrypi.com/documentation/computers/getting-started.html#raspberry-pi-imager) to add the latest Raspbian OS to a micro SD card

### Update Raspbian OS
`sudo apt update`

`sudo apt full-upgrade`

# Git
### Install Git
`sudo apt install git -y`

### Clone this repository
`git init`

`git remote add origin URL`

`git pull`

# Docker
### Install Docker
`curl -sSL https://get.docker.com | sh`

### Add the current user to the 'docker' group
`sudo usermod -aG docker $USER`

### Restart the machine
`sudo reboot`

# Updating containers
This pulls the latest Pihole, Nginx and Home Assistant containers:

`docker compose pull`

# Setting up DNS
### Get a static IP from your ISP
If this is not possible, consider using [Duck DNS](https://www.duckdns.org/)

### Create A records pointing to the IP
One record for each service; these can be proxied by Cloudflare
- pihole
- homeassistant
- calibre
- static_site

Wireguard should not be proxied by Cloudflare
- wg

### Forward ports on your router
| Service | External Port | Internal IP | Internal Port | Protocol |
|---------|---------------|-------------|---------------|----------|
| HTTP | 80 | 192.168.4.48 | 80 | TCP |
| HTTPS | 443 | 192.168.4.48 | 443 | TCP |
| Wireguard VPN | 51820 | 192.168.4.48 | 51820 | UDP |

### Allow ports on the Pi firewall

```
sudo ufw enable

sudo ufw allow 80/tcp      # HTTP
sudo ufw allow 443/tcp     # HTTPS
sudo ufw allow 51820/udp   # WireGuard VPN
```