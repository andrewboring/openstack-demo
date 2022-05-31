
#!/bin/sh

echo "===== Installing Nova ====="
echo "  "

#source /root/.my.cnf

echo "== Creating Nova Database =="
mysql --user=root --password=$PASSWORD <<QUERY
CREATE DATABASE nova_api;
CREATE DATABASE nova;
CREATE DATABASE nova_cell0;
GRANT ALL PRIVILEGES ON nova_api.* TO 'nova'@'localhost' IDENTIFIED BY '$PASSWORD';
GRANT ALL PRIVILEGES ON nova_api.* TO 'nova'@'%' IDENTIFIED BY '$PASSWORD';
GRANT ALL PRIVILEGES ON nova.* TO 'nova'@'localhost' IDENTIFIED BY '$PASSWORD';
GRANT ALL PRIVILEGES ON nova.* TO 'nova'@'%' IDENTIFIED BY '$PASSWORD';
GRANT ALL PRIVILEGES ON nova_cell0.* TO 'nova'@'localhost' IDENTIFIED BY '$PASSWORD';
GRANT ALL PRIVILEGES ON nova_cell0.* TO 'nova'@'%' IDENTIFIED BY '$PASSWORD';
QUERY


source /root/.admin-openrc

openstack user create --domain default --password=$PASSWORD nova
openstack role add --project service --user nova admin
openstack service create --name nova --description "Compute Service" compute
openstack endpoint create --region ATL nova public http://controller.local:8774/v2.1
openstack endpoint create --region ATL nova internal http://controller.local:8774/v2.1
openstack endpoint create --region ATL nova admin http://controller.local:8774/v2.1

yum -y install openstack-nova-api openstack-nova-conductor openstack-nova-novncproxy openstack-nova-scheduler



cp /tmp/vagrant/config/etc/nova/nova.conf /etc/nova/nova.conf
sed -i s/MYIP/$IP4/g /etc/nova/nova.conf
sed -i s/MYPASSWORD/$PASSWORD/g /etc/nova/nova.conf

su -s /bin/sh -c "nova-manage api_db sync" nova
su -s /bin/sh -c "nova-manage cell_v2 map_cell0" nova
su -s /bin/sh -c "nova-manage cell_v2 create_cell --name=cell1 --verbose" nova
su -s /bin/sh -c "nova-manage db sync" nova

su -s /bin/sh -c "nova-manage cell_v2 list_cells" nova

systemctl enable openstack-nova-api.service openstack-nova-scheduler.service openstack-nova-conductor.service openstack-nova-novncproxy.service
systemctl start openstack-nova-api.service openstack-nova-scheduler.service openstack-nova-conductor.service openstack-nova-novncproxy.service

#systemctl restart httpd