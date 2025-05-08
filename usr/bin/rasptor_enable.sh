#!/bin/bash
set -e

echo "[*] Enabling Tor routing..."

# Backup iptables
iptables-save > /etc/iptables.rules.bak

# Flush iptables
iptables -F
iptables -t nat -F

# Ensure torrc has correct routing config
TORRC_PATH="/etc/tor/torrc"
TORRC_MARK="# Rasptor Routing Block"
if ! grep -q "$TORRC_MARK" "$TORRC_PATH"; then
  echo "[*] Updating /etc/tor/torrc..."
  cat <<EOT >> "$TORRC_PATH"

$TORRC_MARK
VirtualAddrNetworkIPv4 10.192.0.0/10
AutomapHostsOnResolve 1
TransPort 9040
DNSPort 9053
EOT
else
  echo "[*] torrc already configured."
fi

# Restart Tor to apply config
echo "[*] Starting Tor..."
systemctl enable tor
systemctl restart tor
sleep 5

# Set up iptables for Tor routing
TOR_UID=$(id -u debian-tor)

iptables -A OUTPUT -o lo -j ACCEPT
iptables -A OUTPUT -m owner --uid-owner $TOR_UID -j ACCEPT
iptables -t nat -A OUTPUT -p udp --dport 53 -j REDIRECT --to-ports 9053
iptables -t nat -A OUTPUT -p tcp --syn -j REDIRECT --to-ports 9040
iptables -A OUTPUT -j REJECT

echo "[✓] Tor routing is now enabled."
