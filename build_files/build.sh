#!/bin/bash

set -ouex pipefail

chmod +x /ctx/cleanup.sh

dnf downgrade -y mt7xxx-firmware-20250311-1.fc42

mv /opt{,.bak} && mkdir /opt
dnf5 install -y https://github.com/clash-verge-rev/clash-verge-rev/releases/download/v2.4.2/Clash.Verge-2.4.2-1.x86_64.rpm

dnf5 install -y --enablerepo="google-chrome" google-chrome-stable

mv /opt/google/chrome /usr/lib/google-chrome
ln -sf /usr/lib/google-chrome/google-chrome /usr/bin/google-chrome-stable
mkdir -p usr/share/icons/hicolor/{16x16/apps,24x24/apps,32x32/apps,48x48/apps,64x64/apps,128x128/apps,256x256/apps}
for i in "16" "24" "32" "48" "64" "128" "256"; do
    ln -sf /usr/lib/google-chrome/product_logo_$i.png /usr/share/icons/hicolor/${i}x${i}/apps/google-chrome.png
done
rm -rf /etc/cron.daily
rmdir /opt/{google,}
mv /opt{.bak,}

sed -i 's@enabled=1@enabled=0@g' "/etc/yum.repos.d/google-chrome.repo"


# VSCode because it's still better for a lot of things
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

/ctx/cleanup.sh
