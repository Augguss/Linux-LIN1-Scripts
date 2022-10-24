#!/bin/bash
#Config LIN1-SRV-02

declare IP="10.10.10.22"
declare hostname="SRV-LIN1-02"
declare gateway="10.10.10.2"
declare mask="255.255.255.0"
declare domain="lin1.local"

echo Starting Script . . .
echo $IP
echo $hostname
echo $gateway
echo $mask
echo $domain

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

# The loopback network interface is scripted with variables !
auto lo
iface lo inet loopback

# The primary network interface
auto ens32
iface ens32 inet static
address $IP
netmask $mask
gateway $gateway

EOM

#DNS et Gateway Config
name_FILE="/etc/resolv.conf"
cat <<EOM >$name_FILE
#Scripted

domain $domain
search $domain
nameserver 10.10.10.11
nameserver 10.10.10.2

EOM

sudo echo All good !
