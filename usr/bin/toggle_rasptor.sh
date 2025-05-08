#!/bin/bash

if systemctl is-active --quiet tor; then
  echo "[*] Tor is active. Disabling routing..."
  /usr/local/bin/disable-tor-routing.sh
else
  echo "[*] Tor is inactive. Enabling routing..."
  /usr/local/bin/enable-tor-routing.sh
fi
