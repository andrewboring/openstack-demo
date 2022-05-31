
#!/bin/sh

echo "===== Installing Placement ====="
echo "  "

#source /root/.my.cnf

echo "== Creating Placement Database =="
mysql --user=root --password=$PASSWORD <<QUERY
CREATE DATABASE placement;
GRANT ALL PRIVILEGES ON placement.* TO 'placement'@'localhost' IDENTIFIED BY '$PASSWORD';
GRANT ALL PRIVILEGES ON placement.* TO 'placement'@'%' IDENTIFIED BY '$PASSWORD';
QUERY
echo "== Placement Created =="

source /root/.admin-openrc

openstack user create --domain default --password=$PASSWORD placement
openstack role add --project service --user placement admin
openstack service create --name placement --description "Placement API" placement
openstack endpoint create --region ATL placement public http://controller.local:8778
openstack endpoint create --region ATL placement internal http://controller.local:8778
openstack endpoint create --region ATL placement admin http://controller.local:8778

yum -y install openstack-placement-api




cp /tmp/vagrant/config/etc/placement/placement.conf /etc/placement/placement.conf
sed -i s/MYPASSWORD/$PASSWORD/g /etc/placement/placement.conf

cp /tmp/vagrant/config/etc/httpd/conf.d/00-placement-api.conf /etc/httpd/conf.d/00-placement-api.conf
su -s /bin/sh -c "placement-manage db sync" placement

systemctl restart httpd