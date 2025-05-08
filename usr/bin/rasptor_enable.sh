#!/bin/bash

set -e

echo "[+] Installing Tor..."
sudo apt update
sudo apt install tor iptables-persistent curl -y

echo "[+] Backing up torrc..."
sudo cp /etc/tor/torrc /etc/tor/torrc.backup

echo "[+] Configuring torrc..."
sudo bash -c 'cat > /etc/tor/torrc' <<EOF
VirtualAddrNetworkIPv4 10.192.0.0/10
AutomapHostsOnResolve 1
TransPort 9040
DNSPort 5353
EOF

echo "[+] Restarting Tor..."
sudo systemctl restart tor
sleep 5

echo "[+] Flushing old iptables rules..."
sudo iptables -F
sudo iptables -t nat -F

echo "[+] Setting up iptables redirection..."
sudo iptables -t nat -A OUTPUT -m owner --uid-owner debian-tor -j RETURN
sudo iptables -t nat -A OUTPUT -d 127.0.0.1/32 -j RETURN
sudo iptables -t nat -A OUTPUT -p tcp --syn -j REDIRECT --to-ports 9040
sudo iptables -t nat -A OUTPUT -p udp --dport 53 -j REDIRECT --to-ports 5353

echo "[+] Saving iptables rules..."
sudo netfilter-persistent save

echo "[✓] Tor transparent proxy is now active."

# Perform Tor routing check
echo "[*] Verifying routing through Tor..."
if curl --socks5-hostname 127.0.0.1:9050 -s https://check.torproject.org | grep -q "Congratulations"; then
  echo "[✓] Success: System is routing traffic through Tor!"
else
  echo "[!] Warning: Traffic is not routing through Tor. Please investigate."
fi


# #!/bin/bash
# set -e

# echo "[*] Enabling Tor routing..."

# # Stop systemd-resolved if running (DNS conflict)
# if systemctl is-active --quiet systemd-resolved; then
#   echo "[*] Disabling systemd-resolved..."
#   systemctl disable --now systemd-resolved
# fi

# # Fix resolv.conf for local DNS
# echo "[*] Setting /etc/resolv.conf to use 127.0.0.1..."
# rm -f /etc/resolv.conf
# echo "nameserver 127.0.0.1" > /etc/resolv.conf

# # Ensure torrc contains Rasptor block
# TORRC_PATH="/etc/tor/torrc"
# TORRC_MARK="# Rasptor Routing Block"
# if ! grep -q "$TORRC_MARK" "$TORRC_PATH"; then
#   echo "[*] Updating torrc with Rasptor settings..."
#   cat <<EOT >> "$TORRC_PATH"

# $TORRC_MARK
# VirtualAddrNetworkIPv4 10.192.0.0/10
# AutomapHostsOnResolve 1
# TransPort 9040
# DNSPort 9053
# EOT
# else
#   echo "[*] Rasptor settings already exist in torrc."
# fi

# # Restart Tor
# echo "[*] Restarting Tor service..."
# systemctl enable tor
# systemctl restart tor
# sleep 5

# # Backup and flush iptables
# echo "[*] Backing up iptables and applying transparent proxy rules..."
# iptables-save > /etc/iptables.rules.bak
# iptables -F
# iptables -t nat -F

# # Redirect all DNS and TCP traffic to Tor
# TOR_UID=$(id -u debian-tor)

# iptables -t nat -A OUTPUT -p udp --dport 53 -j REDIRECT --to-ports 9053
# iptables -t nat -A OUTPUT -p tcp --syn -j REDIRECT --to-ports 9040

# iptables -A OUTPUT -m owner --uid-owner $TOR_UID -j ACCEPT
# iptables -A OUTPUT -d 127.0.0.1/32 -j ACCEPT
# iptables -A OUTPUT -j REJECT

# echo "[✓] Tor routing enabled."

# # Check Tor status
# echo "[*] Checking if system is using Tor..."
# if curl --socks5-hostname 127.0.0.1:9050 -s https://check.torproject.org | grep -q "Congratulations"; then
#   echo "[✓] System is successfully routing through Tor!"
# else
#   echo "[!] Tor routing enabled, but check failed. Please verify manually."
# fi
