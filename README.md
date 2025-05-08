 Rasptor

**Rasptor** is a lightweight tool for Raspberry Pi Zero/2W that routes all system traffic through the [Tor network](https://www.torproject.org). It also provides a safe way to disable or toggle this routing without breaking your system.

**Maintained by [L4ser Security Labs](mailto:l4sersec@gmail.com)**

---

## 🧰 Features

- Route all system traffic through Tor
- Roll back to normal internet routing anytime
- One-command toggle
- Debian package for easy install/remove

---

## 📦 Installation
```sudo dpkg -i rasptor.deb```

Or download and install from Cloudsmith:

wget https://dl.cloudsmith.io/public/l4ser-security-labs/rasptor/deb/any-distro/pool/any-version/main/r/ra/rasptor_1.0/rasptor1.0_all.deb
```sudo dpkg -i rasptor_1.0_all.deb```

Make sure you have tor and iptables installed:
``` sh
sudo apt update
sudo apt install tor iptables -y
```

## 🚀 Usage
Enable Tor routing:
```sudo enable_rasptor_.sh```

Disable Tor routing:
```sudo disable_rasptor_sh```

Toggle routing (automatically switches based on Tor state):
```sudo toggle-tor-routing.sh```

## ❌ Uninstallation
```sudo dpkg -r rasptor```

## 🧪 Build from Source
``` sh
git clone https://github.com/l4sersec/rasptor.git
cd rasptor
dpkg-deb --build rasptor
```
