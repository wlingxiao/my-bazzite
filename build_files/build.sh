#!/bin/bash

set -ouex pipefail

# dnf downgrade -y mt7xxx-firmware-20250311-1.fc42

mkdir -p /var/opt

dnf5 install --setopt=install_weak_deps=False -y --enablerepo="google-chrome" google-chrome-stable
rm -rf /etc/cron.daily
sed -i 's@enabled=1@enabled=0@g' "/etc/yum.repos.d/google-chrome.repo"

# /ctx/github-release-install.sh clash-verge-rev/clash-verge-rev x86_64
/ctx/github-release-install.sh Automattic/simplenote-electron x86_64
/ctx/github-release-install.sh xishang0128/sparkle x86_64

dnf5 install --setopt=install_weak_deps=False -y mpv \
    vlc-plugin-bittorrent \
    vlc-plugin-ffmpeg \
    vlc-plugin-kde \
    vlc-plugin-pause-click \
    vlc

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
sed -i 's@enabled=1@enabled=0@g' "/etc/yum.repos.d/vscode.repo"

/ctx/fix-opt.sh
/ctx/cleanup.sh
