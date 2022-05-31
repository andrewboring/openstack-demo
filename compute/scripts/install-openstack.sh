echo " "
echo "===== Installing OpenStack Packages ====="
echo " " 
yum config-manager --set-enabled powertools
yum -y install centos-release-openstack-yoga
yum upgrade -y
yum -y install python3-openstackclient
yum -y install openstack-selinux

cat > /root/.admin-openrc <<EOT
export OS_USERNAME=admin
export OS_PASSWORD=$PASSWORD
export OS_PROJECT_NAME=admin
export OS_USER_DOMAIN_NAME=Default
export OS_PROJECT_DOMAIN_NAME=Default
export OS_AUTH_URL=http://controller.local:5000/v3
export OS_IDENTITY_API_VERSION=3
EOT