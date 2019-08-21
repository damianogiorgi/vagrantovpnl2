#!/bin/bash
yum install -y easy-rsa

# Copy default variables
cp -f /vagrant/ovpn-config/scripts/easyrsa-vars  /usr/share/easy-rsa/3/vars

# Build pki 
cd /usr/share/easy-rsa/3/
/usr/share/easy-rsa/3/easyrsa --batch init-pki
/usr/share/easy-rsa/3/easyrsa --batch build-ca nopass
/usr/share/easy-rsa/3/easyrsa --batch gen-dh nopass
/usr/share/easy-rsa/3/easyrsa --batch build-server-full gw1 nopass
/usr/share/easy-rsa/3/easyrsa --batch build-client-full gw2 nopass

# Copy certs to openvpn dir
mkdir -p /etc/openvpn/keys
chmod +x /usr/share/easy-rsa/3/vars
cp /usr/share/easy-rsa/3/pki/ca.crt  /etc/openvpn/keys/
cp /usr/share/easy-rsa/3/pki/dh.pem  /etc/openvpn/keys/
cp /usr/share/easy-rsa/3/pki/issued/gw1.crt /etc/openvpn/keys
cp /usr/share/easy-rsa/3/pki/private/gw1.key /etc/openvpn/keys

# Copy certs and keys to vagrant shared folder to provision gw2 openvpn 
mkdir -p /vagrant/ovpn-config/certs/
cp -f /usr/share/easy-rsa/3/pki/issued/gw2.crt /vagrant/ovpn-config/certs/
cp -f /usr/share/easy-rsa/3/pki/private/gw2.key  /vagrant/ovpn-config/certs/
cp -f /usr/share/easy-rsa/3/pki/ca.crt  /vagrant/ovpn-config/certs/