#!/bin/bash

declare IP="10.10.10.110"
declare hostname="SRV-LIN1-02"
declare gateway="10.10.10.2"
declare interface="
# This file describes the network interfaces available on your system/n
# and how to activate them. For more information, see interfaces(5)./n

source /etc/network/interfaces.d/*/n

# The loopback network interface/n
auto lo/n
iface lo inet loopback/n

allow-hotplug ens32/n
iface ens32 inet static/n
address 10.10.10.11/n
netmask 255.255.255.0/n
gateway 10.10.10.2/n"


echo Starting Script . . .
echo $IP
echo $hostname

sudo hostname $hostname
sudo echo $hostname > /etc/hostname
sudo echo $hostname > /etc/hosts

sudo echo $interface > /etc/network/interfaces
