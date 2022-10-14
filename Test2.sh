#!/bin/bash

declare IP="10.10.10.110"
declare hostname="SRV-LIN1-02"
declare gateway="10.10.10.2"

echo Starting Script . . .
echo $IP
echo $hostname

sudo hostname $hostname
sudo echo $hostname > /etc/hostname
sudo echo $hostname > /etc/hosts

sudo bash -c 'cat > /etc/network/interfaces << EOF 
source /etc/network/interfaces.d/*

# The loopback network interface is SCRIPTED
auto lo
iface lo inet loopback

allow-hotplug ens32
iface ens32 inet static
address 10.10.10.110
netmask 255.255.255.0
gateway 10.10.10.2
EOF'

sudo echo All good !
