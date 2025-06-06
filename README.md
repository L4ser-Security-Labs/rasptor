 Rasptor

**Rasptor** is a lightweight tool for Raspberry Pi Zero/2W that routes all system traffic through the [Tor network](https://www.torproject.org). It also provides a safe way to disable or toggle this routing without breaking your system.

*NOTE: This isn't a Tor proxy — Rasptor transparently tunnels all outbound traffic through Tor at the OS level.*

**Maintained by [L4ser Security Labs](mailto:l4sersec@gmail.com)**

---

## 🧰 Features

- Route all system traffic through Tor
- Roll back to normal internet routing anytime
- One-command toggle
- Debian package for easy install/remove

---

## 📦 Installation
Make sure you have tor and iptables installed:
``` sh
sudo apt update
sudo apt install tor iptables -y
```

Download the latest binary from the Release page and the run:
```sudo dpkg -i rasptor_1.0_all.deb```

Or download and install from Cloudsmith:

``` sh
wget https://dl.cloudsmith.io/public/l4ser-security-labs/rasptor/deb/any-distro/pool/any-version/main/r/ra/rasptor_1.0/rasptor_1.0_all.deb
sudo dpkg -i rasptor_1.0_all.deb
```

## 🚀 Usage
Enable Tor routing:
```sudo rasptor```
then select Enable Tor routing

Disable Tor routing:
```sudo rasptor```
then select Disable Tor routing

Toggle routing (automatically switches based on Tor state):
```sudo rasptor```
then select Toggle Tor routing

## 📄 Info
```man rasptor```

## ❌ Uninstallation
```sudo dpkg -r rasptor```

## 🧪 Build from Source
``` sh
git clone https://github.com/l4sersec/rasptor.git
dpkg-deb --build rasptor
```
