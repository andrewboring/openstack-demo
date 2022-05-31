# -*- mode: ruby -*-
# vi: set ft=ruby :



Vagrant.configure("2") do |config|

  config.vm.define "controller" do |controller|
    controller.vm.box = "centos/stream8"
    controller.vm.hostname = "controller.local" 
    controller.vm.network "public_network", bridge: "en0: Wi-Fi", ip: "192.168.2.51", hostname: true
    #controller.vm.network "private_network", dhcp: true
    controller.vm.synced_folder ".", "/vagrant", disabled: true
    controller.vm.synced_folder "controller", "/tmp/vagrant", type: "rsync"


    controller.vm.provider "virtualbox" do |vb|
      vb.gui = false
      vb.memory = "1024"

      #vb.customize ['storagectl', :id, '--name', 'SATA', '--add', 'sata', '--controller', 'IntelAHCI', '--portcount', 3]
      #vb.customize ['createmedium', 'disk', '--filename', './controller.vdi', '--size', 20480]
      #vb.customize ['storageattach', :id, '--storagectl', 'SATA', '--port', 0, '--device', 0, '--type', 'hdd', '--medium', './controller.vdi']
    end
    controller.vm.provision :shell, env: {"PASSWORD"=>ENV['MYPASSWORD']}, inline: "/bin/sh /tmp/vagrant/scripts/get-vars.sh", :run => 'once'
    controller.vm.provision :shell, inline: "/bin/sh /tmp/vagrant/scripts/yum-update.sh", :run=> 'once'
    controller.vm.provision :shell, inline: "/bin/sh /tmp/vagrant/scripts/install-avahi.sh", :run=> 'once'
    controller.vm.provision :shell, inline: "/bin/sh /tmp/vagrant/scripts/install-chrony.sh", :run=> 'once'
    controller.vm.provision :shell, inline: "/bin/sh /tmp/vagrant/scripts/install-openstack.sh", :run=> 'once'
    controller.vm.provision :shell, inline: "/bin/sh /tmp/vagrant/scripts/install-mariadb.sh", :run=> 'once'
    controller.vm.provision :shell, inline: "/bin/sh /tmp/vagrant/scripts/install-rabbitmq.sh", :run=> 'once'
    controller.vm.provision :shell, inline: "/bin/sh /tmp/vagrant/scripts/install-memcached.sh", :run=> 'once'
    controller.vm.provision :shell, inline: "/bin/sh /tmp/vagrant/scripts/install-etcd.sh", :run=> 'once'
    controller.vm.provision :shell, inline: "/bin/sh /tmp/vagrant/scripts/install-keystone.sh", :run=> 'once'
    controller.vm.provision :shell, inline: "/bin/sh /tmp/vagrant/scripts/install-glance.sh", :run=> 'once'
    controller.vm.provision :shell, inline: "/bin/sh /tmp/vagrant/scripts/install-placement.sh", :run=> 'once'
    controller.vm.provision :shell, inline: "/bin/sh /tmp/vagrant/scripts/install-nova.sh", :run=> 'once'
    #controller.vm.provision :shell, inline: "/bin/sh /tmp/vagrant/scripts/install-horizon.sh", :run=> 'once'


  end
  config.vm.define "compute" do |compute|
    compute.vm.box = "centos/stream8"
    compute.vm.hostname = "compute.local" 
    compute.vm.network "public_network", bridge: "en0: Wi-Fi", ip: "192.168.2.52", hostname: true
    #controller.vm.network "private_network", dhcp: true
    compute.vm.synced_folder ".", "/vagrant", disabled: true
    compute.vm.synced_folder "compute", "/tmp/vagrant", type: "rsync"
    compute.vm.provider "virtualbox" do |vb|
      vb.gui = false
      vb.memory = "1024"
    end
    #compute.vm.provision :shell, inline: "echo 'source /tmp/vagrant/config/etc/profile.d/get-vars.sh' > /etc/profile.d/get-vars.sh", :run => 'always'
    compute.vm.provision :shell, env: {"PASSWORD"=>ENV['MYPASSWORD']}, inline: "/bin/sh /tmp/vagrant/config/etc/profile.d/get-vars.sh", :run => 'once'
    compute.vm.provision :shell, inline: "/bin/sh /tmp/vagrant/scripts/yum-update.sh", :run=> 'once'
    compute.vm.provision :shell, inline: "/bin/sh /tmp/vagrant/scripts/install-avahi.sh", :run=> 'once'
    compute.vm.provision :shell, inline: "/bin/sh /tmp/vagrant/scripts/install-openstack.sh", :run=> 'once'
    compute.vm.provision :shell, inline: "/bin/sh /tmp/vagrant/scripts/install-nova.sh", :run=> 'once'
  end


end