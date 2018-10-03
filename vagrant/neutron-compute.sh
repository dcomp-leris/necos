sudo apt -qy install neutron-linuxbridge-agent >> apt-neutron-compute.log 2>> apt-neutron-compute-error.log

sudo sed -i 's/^connection = sqlite:\/\/\/\/var\/lib\/neutron\/neutron.sqlite/#connection = sqlite:\/\/\/\/var\/lib\/neutron\/neutron.sqlite/' /etc/neutron/neutron.conf

linhadefaultneutron=`sudo awk '{if ($0 == "[DEFAULT]") {print NR;}}' /etc/neutron/neutron.conf`
sudo sed -i "$[linhadefaultneutron+2] i\transport_url = rabbit://openstack:$2@controller" /etc/neutron/neutron.conf
sudo sed -i "$[linhadefaultneutron+3] i\auth_strategy = keystone" /etc/neutron/neutron.conf

linhaauthtokenneutron=`sudo awk '{if ($0 == "[keystone_authtoken]") {print NR;}}' /etc/neutron/neutron.conf`
sudo sed -i "$[linhaauthtokenneutron+1] i\www_authenticate_uri = http://controller:5000/v3" /etc/neutron/neutron.conf
sudo sed -i "$[linhaauthtokenneutron+2] i\auth_url = http://controller:5000/v3" /etc/neutron/neutron.conf
sudo sed -i "$[linhaauthtokenneutron+3] i\memcached_servers = controller:11211" /etc/neutron/neutron.conf
sudo sed -i "$[linhaauthtokenneutron+4] i\auth_type = password" /etc/neutron/neutron.conf
sudo sed -i "$[linhaauthtokenneutron+5] i\project_domain_name = default" /etc/neutron/neutron.conf
sudo sed -i "$[linhaauthtokenneutron+6] i\user_domain_name = default" /etc/neutron/neutron.conf
sudo sed -i "$[linhaauthtokenneutron+7] i\project_name = service" /etc/neutron/neutron.conf
sudo sed -i "$[linhaauthtokenneutron+8] i\username = neutron" /etc/neutron/neutron.conf
sudo sed -i "$[linhaauthtokenneutron+9] i\password = $2" /etc/neutron/neutron.conf

linhalinuxbridgeneutron=`sudo awk '{if ($0 == "[linux_bridge]") {print NR;}}' /etc/neutron/plugins/ml2/linuxbridge_agent.ini`
sudo sed -i "$[linhalinuxbridgeneutron+1] i\physical_interface_mappings = provider:enp0s9" /etc/neutron/plugins/ml2/linuxbridge_agent.ini


linhavxlanneutron=`sudo awk '{if ($0 == "[vxlan]") {print NR;}}' /etc/neutron/plugins/ml2/linuxbridge_agent.ini`
sudo sed -i "$[linhavxlanneutron+1] i\enable_vxlan = true" /etc/neutron/plugins/ml2/linuxbridge_agent.ini
sudo sed -i "$[linhavxlanneutron+2] i\local_ip = $1" /etc/neutron/plugins/ml2/linuxbridge_agent.ini
sudo sed -i "$[linhavxlanneutron+3] i\l2_population = true" /etc/neutron/plugins/ml2/linuxbridge_agent.ini

linhasecuritybridgeneutron=`sudo awk '{if ($0 == "[securitygroup]") {print NR;}}' /etc/neutron/plugins/ml2/linuxbridge_agent.ini`
sudo sed -i "$[linhasecuritybridgeneutron+1] i\enable_security_group = true" /etc/neutron/plugins/ml2/linuxbridge_agent.ini
sudo sed -i "$[linhasecuritybridgeneutron+2] i\firewall_driver = neutron.agent.linux.iptables_firewall.IptablesFirewallDriver" /etc/neutron/plugins/ml2/linuxbridge_agent.ini

linhaneutronnova=`sudo awk '{if ($0 == "[neutron]") {print NR;}}' /etc/nova/nova.conf`
sudo sed -i "$[linhaneutronnova+1] i\url = http://controller:9696" /etc/nova/nova.conf
sudo sed -i "$[linhaneutronnova+2] i\auth_url = http://controller:5000/v3" /etc/nova/nova.conf
sudo sed -i "$[linhaneutronnova+3] i\auth_type = password" /etc/nova/nova.conf
sudo sed -i "$[linhaneutronnova+4] i\project_domain_name = default" /etc/nova/nova.conf
sudo sed -i "$[linhaneutronnova+5] i\user_domain_name = default" /etc/nova/nova.conf
sudo sed -i "$[linhaneutronnova+6] i\region_name = RegionOne" /etc/nova/nova.conf
sudo sed -i "$[linhaneutronnova+7] i\project_name = service" /etc/nova/nova.conf
sudo sed -i "$[linhaneutronnova+8] i\username = neutron" /etc/nova/nova.conf
sudo sed -i "$[linhaneutronnova+9] i\password = $2" /etc/nova/nova.conf

sudo service nova-compute restart
if [ $? -ne 0 ]; then echo "NECOS: error"; fi
sudo service neutron-linuxbridge-agent restart
if [ $? -ne 0 ]; then echo "NECOS: error"; fi
