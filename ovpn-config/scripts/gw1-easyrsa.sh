#!/bin/bash
yum install -y easy-rsa

cd /usr/share/easy-rsa/3/
/usr/share/easy-rsa/3/easyrsa --batch init-pki
/usr/share/easy-rsa/3/easyrsa --batch build-ca nopass
/usr/share/easy-rsa/3/easyrsa --batch gen-dh nopass
/usr/share/easy-rsa/3/easyrsa --batch build-server-full gw1 nopass
/usr/share/easy-rsa/3/easyrsa --batch build-client-full gw2 nopass
mkdir -p /etc/openvpn/keys
cp -f /vagrant/vars  /usr/share/easy-rsa/3/
chmod +x /usr/share/easy-rsa/3/vars
cp /usr/share/easy-rsa/3/pki/ca.crt  /etc/openvpn/keys/
cp /usr/share/easy-rsa/3/pki/dh.pem  /etc/openvpn/keys/
cp /usr/share/easy-rsa/3/pki/issued/gw1.crt /etc/openvpn/keys
cp /usr/share/easy-rsa/3/pki/private/gw1.key /etc/openvpn/keys
mkdir -p /vagrant/ovpn-config/certs/
cp -f /usr/share/easy-rsa/3/pki/issued/gw2.crt /vagrant/ovpn-config/certs/
cp -f /usr/share/easy-rsa/3/pki/private/gw2.key  /vagrant/ovpn-config/certs/
cp -f /usr/share/easy-rsa/3/pki/ca.crt  /vagrant/ovpn-config/certs/