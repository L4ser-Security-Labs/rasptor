#!/bin/bash
set -e

echo "[*] Disabling Tor routing..."

# Restore resolv.conf
echo "[*] Restoring resolv.conf to use Google's DNS..."
echo "nameserver 8.8.8.8" > /etc/resolv.conf

# Re-enable systemd-resolved if desired
if [ -f /lib/systemd/system/systemd-resolved.service ]; then
  echo "[*] Re-enabling systemd-resolved..."
  systemctl enable --now systemd-resolved || true
fi

# Remove Rasptor settings from torrc
TORRC_PATH="/etc/tor/torrc"
TORRC_MARK="# Rasptor Routing Block"
if grep -q "$TORRC_MARK" "$TORRC_PATH"; then
  echo "[*] Cleaning torrc..."
  sed -i "/$TORRC_MARK/,+4d" "$TORRC_PATH"
fi

# Stop Tor
echo "[*] Stopping Tor..."
systemctl stop tor
systemctl disable tor

# Restore iptables
if [ -f /etc/iptables.rules.bak ]; then
  echo "[*] Restoring previous iptables rules..."
  iptables-restore < /etc/iptables.rules.bak
else
  echo "[!] No iptables backup. Flushing rules."
  iptables -F
  iptables -t nat -F
fi

echo "[✓] Tor routing disabled."
