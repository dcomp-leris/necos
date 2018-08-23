sudo apt -qy install openstack-dashboard >> apt-horizon.log 2>> apt-horizon-error.log

sudo sed -i 's/127.0.0.1/controller' /etc/openstack-dashboard/local_settings.py

sudo sed -i "s/^ALLOWED_HOSTS = '*'/ALLOWED_HOSTS = ['one.example.com', 'two.example.com']/" /etc/openstack-dashboard/local_settings.py

