#!/bin/bash
set -e

echo "[*] Enabling Tor routing..."

# Backup current iptables
iptables-save > /etc/iptables.rules.bak

# Enable Tor service
systemctl enable tor
systemctl start tor

# Set up iptables to route through Tor
iptables -F
iptables -t nat -F
iptables -t nat -A OUTPUT -m owner ! --uid-owner debian-tor -p tcp --syn -j REDIRECT --to-ports 9040
iptables -A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A OUTPUT -m owner --uid-owner debian-tor -j ACCEPT
iptables -A OUTPUT -d 127.0.0.1/32 -j ACCEPT
iptables -A OUTPUT -j REJECT

echo "[*] Tor routing enabled."
