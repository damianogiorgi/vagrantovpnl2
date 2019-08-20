# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|

  config.vm.provider "virtualbox" do |vb|
    vb.memory = "1024"
  end

  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://vagrantcloud.com/search.
  config.vm.box = "geerlingguy/centos7"

  config.vm.define "gw1" do |subconfig|
    subconfig.vm.hostname = "gw1"
    subconfig.vm.network :private_network, ip: "192.168.100.1", virtualbox__intnet: "client1"
    subconfig.vm.network :private_network, ip: "192.168.200.1", virtualbox__intnet: "gwnetwork"
    subconfig.vm.provider "virtualbox" do |virtualbox|
      virtualbox.customize ["modifyvm", :id, "--nicpromisc2", "allow-all"]
      virtualbox.customize ["modifyvm", :id, "--nicpromisc3", "allow-all"]
    end
    subconfig.vm.provision "shell", inline: <<-SHELL
      sudo yum install -y epel-release 
      sudo yum install -y openvpn.x86_64 bridge-utils easy-rsa tcpdump
      sudo echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.conf
      sudo sysctl -p
      cd /usr/share/easy-rsa/3/
      sudo /usr/share/easy-rsa/3/easyrsa --batch init-pki
      sudo /usr/share/easy-rsa/3/easyrsa --batch build-ca nopass
      sudo /usr/share/easy-rsa/3/easyrsa --batch gen-dh nopass
      sudo /usr/share/easy-rsa/3/easyrsa --batch build-server-full gw1 nopass
      sudo /usr/share/easy-rsa/3/easyrsa --batch build-client-full gw2 nopass
      sudo mkdir -p /etc/openvpn/keys
      sudo cp -f /vagrant/vars  /usr/share/easy-rsa/3/
      sudo chmod +x /usr/share/easy-rsa/3/vars
      sudo cp /usr/share/easy-rsa/3/pki/ca.crt  /etc/openvpn/keys/
      sudo cp /usr/share/easy-rsa/3/pki/dh.pem  /etc/openvpn/keys/
      sudo cp /usr/share/easy-rsa/3/pki/issued/gw1.crt /etc/openvpn/keys
      sudo cp /usr/share/easy-rsa/3/pki/private/gw1.key /etc/openvpn/keys
      sudo mkdir -p /vagrant/ovpn-config/certs/
      sudo cp -f /usr/share/easy-rsa/3/pki/issued/gw2.crt /vagrant/ovpn-config/certs/
      sudo cp -f /usr/share/easy-rsa/3/pki/private/gw2.key  /vagrant/ovpn-config/certs/
      sudo cp -f /usr/share/easy-rsa/3/pki/ca.crt  /vagrant/ovpn-config/certs/
      sudo cp -f /vagrant/ovpn-config/scripts/server.conf /etc/openvpn/
      sudo cp -f /vagrant/ovpn-config/scripts/bridge-start /etc/openvpn/
      sudo chmod +x  /etc/openvpn/bridge-start
      sudo cp -f /vagrant/ovpn-config/scripts/bridge-conf /etc/openvpn/
      sudo cp -f /vagrant/ovpn-config/scripts/bridge-stop /etc/openvpn/
      sudo chmod +x  /etc/openvpn/bridge-stop
      sudo cp -f /vagrant/ovpn-config/scripts/openvpn@.service  /etc/systemd/system
      sudo systemctl daemon-reload
      sudo systemctl enable openvpn@server
    SHELL

  end

  config.vm.define "gw2" do |subconfig|
    subconfig.vm.hostname = "gw2"
    subconfig.vm.network :private_network, ip: "192.168.100.2", virtualbox__intnet: "client2"
    subconfig.vm.network :private_network, ip: "192.168.200.2", virtualbox__intnet: "gwnetwork"
    subconfig.vm.provider "virtualbox" do |virtualbox|
      virtualbox.customize ["modifyvm", :id, "--nicpromisc2", "allow-all"]
      virtualbox.customize ["modifyvm", :id, "--nicpromisc3", "allow-all"]
    end
    subconfig.vm.provision "shell", inline: <<-SHELL
      sudo yum install -y epel-release 
      sudo yum install -y openvpn.x86_64 bridge-utils tcpdump
      sudo echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.conf
      sudo sysctl -p
      sudo mkdir -p /etc/openvpn/keys
      sudo cp -f /vagrant/ovpn-config/certs/gw2.crt /etc/openvpn/keys/
      sudo cp -f /vagrant/ovpn-config/certs/gw2.key  /etc/openvpn/keys/
      sudo cp /vagrant/ovpn-config/certs/ca.crt  /etc/openvpn/keys/
      sudo cp -f /vagrant/ovpn-config/scripts/client.conf /etc/openvpn/client
      sudo cp -f /vagrant/ovpn-config/scripts/openvpn-client@.service  /etc/systemd/system
      sudo cp -f /vagrant/ovpn-config/scripts/bridge-start-client /etc/openvpn/
      sudo chmod +x  /etc/openvpn/bridge-start-client
      sudo cp -f /vagrant/ovpn-config/scripts/bridge-conf-client /etc/openvpn/
      sudo cp -f /vagrant/ovpn-config/scripts/bridge-stop-client /etc/openvpn/
      sudo chmod +x  /etc/openvpn/bridge-stop-client
      sudo systemctl daemon-reload
      sudo systemctl enable openvpn-client@client

    SHELL
  end


  config.vm.define "client1" do |subconfig|
    subconfig.vm.hostname = "client1"
    subconfig.vm.network :private_network, ip: "192.168.100.10", virtualbox__intnet: "client1"
  end

  config.vm.define "client2" do |subconfig|
    subconfig.vm.hostname = "client2"
    subconfig.vm.network :private_network, ip: "192.168.100.20", virtualbox__intnet: "client2"
  end

  config.vm.define "client3" do |subconfig|
    subconfig.vm.hostname = "client3"
    subconfig.vm.network :private_network, ip: "192.168.100.30", virtualbox__intnet: "client2"
  end


  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # NOTE: This will enable public access to the opened port
  # config.vm.network "forwarded_port", guest: 80, host: 8080

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine and only allow access
  # via 127.0.0.1 to disable public access
  # config.vm.network "forwarded_port", guest: 80, host: 8080, host_ip: "127.0.0.1"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"
  
end
