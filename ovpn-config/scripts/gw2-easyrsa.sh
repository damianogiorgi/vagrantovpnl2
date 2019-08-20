#!/bin/bash
mkdir -p /etc/openvpn/keys
cp /vagrant/ovpn-config/certs/ca.crt  /etc/openvpn/keys/
cp /vagrant/ovpn-config/certs/gw2.crt /etc/openvpn/keys
cp /vagrant/ovpn-config/certs/gw2.key /etc/openvpn/keys
