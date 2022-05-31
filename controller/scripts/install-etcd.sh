#!/bin/sh


echo "==== Installing etcd ====="
echo " "
yum -y install etcd

mv /etc/etcd/etcd.conf /etc/etcd/etcd.conf_DEFAULT
cp /tmp/vagrant/config/etc/etcd/etcd.conf /etc/etcd/etcd.conf
sed -i s/localhost/$IP4/g /etc/etcd/etcd.conf

systemctl enable etcd.service
systemctl start etcd.service
