#!/bin/sh

echo "===== Installing MariaDB ====="
echo "  "
yum -y install mariadb mariadb-server python2-PyMySQL 
cp /tmp/vagrant/config/etc/my.cnf.d/openstack.cnf /etc/my.cnf.d/openstack.cnf
systemctl enable mariadb.service
systemctl start mariadb.service
mysqladmin -u root password "$PASSWORD"
cp /tmp/vagrant/config/root/dot-my.cnf /root/.my.cnf
sed -i s/MYPASSWORD/$PASSWORD/g /root/.my.cnf

mysql -u root -p"$PASSWORD" -e "UPDATE mysql.user SET Password=PASSWORD('$PASSWORD') WHERE User='root'"
