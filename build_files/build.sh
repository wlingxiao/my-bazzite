#!/bin/bash

set -ouex pipefail

dnf downgrade -y mt7xxx-firmware-20250311-1.fc42

mkdir -p /var/opt

dnf5 install --setopt=install_weak_deps=False -y --enablerepo="google-chrome" google-chrome-stable
sed -i 's@enabled=1@enabled=0@g' "/etc/yum.repos.d/google-chrome.repo"

dnf5 install -y https://github.com/clash-verge-rev/clash-verge-rev/releases/download/v2.4.2/Clash.Verge-2.4.2-1.x86_64.rpm

# VSCode
tee /etc/yum.repos.d/vscode.repo <<'EOF'
[code]
name=Visual Studio Code
baseurl=https://packages.microsoft.com/yumrepos/vscode
enabled=1
gpgcheck=1
gpgkey=https://packages.microsoft.com/keys/microsoft.asc
EOF

dnf5 install --setopt=install_weak_deps=False -y code
dnf5 -y copr disable vscode

bash /ctx/fix-opt.sh
bash /ctx/cleanup.sh
