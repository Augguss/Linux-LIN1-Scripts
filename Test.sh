#!/bin/bash

declare IP="10.10.10.55"
declare hostname="SRV-LIN1-02"


echo Starting Script . . .
echo $IP
echo $hostname

sudo hostname $hostname
sudo echo $hostname > /etc/hostname
sudo echo $hostname > /etc/hosts