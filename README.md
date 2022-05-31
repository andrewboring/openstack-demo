# Vagrant Openstack Demo

This Vagrant OpenStack Demo is a simple Vagrant environment containing an automated deployment of Openstack RDO Yoga release.

Includes: 
 - Controller node, with
   - RabbitMQ
   - Keystone
   - Glance
   - Placement
- Compute node, running Nova
- Simple bridged networking using Provider networks

Use Cases:
 - "Kick the tires" with a working OpenStack installation
 - Test an integration with another piece of software
 - Play with Openstack on your laptop

Requirements:
 - Vagrant
 - Virtualbox
 - Internet connection (to download Vagrant box)


## Usage

### Quickstart:

Step 1. Clone this repo  
Step 2. Set MYPASSWORD environment variable  
Step 3. ```vagrant up```  
Step 4. Do the needful  
Step 5. ```vagrant destroy -f```  

### Details

This Vagrant file reads the environment variable MYPASSWORD and passes that to the shell provisioners, which in turn configures that password for all user accounts, Openstack service accounts, config files, etc. To set the MYPASSWORD environment variable:

```$ export MYPASSWORD=CorrectHorseBatteryStaple```

Once MYPASSWORD is set, you can start up the environment:

```$ vagrant up```

If you want to start each node one-by-one:

````
$ vagrant up controller
$ vagrant up compute
````

By default, this Vagrant env uses two networks: 1 host-only network with NAT for Internet access, and 1 Bridged network (called "Public Network" in Vagrant) for Openstack to use. Currently, you need to specify static IP addresses in the Vagrant file, since Vagrant won't update /etc/hosts properly with DHCP. *To do: set this up in Vagrant file*

You will need to select a network adapter for bridging, if you don't specify one. To specify an adapter, just uncomment one of the existing options or specify your own. *To do: set this up in Vagrant file*

Once completed, if there are no errors or problems, you can use the environment. 

You should be able to access the Horizon dashboard on the controller node. Simply point your browser to http://controller.local, or you can use ```vagrant ssh [node name]``` to login to each node. The sudo utility is available for privileged operations.




## Security

- There is none. Don't use this for anything other than an ephemeral demonstration. 
- There is one password (set via environment variable), used for all privileged and unprivileged accounts, services, databases, everything. 
- The environment is bridged, meaining Openstack services are exposed to your local network. 
- There is no TLS securing HTTP. So that password is flying around the network, unencrypted. 

Protip: don't use this for anything than an ephemeral demonstration, unless you know what you're doing. For a proper proof-of-concept or formal testing, hire a pro and do this right.


## Notes:

This Vagrantfile deviates from the official RDO Install Guide in the following ways:

1. Avahi and nss-mdns packages are installed on all nodes to facilitate DNS resolution via mDNS.
2. The openstack-nova-compute service on the compute node won't resolve the rabbitmq broker via mDNS when starting openstack-nova-compute service. This script adds the controller entry to the /etc/hosts file on the compute node to fix. 
3. Placement service doesn't have proper permissions to Keystone. This is an RDO packaging bug. This environment includes a modified /etc/httpd/conf.d/00-placement-conf file to fix this. 

