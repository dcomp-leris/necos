sudo apt -qy install openstack-dashboard >> apt-horizon.log 2>> apt-horizon-error.log

sudo sed -i 's/127.0.0.1/controller/' /etc/openstack-dashboard/local_settings.py

sudo sed -i "s/^#ALLOWED_HOSTS = \['horizon.example.com', \]/ALLOWED_HOSTS = \['one.example.com', 'two.example.com'\]/" /etc/openstack-dashboard/local_settings.py

linhacacheshorizon=`sudo awk '{if ($0 == "CACHES = {") {print NR;}}' /etc/openstack-dashboard/local_settings.py`
sudo sed -i "$[linhacacheshorizon-1] i\SESSION_ENGINE = 'django.contrib.sessions.backends.cache'" /etc/openstack-dashboard/local_settings.py

sudo sed -i 's/#OPENSTACK_KEYSTONE_MULTIDOMAIN_SUPPORT = False/OPENSTACK_KEYSTONE_MULTIDOMAIN_SUPPORT = True/' /etc/openstack-dashboard/local_settings.py

linhaapiversions=`sudo awk '{if ($0 == "#OPENSTACK_API_VERSIONS = {") {print NR;}}' /etc/openstack-dashboard/local_settings.py`
sudo sed -i "$[linhaapiversions+7] i\OPENSTACK_API_VERSIONS = {\"identity\": 3, \"image\": 2, \"volume\": 2}" /etc/openstack-dashboard/local_settings.py

sudo sed -i "s/#OPENSTACK_KEYSTONE_DEFAULT_DOMAIN = 'Default'/OPENSTACK_KEYSTONE_DEFAULT_DOMAIN = 'Default'/" /etc/openstack-dashboard/local_settings.py

sudo sed -i 's/_member_/user/' /etc/openstack-dashboard/local_settings.py

sudo sed -i "s/'enable_router': True,/'enable_router': False,/" /etc/openstack-dashboard/local_settings.py
sudo sed -i "s/'enable_quotas': True,/'enable_quotas': False,/" /etc/openstack-dashboard/local_settings.py
sudo sed -i "s/'enable_ipv6': True,/'enable_ipv6': False,/" /etc/openstack-dashboard/local_settings.py
sudo sed -i "s/'enable_fip_topology_check': True,/'enable_fip_topology_check': False,/" /etc/openstack-dashboard/local_settings.py

linhaneutronnetwork=`sudo awk '{if ($0 == "OPENSTACK_NEUTRON_NETWORK = {") {print NR;}}' /etc/openstack-dashboard/local_settings.py`
sudo sed -i "$[linhaneutronnetwork+7] i\    'enable_lb': False," /etc/openstack-dashboard/local_settings.py
sudo sed -i "$[linhaneutronnetwork+8] i\    'enable_firewall': False," /etc/openstack-dashboard/local_settings.py
sudo sed -i "$[linhaneutronnetwork+9] i\    'enable_vpn': False," /etc/openstack-dashboard/local_settings.py

sudo service apache2 reload
if [ $? -ne 0 ]; then echo "NECOS: error"; fi
