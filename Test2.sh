#!/bin/bash

declare IP="10.10.10.115"
declare hostname="SRV-LIN1-02"
declare gateway="10.10.10.2"

echo Starting Script . . .
echo $IP
echo $hostname

sudo hostname $hostname
sudo echo $hostname > /etc/hostname
sudo echo $hostname > /etc/hosts

net_FILE="/etc/network/interfaces"
cat <<EOM >$net_FILE

# This file describes the network interfaces available on your system
# and how to activate them. For more information, see interfaces(5).

source /etc/network/interfaces.d/*

# The loopback network interface is scripted !
auto lo
iface lo inet loopback

# The primary network interface
auto ens32
iface ens32 inet static
address 10.10.10.11
netmask 255.255.255.0
gateway 10.10.10.2

EOM

sudo echo All good !
