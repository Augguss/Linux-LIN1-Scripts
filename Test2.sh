#!/bin/bash
#Config LIN1-SRV-02

declare IP="10.10.10.22"
declare hostname="SRV-LIN1-02"
declare gateway="10.10.10.2"

echo Starting Script . . .
echo $IP
echo $hostname

#hostname config 

sudo hostname $hostname
sudo echo $hostname > /etc/hostname
sudo echo $hostname > /etc/hosts

#IP config

net_FILE="/etc/network/interfaces"
cat <<EOM >$net_FILE

# This file describes the network interfaces available on your system
# and how to activate them. For more information, see interfaces(5).

source /etc/network/interfaces.d/*

# The loopback network interface is scripted !
auto lo
iface lo inet loopback

# The primary network interface
auto ens33
iface ens33 inet static
address 10.10.10.22
netmask 255.255.255.0
gateway 10.10.10.2

EOM

#DNS et Gateway Config
name_FILE="/etc/resolv.conf"
cat <<EOM >$name_FILE
#Scripted

domain lin1.local
search lin1.local
nameserver 10.10.10.11
nameserver 10.10.10.2

EOM



sudo echo All good !
