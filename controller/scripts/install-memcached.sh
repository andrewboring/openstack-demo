#!/bin/sh


echo "==== Installing memcached ====="
echo " "
yum -y install memcached python3-memcached
sed -i s/127.0.0.1/$IP4/ /etc/sysconfig/memcached
systemctl enable memcached.service
systemctl start memcached.service
