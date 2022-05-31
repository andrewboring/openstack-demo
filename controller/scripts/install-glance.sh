#!/bin/sh

echo "===== Installing Glance ====="
echo "  "

#source /root/.my.cnf

echo "== Creating Glance Database =="
mysql --user=root --password=$PASSWORD <<QUERY
CREATE DATABASE glance;
GRANT ALL PRIVILEGES ON glance.* TO 'glance'@'localhost' IDENTIFIED BY '$PASSWORD';
GRANT ALL PRIVILEGES ON glance.* TO 'glance'@'%' IDENTIFIED BY '$PASSWORD';
QUERY
echo "== Glance Database Created =="

source /root/.admin-openrc

openstack user create --domain default --password=$PASSWORD glance
openstack role add --project service --user glance admin
openstack service create --name glance --description "OpenStack Image" image
openstack endpoint create --region ATL image public http://controller.local:9292
openstack endpoint create --region ATL image internal http://controller.local:9292
openstack endpoint create --region ATL image admin http://controller.local:9292

yum -y install openstack-glance




cp /tmp/vagrant/config/etc/glance/glance-api.conf /etc/glance/glance-api.conf
sed -i s/MYPASSWORD/$PASSWORD/g /etc/glance/glance-api.conf

openstack role add --user glance --user-domain Default --system all reader
su -s /bin/sh -c "glance-manage db_sync" glance


systemctl enable openstack-glance-api.service
systemctl start openstack-glance-api.service