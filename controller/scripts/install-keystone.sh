#!/bin/sh

echo "===== Installing Keystone ====="
echo "  "

#source /root/.my.cnf

echo "== Creating Keystone Database =="
mysql --user=root --password=$PASSWORD <<QUERY
CREATE DATABASE keystone;
GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'localhost' IDENTIFIED BY '$PASSWORD';
GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'%' IDENTIFIED BY '$PASSWORD';
QUERY
echo "== Keystone Database Created =="


yum -y install openstack-keystone httpd python3-mod_wsgi
cp /tmp/vagrant/config/etc/keystone/keystone.conf /etc/keystone/keystone.conf
sed -i s/MYPASSWORD/$PASSWORD/g /etc/keystone/keystone.conf

su -s /bin/sh -c "keystone-manage db_sync" keystone
keystone-manage fernet_setup --keystone-user keystone --keystone-group keystone
keystone-manage credential_setup --keystone-user keystone --keystone-group keystone

keystone-manage bootstrap --bootstrap-password $PASSWORD --bootstrap-admin-url http://controller.local:5000/v3/ --bootstrap-internal-url http://controller.local:5000/v3/ --bootstrap-public-url http://controller.local:5000/v3/ --bootstrap-region-id ATL

echo "ServerName controller" >> /etc/httpd/conf/httpd.conf
ln -s /usr/share/keystone/wsgi-keystone.conf /etc/httpd/conf.d/


systemctl enable httpd.service
systemctl start httpd.service

cat > /root/.admin-openrc <<EOT
export OS_USERNAME=admin
export OS_PASSWORD=$PASSWORD
export OS_PROJECT_NAME=admin
export OS_USER_DOMAIN_NAME=Default
export OS_PROJECT_DOMAIN_NAME=Default
export OS_AUTH_URL=http://controller.local:5000/v3
export OS_IDENTITY_API_VERSION=3
EOT


source /root/.admin-openrc

openstack project create --domain default --description "Service Project" service
openstack project create --domain default --description "Demo Project" demo
openstack user create --domain default --password $PASSWORD demo
openstack role create demo
openstack role add --project demo --user demo demo

cat > /root/.demo-openrc <<EOT
export OS_PROJECT_DOMAIN_NAME=Default
export OS_USER_DOMAIN_NAME=Default
export OS_PROJECT-NAME=demo
export OS_PROJECT_NAME=demo
export OS_PROJECT_PASSWORD=$PASSWORD
export OS_AUTH_URL=http://controller.local:5000/v3
export OS_IDENTITY_API_VERSION=3
Export OS_IMAGE_API_VERSION=2
EOT

