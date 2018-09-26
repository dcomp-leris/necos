sudo mysql -uroot -p$2 <<_EOF_
CREATE DATABASE nova_api;
CREATE DATABASE nova;
CREATE DATABASE nova_cell0;
CREATE DATABASE placement;
GRANT ALL PRIVILEGES ON nova_api.* TO 'nova'@'localhost' IDENTIFIED BY '$2';
GRANT ALL PRIVILEGES ON nova_api.* TO 'nova'@'%' IDENTIFIED BY '$2';
GRANT ALL PRIVILEGES ON nova.* TO 'nova'@'localhost' IDENTIFIED BY '$2';
GRANT ALL PRIVILEGES ON nova.* TO 'nova'@'%' IDENTIFIED BY '$2';
GRANT ALL PRIVILEGES ON nova_cell0.* TO 'nova'@'localhost' IDENTIFIED BY '$2';
GRANT ALL PRIVILEGES ON nova_cell0.* TO 'nova'@'%' IDENTIFIED BY '$2';
GRANT ALL PRIVILEGES ON placement.* TO 'placement'@'localhost' IDENTIFIED BY '$2';
GRANT ALL PRIVILEGES ON placement.* TO 'placement'@'%' IDENTIFIED BY '$2';
_EOF_

source necos/vagrant/admin-openrc

openstack user create --domain default --password $2 nova >> nova.log 2>> nova-error.log
openstack role add --project service --user nova admin >> nova.log 2>> nova-error.log
openstack service create --name nova --description "OpenStack Compute" compute >> nova.log 2>> nova-error.log
openstack endpoint create --region RegionOne compute public http://controller:8774/v2.1 >> nova.log 2>> nova-error.log
openstack endpoint create --region RegionOne compute internal http://controller:8774/v2.1 >> nova.log 2>> nova-error.log
openstack endpoint create --region RegionOne compute admin http://controller:8774/v2.1 >> nova.log 2>> nova-error.log
openstack user create --domain default --password $2 placement >> nova.log 2>> nova-error.log
openstack role add --project service --user placement admin >> nova.log 2>> nova-error.log
openstack service create --name placement --description "Placement API" placement >> nova.log 2>> nova-error.log
openstack endpoint create --region RegionOne placement public http://controller:8778 >> nova.log 2>> nova-error.log
openstack endpoint create --region RegionOne placement internal http://controller:8778 >> nova.log 2>> nova-error.log
openstack endpoint create --region RegionOne placement admin http://controller:8778 >> nova.log 2>> nova-error.log


sudo apt -qy install nova-api nova-conductor nova-consoleauth nova-novncproxy nova-scheduler nova-placement-api >> apt-nova.log 2>> apt-nova-error.log

sudo sed -i 's/sqlite:\/\/\/\/var\/lib\/nova\/nova_api.sqlite/mysql+pymysql:\/\/nova:$2@controller\/nova_api/' /etc/nova/nova.conf
sudo sed -i 's/sqlite:\/\/\/\/var\/lib\/nova\/nova.sqlite/mysql+pymysql:\/\/nova:$2@controller\/nova/' /etc/nova/nova.conf

echo "[placement_database]" >> /etc/nova/nova.conf
echo "connection = mysql+pymysql://placement:$2@controller/placement" >> /etc/nova/nova.conf

linhadefaultnova=`sudo awk '{if ($0 == "[DEFAULT]") {print NR;}}' /etc/nova/nova.conf`
sudo sed -i "$[linhadefaultnova+4] i\transport_url = rabbit://openstack:$2@controller" /etc/nova/nova.conf
sudo sed -i "$[linhadefaultnova+5] i\my_ip = $1" /etc/nova/nova.conf
sudo sed -i "$[linhadefaultnova+6] i\use_neutron = True" /etc/nova/nova.conf
sudo sed -i "$[linhadefaultnova+7] i\firewall_driver = nova.virt.firewall.NoopFirewallDriver" /etc/nova/nova.conf

sudo sed -i 's/#auth_strategy = keystone/auth_strategy = keystone/' /etc/nova/nova.conf

