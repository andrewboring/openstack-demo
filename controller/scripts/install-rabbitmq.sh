#!/bin/sh


echo "===== Configuring RabbitMQ ====="
echo " "
yum -y install rabbitmq-server      
systemctl enable rabbitmq-server.service
systemctl start rabbitmq-server.service
rabbitmqctl add_user openstack "$PASSWORD"
rabbitmqctl set_permissions openstack ".*" ".*" ".*"
