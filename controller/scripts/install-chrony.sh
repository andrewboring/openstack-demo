#!/bin/sh

echo "===== Installing Chrony ====="
echo " "
yum -y install chrony 
systemctl enable chronyd.service
systemctl start chronyd.service