linhaauthtokennova=`sudo awk '{if ($0 == "[keystone_authtoken]") {print NR;}}' /etc/nova/nova.conf`
sudo sed -i "$[linhaauthtokennova+1] i\auth_url = http://controller:5000/v3" /etc/nova/nova.conf
sudo sed -i "$[linhaauthtokennova+2] i\memcached_servers = controller:11211" /etc/nova/nova.conf
sudo sed -i "$[linhaauthtokennova+3] i\auth_type = password" /etc/nova/nova.conf
sudo sed -i "$[linhaauthtokennova+4] i\project_domain_name = default" /etc/nova/nova.conf
sudo sed -i "$[linhaauthtokennova+5] i\user_domain_name = default" /etc/nova/nova.conf
sudo sed -i "$[linhaauthtokennova+6] i\project_name = service" /etc/nova/nova.conf
sudo sed -i "$[linhaauthtokennova+7] i\username = nova" /etc/nova/nova.conf
sudo sed -i "$[linhaauthtokennova+8] i\password = $2" /etc/nova/nova.conf

linhavncnova=`sudo awk '{if ($0 == "[vnc]") {print NR;}}' /etc/nova/nova.conf`
sudo sed -i "$[linhavncnova+1] i\enabled = true" /etc/nova/nova.conf
sudo sed -i "$[linhavncnova+2] i\server_listen = $1" /etc/nova/nova.conf
sudo sed -i "$[linhavncnova+3] i\server_proxyclient_address = $1" /etc/nova/nova.conf

linhaglancenova=`sudo awk '{if ($0 == "[glance]") {print NR;}}' /etc/nova/nova.conf`
sudo sed -i "$[linhaglancenova+1] i\api_servers = http://controller:9292" /etc/nova/nova.conf

linhaoslonova=`sudo awk '{if ($0 == "[oslo_concurrency]") {print NR;}}' /etc/nova/nova.conf`
sudo sed -i "$[linhaoslonova+1] i\lock_path = /var/lib/nova/tmp" /etc/nova/nova.conf

sudo sed -i 's/^log_dir = \/var\/log\/nova/#log_dir = \/var\/log\/nova/' /etc/nova/nova.conf

sudo sed -i 's/^os_region_name = openstack/#os_region_name = openstack/' /etc/nova/nova.conf

linhaplacementnova=`sudo awk '{if ($0 == "[placement]") {print NR;}}' /etc/nova/nova.conf`
sudo sed -i "$[linhaplacementnova+1] i\region_name = RegionOne" /etc/nova/nova.conf
sudo sed -i "$[linhaplacementnova+2] i\project_domain_name = Default" /etc/nova/nova.conf
sudo sed -i "$[linhaplacementnova+3] i\project_name = service" /etc/nova/nova.conf
sudo sed -i "$[linhaplacementnova+4] i\auth_type = password" /etc/nova/nova.conf
sudo sed -i "$[linhaplacementnova+5] i\user_domain_name = Default" /etc/nova/nova.conf
sudo sed -i "$[linhaplacementnova+6] i\auth_url = http://controller:5000/v3" /etc/nova/nova.conf
sudo sed -i "$[linhaplacementnova+7] i\username = placement" /etc/nova/nova.conf
sudo sed -i "$[linhaplacementnova+8] i\password = $2" /etc/nova/nova.conf

sudo sed -i 's/^#discover_hosts_in_cells_interval = -1/discover_hosts_in_cells_interval = 300/' /etc/nova/nova.conf

sudo sed -i 's/^enable = False/#enable = False/' /etc/nova/nova.conf

sudo su -s /bin/sh -c "nova-manage api_db sync" nova >> nova-manage.log 2>> nova-manage-error.log

sudo su -s /bin/sh -c "nova-manage cell_v2 map_cell0" nova >> nova-manage.log 2>> nova-manage-error.log

sudo su -s /bin/sh -c "nova-manage cell_v2 create_cell --name=cell1 --verbose" nova >> nova-manage.log 2>> nova-manage-error.log

sudo su -s /bin/sh -c "nova-manage db sync" nova >> nova-manage.log 2>> nova-manage-error.log

sudo service nova-api restart
sudo service nova-scheduler restart
sudo service nova-conductor restart
sudo service nova-novncproxy restart
