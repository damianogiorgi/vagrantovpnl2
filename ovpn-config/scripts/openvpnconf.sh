#!/bin/bash


echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.conf
sysctl -p
cp -f /vagrant/ovpn-config/$1/openvpn.conf /etc/openvpn/
cp -f /vagrant/ovpn-config/scripts/bridge-start /etc/openvpn/
chmod +x  /etc/openvpn/bridge-start
cp -f /vagrant/ovpn-config/$1/bridge-conf* /etc/openvpn/
cp -f /vagrant/ovpn-config/scripts/bridge-stop /etc/openvpn/
chmod +x  /etc/openvpn/bridge-stop
cp -f /vagrant/ovpn-config/scripts/openvpn@.service  /etc/systemd/system
systemctl daemon-reload
systemctl enable openvpn@$1
systemctl start openvpn@$1