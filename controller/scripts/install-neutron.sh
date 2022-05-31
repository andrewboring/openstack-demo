
#!/bin/sh

echo "===== Installing Neutron ====="
echo "  "

#source /root/.my.cnf

echo "== Creating Nova Database =="
mysql --user=root --password=$PASSWORD <<QUERY
CREATE DATABASE neutron;
GRANT ALL PRIVILEGES ON neutron.* TO 'neutron'@'localhost' IDENTIFIED BY '$PASSWORD';
GRANT ALL PRIVILEGES ON neutron.* TO 'neutron'@'%' IDENTIFIED BY '$PASSWORD'; 
QUERY


/sbin/modprobe br_netfilter

source /root/.admin-openrc

openstack user create --domain default --password=$PASSWORD neutron
openstack role add --project service --user neutron admin
openstack service create --name neutron --description "OpenStack Networking" network
openstack endpoint create --region ATL network public http://controller.local:9696
openstack endpoint create --region ATL network internal http://controller.local:9696
openstack endpoint create --region ATL network admin http://controller.local:9696

yum -y install openstack-neutron openstack-neutron-ml2 openstack-neutron-linuxbridge ebtables



cp /tmp/vagrant/config/etc/neutron/neutron.conf /etc/neutron/neutron.conf
cp /tmp/vagrant/config/etc/neutron/plugins/ml2/ml2_conf.ini /etc/neutron/plugins/ml2/ml2_conf.ini
cp /tmp/vagrant/config/etc/neutron/plugins/ml2/linuxbridge_agent.ini /etc/neutron/plugins/ml2/linuxbridge_agent.ini
cp /tmp/vagrant/config/etc/neutron/dhcp_agent.ini /etc/neutron/dhcp_agent.ini
cp /tmp/vagrant/config/etc/neutron/metadata_agent.ini /etc/neutron/metadata_agent.ini
sed -i s/MYIP/$IP4/g /etc/neutron/neutron.conf
sed -i s/MYPASSWORD/$PASSWORD/g /etc/neutron/neutron.conf
sed -i s/MYPASSWORD/$PASSWORD/g /etc/neutron/metadata_agent.ini

openstack network create  --share --external --provider-physical-network provider --provider-network-type flat provider
openstack subnet create --network provider --allocation-pool start=MYIP_START,end=MYIP_END --dns-nameserver DNS_RESOLVER --gateway PROVIDER_NETWORK_GATEWAY --subnet-range PROVIDER_NETWORK_CIDR provider

ln -s /etc/neutron/plugins/ml2/ml2_conf.ini /etc/neutron/plugin.ini
su -s /bin/sh -c "neutron-db-manage --config-file /etc/neutron/neutron.conf --config-file /etc/neutron/plugins/ml2/ml2_conf.ini upgrade head" neutron
systemctl restart openstack-nova-api.service

systemctl enable neutron-server.service neutron-linuxbridge-agent.service neutron-dhcp-agent.service neutron-metadata-agent.service
systemctl start neutron-server.service neutron-linuxbridge-agent.service neutron-dhcp-agent.service neutron-metadata-agent.service