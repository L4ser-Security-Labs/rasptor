#!/bin/bash
set -e

echo "[*] Disabling Tor routing..."

# Stop Tor
systemctl stop tor
systemctl disable tor

# Restore iptables
if [ -f /etc/iptables.rules.bak ]; then
  iptables-restore < /etc/iptables.rules.bak
  echo "[*] iptables restored."
else
  echo "[!] No iptables backup found, flushing rules instead."
  iptables -F
  iptables -t nat -F
fi

echo "[*] Tor routing disabled."
