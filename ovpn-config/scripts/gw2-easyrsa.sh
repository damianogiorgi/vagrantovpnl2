#!/bin/bash
mkdir -p /etc/openvpn/keys

# Copy gw1 generated certs from vagrant shared folder
cp /vagrant/ovpn-config/certs/ca.crt  /etc/openvpn/keys/
cp /vagrant/ovpn-config/certs/gw2.crt /etc/openvpn/keys
cp /vagrant/ovpn-config/certs/gw2.key /etc/openvpn/keys
