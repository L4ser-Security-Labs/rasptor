#!/bin/bash
set -e

echo "[*] Disabling Tor routing..."

# Stop Tor
systemctl stop tor
systemctl disable tor

# Restore iptables
if [ -f /etc/iptables.rules.bak ]; then
  iptables-restore < /etc/iptables.rules.bak
  echo "[*] iptables restored from backup."
else
  echo "[!] No iptables backup found. Flushing as fallback."
  iptables -F
  iptables -t nat -F
fi

# Remove Rasptor routing block from torrc
TORRC_PATH="/etc/tor/torrc"
TORRC_MARK="# Rasptor Routing Block"
if grep -q "$TORRC_MARK" "$TORRC_PATH"; then
  sed -i "/$TORRC_MARK/,+4d" "$TORRC_PATH"
  echo "[*] Removed Rasptor routing block from torrc."
fi

echo "[✓] Tor routing is now disabled."
