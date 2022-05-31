echo "export MYPASSWORD=$PASSWORD" >> /etc/profile.d/vars.sh
echo "export PASSWORD=$PASSWORD" >> /etc/profile.d/vars.sh

echo "export IP4=$(/sbin/ip -o -4 addr list eth1 | awk '{print $4}' | cut -d/ -f1)" >> /etc/profile.d/vars.sh
echo "export HOSTNAME=$(hostname -f)" >> /etc/profile.d/vars.sh
