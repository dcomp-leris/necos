#source necos/vagrant/admin-openrc

sudo apt install -qy ceilometer-agent-notification ceilometer-agent-central

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

sudo touch /etc/ceilometer/pipeline.yaml
sudo chmod 777 /etc/ceilometer/pipeline.yaml

sudo echo -ne "publishers:\n\t- gnocchi://?filter_project=service&archive_policy=low\n" >> /etc/ceilometer/pipeline.yaml

#Não foi possível realizar o ceilometer-upgrade
sudo ceilometer-upgrade

sudo service ceilometer-agent-central restart
sudo service ceilometer-agent-notification restart
