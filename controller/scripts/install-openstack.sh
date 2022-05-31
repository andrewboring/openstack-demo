echo " "
echo "===== Installing OpenStack Packages ====="
echo " " 
yum config-manager --set-enabled powertools
yum -y install centos-release-openstack-yoga
yum upgrade -y
yum -y install python3-openstackclient
yum -y install openstack-selinux 
     