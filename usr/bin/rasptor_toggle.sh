#!/bin/bash

if systemctl is-active --quiet tor; then
  echo "[*] Tor is active. Disabling routing..."
  /usr/bin/rasptor_disable.sh
else
  echo "[*] Tor is inactive. Enabling routing..."
  /usr/bin/rasptor_enable.sh
fi
