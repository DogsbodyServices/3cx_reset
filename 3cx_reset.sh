#!/bin/bash
#Script to configure 3CX Instances
#Written by A.Watson <info@thedc.space>

#Get Variables
read -p "Enter New Hostname: " hostname
#read -p "Enter Primary IP (192.168.1.0/24): " eth0
#read -p "Enter Secondary IP (10.0.0.0/24): " eth1

# Get Current eth0 Mac Address
mac="$(cat /sys/class/net/eth0/address)"

#Add Jessie Backports on new .list file
cat > /etc/apt/sources.list.d/jessie-backports.list << EOF
deb http://ftp.debian.org/debian jessie-backports main
EOF

# Create File to bind eth0 to MAC, MAC retrieved above..
cat > /etc/systemd/network/01-network.link << EOF
[Match]
MACAddress=${mac}

[Link]
Name=eth0
EOF

#Update sources
apt-get update

#Upgrade packages
apt-get -y upgrade 

#Change Hostname in Hostnames file
cat > /etc/hostname <<EOF
$hostname
EOF

#Change Temp Hostname
hostname $hostname

#Change Hostname in Hosts file
sed -i "2s/.*/"$eth0"	"$hostname".stratus-technologies.co.uk	"$hostname"/" /etc/hosts

#Change Ip Address
#sed -i "13s/.*/	address "$eth0"/" /etc/network/interfaces

#sed -i "25s/.*/	address "$eth1"/" /etc/network/interfaces

#Install Certbot
apt-get -y install certbot python-certbot-nginx --fix-missing -t jessie-backports

#Restart Services
/etc/init.d/hostname.sh start
service networking restart

# Write Startup File Here


#3CX Cleanup
/usr/sbin/3CXWizard --cleanup
