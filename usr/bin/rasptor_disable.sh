#!/bin/bash

set -e

echo "[+] Stopping Tor service..."
sudo systemctl stop tor

echo "[+] Restoring original torrc..."
if [ -f /etc/tor/torrc.backup ]; then
  sudo mv /etc/tor/torrc.backup /etc/tor/torrc
  echo "[✓] torrc restored from backup."
else
  echo "[!] No torrc backup found. Skipping restore."
fi

echo "[+] Flushing iptables rules..."
sudo iptables -F
sudo iptables -t nat -F

echo "[+] Saving clean iptables state..."
sudo netfilter-persistent save

echo "[✓] Tor routing has been disabled. System is now using normal internet."
