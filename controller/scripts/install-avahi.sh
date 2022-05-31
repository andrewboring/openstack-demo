#!/bin/sh

echo "===== Installing mDNS ====="
echo " "
yum -y install avahi 
systemctl enable avahi-daemon.service
systemctl start avahi-daemon.service

yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
yum -y install nss-mdns