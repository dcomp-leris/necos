source necos/vagrant/admin-openrc

echo "Installing Ceilometer agents"
sudo apt install -qy ceilometer-agent-notification ceilometer-agent-central

sudo chmod 777 /etc/ceilometer/ceilometer.conf

linhaDefault=`sudo awk '{if ($0 == "[DEFAULT]") {print NR;}}' /etc/ceilometer/ceilometer.conf`
sudo sed -i "$[linhaDefault+2] i\transport_url = rabbit://openstack:secret@controller" /etc/ceilometer/ceilometer.conf

linhaCredentials=`sudo awk '{if ($0 == "[service_credentials]") {print NR;}}' /etc/ceilometer/ceilometer.conf`
sudo sed -i "$[linhaCredentials+1] i\auth_type = password" /etc/ceilometer/ceilometer.conf
sudo sed -i "$[linhaCredentials+2] i\auth_url = http://controller:5000/v3" /etc/ceilometer/ceilometer.conf
sudo sed -i "$[linhaCredentials+3] i\project_domain_id = default" /etc/ceilometer/ceilometer.conf
sudo sed -i "$[linhaCredentials+4] i\user_domain_id = default" /etc/ceilometer/ceilometer.conf
sudo sed -i "$[linhaCredentials+5] i\project_name = service" /etc/ceilometer/ceilometer.conf
sudo sed -i "$[linhaCredentials+6] i\username = ceilometer" /etc/ceilometer/ceilometer.conf
sudo sed -i "$[linhaCredentials+7] i\password = secret" /etc/ceilometer/ceilometer.conf
sudo sed -i "$[linhaCredentials+8] i\interface = internalURL" /etc/ceilometer/ceilometer.conf
sudo sed -i "$[linhaCredentials+9] i\region_name = RegionOne" /etc/ceilometer/ceilometer.conf

sudo sed -i "s*#pipeline_cfg_file = pipeline.yaml*pipeline_cfg_file = pipeline.yaml*" /etc/ceilometer/ceilometer.conf

linhaDispatcherGnocchi=`sudo awk '{if ($0 == "[dispatcher_gnocchi]") {print NR;}}' /etc/ceilometer/ceilometer.conf`
sudo sed -i "$[linhaDispatcherGnocchi+1] i\filter_service_activity = False" /etc/ceilometer/ceilometer.conf
sudo sed -i "$[linhaDispatcherGnocchi+2] i\archive_policy = high" /etc/ceilometer/ceilometer.conf

sudo cp /usr/lib/python2.7/dist-packages/ceilometer/pipeline/data/*.yaml /etc/ceilometer/

sudo gnocchi-upgrade --config-file /etc/gnocchi/gnocchi.conf >> gnocchiUpgrade.log 2>> gnocchiUpgrade-error.log
sudo ceilometer-upgrade --config-file /etc/ceilometer/ceilometer.conf >> ceilometerUpgrade.log 2>> ceilometerUpgrade-error.log
sudo service ceilometer-agent-central restart
sudo service ceilometer-agent-notification restart
