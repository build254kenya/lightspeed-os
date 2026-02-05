#!/usr/bin/env bash
set -e

echo "=============================="
echo " Building Lightspeed OS"
echo " Debloating GNOME"
echo "=============================="

# --------------------------------
# OS Identity
# --------------------------------
cat <<EOF >/usr/lib/os-release
NAME="Lightspeed OS"
PRETTY_NAME="Lightspeed OS (GNOME)"
ID=lightspeed
ID_LIKE=fedora
VERSION_ID=0.1
VERSION="0.1 (Lightspeed)"
PLATFORM_ID="platform:f41"
ANSI_COLOR="0;36"
LOGO=fedora-logo-icon
HOME_URL="https://github.com/Lightspeedke/lightspeed-os"
SUPPORT_URL="https://github.com/Lightspeedke/lightspeed-os/issues"
BUG_REPORT_URL="https://github.com/Lightspeedke/lightspeed-os/issues"
EOF

hostnamectl set-hostname lightspeed

# --------------------------------
# Safe boot optimizations
# --------------------------------
systemctl disable NetworkManager-wait-online.service || true

# --------------------------------
# GNOME Debloat (SAFE)
# --------------------------------
echo "Removing GNOME bloat"

rpm-ostree override remove \
  gnome-tour \
  gnome-contacts \
  gnome-weather \
  gnome-maps \
  gnome-characters \
  gnome-clocks \
  gnome-connections \
  yelp \
  cheese \
  simple-scan || true

# --------------------------------
# Reduce journal size
# --------------------------------
mkdir -p /etc/systemd/journald.conf.d
cat <<EOF >/etc/systemd/journald.conf.d/size.conf
[Journal]
SystemMaxUse=200M
EOF

# --------------------------------
# Finish
# --------------------------------
echo "Lightspeed OS debloat complete"
