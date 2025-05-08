#!/bin/bash

set -e

echo "[+] Checcking for Tor and updating..."
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
