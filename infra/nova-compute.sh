sudo apt -qy install nova-common >> apt-nova-common.log 2>> apt-nova-common-error.log
sudo apt -qy install nova-compute >> apt-nova-compute.log 2>> apt-nova-compute-error.log

HOST_IP=`hostname -I | cut -d " " -f 2`
linhadefaultnova=`sudo awk '{if ($0 == "[DEFAULT]") {print NR;}}' /etc/nova/nova.conf`
sudo sed -i "$[linhadefaultnova+4] i\transport_url = rabbit://openstack:secret@controller" /etc/nova/nova.conf
sudo sed -i "$[linhadefaultnova+5] i\my_ip = ${HOST_IP}" /etc/nova/nova.conf
sudo sed -i "$[linhadefaultnova+6] i\use_neutron = True" /etc/nova/nova.conf
sudo sed -i "$[linhadefaultnova+7] i\firewall_driver = nova.virt.firewall.NoopFirewallDriver" /etc/nova/nova.conf

linhavncnova=`sudo awk '{if ($0 == "[vnc]") {print NR;}}' /etc/nova/nova.conf`
sudo sed -i "$[linhavncnova+1] i\enabled = True" /etc/nova/nova.conf
sudo sed -i "$[linhavncnova+2] i\server_listen = 0.0.0.0" /etc/nova/nova.conf
sudo sed -i "$[linhavncnova+3] i\server_proxyclient_address = 10.0.0.31" /etc/nova/nova.conf
sudo sed -i "$[linhavncnova+4] i\snovncproxy_base_url = http://192.168.1.103:6080/vnc_auto.html" /etc/nova/nova.conf

sudo sed -i 's/#auth_strategy = keystone/auth_strategy = keystone/' /etc/nova/nova.conf

linhaauthtokennova=`sudo awk '{if ($0 == "[keystone_authtoken]") {print NR;}}' /etc/nova/nova.conf`
sudo sed -i "$[linhaauthtokennova+1] i\auth_url = http://controller:5000/v3" /etc/nova/nova.conf
sudo sed -i "$[linhaauthtokennova+2] i\memcached_servers = controller:11211" /etc/nova/nova.conf
sudo sed -i "$[linhaauthtokennova+3] i\auth_type = password" /etc/nova/nova.conf
sudo sed -i "$[linhaauthtokennova+4] i\project_domain_name = default" /etc/nova/nova.conf
sudo sed -i "$[linhaauthtokennova+5] i\user_domain_name = default" /etc/nova/nova.conf
sudo sed -i "$[linhaauthtokennova+6] i\project_name = service" /etc/nova/nova.conf
sudo sed -i "$[linhaauthtokennova+7] i\username = nova" /etc/nova/nova.conf
sudo sed -i "$[linhaauthtokennova+8] i\password = secret" /etc/nova/nova.conf

linhaglancenova=`sudo awk '{if ($0 == "[glance]") {print NR;}}' /etc/nova/nova.conf`
sudo sed -i "$[linhaglancenova+1] i\api_servers = http://controller:9292" /etc/nova/nova.conf

linhaoslonova=`sudo awk '{if ($0 == "[oslo_concurrency]") {print NR;}}' /etc/nova/nova.conf`
sudo sed -i "$[linhaoslonova+1] i\lock_path = /var/lib/nova/tmp" /etc/nova/nova.conf

sudo sed -i 's/^log_dir = \/var\/log\/nova/#log_dir = \/var\/log\/nova/' /etc/nova/nova.conf

linhaplacementnova=`sudo awk '{if ($0 == "[placement]") {print NR;}}' /etc/nova/nova.conf`
sudo sed -i "$[linhaplacementnova+1] i\os_region_name = RegionOne" /etc/nova/nova.conf
sudo sed -i "$[linhaplacementnova+2] i\project_domain_name = Default" /etc/nova/nova.conf
sudo sed -i "$[linhaplacementnova+3] i\project_name = service" /etc/nova/nova.conf
sudo sed -i "$[linhaplacementnova+4] i\auth_type = password" /etc/nova/nova.conf
sudo sed -i "$[linhaplacementnova+5] i\user_domain_name = Default" /etc/nova/nova.conf
sudo sed -i "$[linhaplacementnova+6] i\auth_url = http://controller:5000/v3" /etc/nova/nova.conf
sudo sed -i "$[linhaplacementnova+7] i\username = placement" /etc/nova/nova.conf
sudo sed -i "$[linhaplacementnova+8] i\password = secret" /etc/nova/nova.conf

sudo sed -i 's/kvm/qemu/' /etc/nova/nova-compute.conf

sudo service nova-compute restart
if [ $? -ne 0 ]; then echo "NECOS: error"; fi
