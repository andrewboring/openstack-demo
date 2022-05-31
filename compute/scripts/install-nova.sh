#!/bin/sh

echo "===== Installing Nova ====="
echo " "
yum -y install openstack-nova-compute




#echo "===== Updating /etc/hosts ====="
#echo "$IP4 controller.example.com controller" >> /etc/hosts

cp /tmp/vagrant/config/etc/nova/nova.conf /etc/nova/nova.conf
sed -i s/MYIP/$IP4/g /etc/nova/nova.conf
sed -i s/MYPASSWORD/$PASSWORD/g /etc/nova/nova.conf
getent hosts controller.local >> /etc/hosts

systemctl enable libvirtd.service openstack-nova-compute.service
systemctl start libvirtd.service openstack-nova-compute.service

