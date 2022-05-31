#!/bin/sh

echo "===== Installing Horizon ====="
echo " "
yum -y install openstack-dashboard


cp /tmp/vagrant/etc/openstack-dashboard/local_settings /etc/openstack-dashboard/local_settings
cp /tmp/vagrant/etc/httpd/conf.d/openstack-dashboard.conf /etc/httpd/conf.d/openstack-dashboard.conf

systemctl restart httpd.service memcached.service