# Raspbian
### Install Raspbian OS
Follow the instructions on the [Raspberry Pi website](https://www.raspberrypi.com/documentation/computers/getting-started.html#raspberry-pi-imager) to add the latest Raspbian OS to a micro SD card

### Set up SSH keys
Run the `setup_remote_ssh.sh` script on the remote computer
- Remember to set the RPi's IP and username in the script before running

Use the resulting connect.sh to SSH in to the RPi

### Harden the RPi's security settings
Run `sh secure_pi.sh`

Note that SSH login with password authentication will no longer be possible

### Clone this repository
`git clone https://github.com/uppertoe/pi-setup.git`

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

### Create an A record pointing to the IP
Simply send the wildcard apex domain * to the static IP; the reverse proxy will handle the subdomains.

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