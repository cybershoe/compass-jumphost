#!/bin/bash

sudo apt update -y

sudo apt install xfce4 xfce4-goodies gnupg chromium-browser -y
sudo apt install xrdp -y
sudo update-alternatives --set x-session-manager /usr/bin/startxfce4

wget -qO- https://www.mongodb.org/static/pgp/server-8.0.asc | sudo tee /etc/apt/trusted.gpg.d/server-8.0.asc
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu noble/mongodb-org/8.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-8.0.list

# curl -fsSL https://pgp.mongodb.com/server-7.0.asc | sudo gpg -o /usr/share/keyrings/mongodb-server-7.0.gpg --dearmor
# echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-7.0.gpg ] https://repo.mongodb.org/apt/ubuntu noble/mongodb-org/7.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-7.0.list

sudo apt update -y
sudo apt-get install -y mongodb-atlas
wget https://downloads.mongodb.com/compass/mongodb-compass_1.44.5_amd64.deb
sudo apt install ./mongodb-compass_1.44.5_amd64.deb
mkdir -p -m 0755 /home/ubuntu/Desktop
chown ubuntu:ubuntu /home/ubuntu/Desktop
echo -e "[Desktop Entry]\nVersion=1.0\nType=Application\nName=MongoDB Compass\nComment=The MongoDB GUI\nExec=mongodb-compass %U\nIcon=mongodb-compass\nPath=\nTerminal=false\nStartupNotify=true"  | tee "/usr/share/applications/MongoDB Compass.desktop"
ln -s "/usr/share/applications/MongoDB Compass.desktop" "/home/ubuntu/Desktop/MongoDB Compass.desktop"
# chown ubuntu:ubuntu "/home/ubuntu/Desktop/MongoDB Compass.desktop"
# gio set -t string "/home/ubuntu/Desktop/MongoDB Compass.dekstop" metadata::xfce-exe-checksum "$(sha256sum "/home/ubuntu/Desktop/MongoDB Compass.dekstop"} | awk '{print $1}')"
echo "ubuntu:Temp1234!" | sudo chpasswd
