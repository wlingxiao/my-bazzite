#!/bin/bash

set -ouex pipefail

dnf downgrade -y mt7xxx-firmware-20250311-1.fc42

mkdir -p /var/opt

dnf5 install --setopt=install_weak_deps=False -y --enablerepo="google-chrome" google-chrome-stable
rm -rf /etc/cron.daily
sed -i 's@enabled=1@enabled=0@g' "/etc/yum.repos.d/google-chrome.repo"

/ctx/github-release-install.sh clash-verge-rev/clash-verge-rev x86_64
/ctx/github-release-install.sh Automattic/simplenote-electron x86_64
/ctx/github-release-install.sh xishang0128/sparkle x86_64

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

# Resilio Sync
# https://help.resilio.com/hc/en-us/articles/206178924-Installing-Sync-package-on-Linux
tee /etc/yum.repos.d/resilio-sync.repo <<'EOF'
[resilio-sync]
name=Resilio Sync
baseurl=https://linux-packages.resilio.com/resilio-sync/rpm/\$basearch
enabled=1
gpgcheck=1
gpgkey=https://linux-packages.resilio.com/resilio-sync/key.asc
EOF
dnf5 install --setopt=install_weak_deps=False -y resilio-sync
sed -i 's@enabled=1@enabled=0@g' "/etc/yum.repos.d/resilio-sync.repo"
# https://aur.archlinux.org/cgit/aur.git/tree/rslsync_user.service?h=rslsync
sed -i 's@WantedBy=multi-user.target@WantedBy=default.target@g' "/usr/lib/systemd/user/resilio-sync.service"

/ctx/fix-opt.sh
/ctx/cleanup.sh
