

sudo touch /home/vagrant/logs/ceilometer.log
sudo touch /home/vagrant/logs/ceilometer-error.log
sudo chmod 755 /home/vagrant/logs/ceilometer.log 
sudo chmod 755 /home/vagrant/logs/ceillometer-error.log 
openstack user create --domain default --password secret ceilometer >> /home/vagrant/logs/ceilometer.log 2>> /home/vagrant/logs/ceilometer-error.log
openstack role add --project service --user ceilometer admin >> /home/vagrant/logs/ceilometer.log 2>> /home/vagrant/logs/ceilometer-error.log
openstack user create --domain default --password secret gnocchi >> /home/vagrant/logs/ceilometer.log 2>> /home/vagrant/logs/ceilometer-error.log
openstack service create --name gnocchi --description "Metric Service" metric >> /home/vagrant/logs/ceilometer.log 2>> /home/vagrant/logs/ceilometer-error.log
openstack role add --project service --user gnocchi admin >> /home/vagrant/logs/ceilometer.log 2>> /home/vagrant/logs/ceilometer-error.log
openstack endpoint create --region RegionOne metric public http://controller:8041 >> /home/vagrant/logs/ceilometer.log 2>> /home/vagrant/logs/ceilometer-error.log
openstack endpoint create --region RegionOne metric internal http://controller:8041 >> /home/vagrant/logs/ceilometer.log 2>> /home/vagrant/logs/ceilometer-error.log
openstack endpoint create --region RegionOne metric admin http://controller:8041 >> /home/vagrant/logs/ceilometer.log 2>> /home/vagrant/logs/ceilometer-error.log

sudo apt -qy install redis

sudo chmod 755 /etc/redis/redis.conf
sudo sed -i 's/bind 127.0.0.1 ::1/bind 10.0.0.11 ::1/' /etc/redis/redis.conf
sudo service redis restart


sudo apt -qy install python-pip
sudo pip install uwsgi
sudo apt -qy install libsnappy-dev
sudo pip install gnocchi[mysql,redis,keystone,prometheus]
sudo pip install gnocchiclient


sudo mysql -uroot -psecret <<_EOF_
CREATE DATABASE gnocchi;
GRANT ALL PRIVILEGES ON gnocchi.* TO 'gnocchi'@'localhost' IDENTIFIED BY 'secret';
GRANT ALL PRIVILEGES ON gnocchi.* TO 'gnocchi'@'%' IDENTIFIED BY 'secret';
_EOF_

sudo mkdir /etc/gnocchi
sudo touch /etc/gnocchi/gnocchi.conf
sudo chmod 777 /etc/gnocchi/gnocchi.conf
sudo gnocchi-config-generator > /etc/gnocchi/gnocchi.conf

linhaapignocchi=`sudo awk '{if ($0 == "[api]") {print NR;}}' /etc/gnocchi/gnocchi.conf`
sudo sed -i "$[linhaapignocchi+1] i\auth_mode = keystone" /etc/gnocchi/gnocchi.conf

linhaauthtokengnocchi=`sudo awk '{if ($0 == "[keystone_authtoken]") {print NR;}}' /etc/gnocchi/gnocchi.conf`
sudo sed -i "$[linhaauthtokengnocchi+2] i\auth_type = password" /etc/gnocchi/gnocchi.conf
sudo sed -i "$[linhaauthtokengnocchi+3] i\auth_url = http://controller:5000/v3" /etc/gnocchi/gnocchi.conf
sudo sed -i "$[linhaauthtokengnocchi+4] i\project_domain_name = Default" /etc/gnocchi/gnocchi.conf
sudo sed -i "$[linhaauthtokengnocchi+5] i\user_domain_name = Default" /etc/gnocchi/gnocchi.conf
sudo sed -i "$[linhaauthtokengnocchi+6] i\project_name = service" /etc/gnocchi/gnocchi.conf
sudo sed -i "$[linhaauthtokengnocchi+7] i\username = gnocchi" /etc/gnocchi/gnocchi.conf
sudo sed -i "$[linhaauthtokengnocchi+8] i\password = secret" /etc/gnocchi/gnocchi.conf
sudo sed -i "$[linhaauthtokengnocchi+9] i\interface = internalURL" /etc/gnocchi/gnocchi.conf
sudo sed -i "$[linhaauthtokengnocchi+10] i\region_name = RegionOne" /etc/gnocchi/gnocchi.conf

sudo sed -i 's*#url = <None>*url = mysql+pymysql://gnocchi:secret@controller/gnocchi*' /etc/gnocchi/gnocchi.conf

linhastoragegnocchi=`sudo awk '{if ($0 == "[storage]") {print NR;}}' /etc/gnocchi/gnocchi.conf`
sudo sed -i "$[linhastoragegnocchi+1] i\file_basepath = /var/lib/gnocchi" /etc/gnocchi/gnocchi.conf
sudo sed -i "$[linhastoragegnocchi+2] i\driver = file" /etc/gnocchi/gnocchi.conf

linhadefault=`sudo awk '{if ($0 == "[DEFAULT]") {print NR;}}' /etc/gnocchi/gnocchi.conf`
sudo sed -i "$[linhadefault+1] i\coordination_url = redis://controller:6379" /etc/gnocchi/gnocchi.conf


sudo gnocchi-upgrade --config-file /etc/gnocchi/gnocchi.conf >> gnocchiUpgrade.log 2>> gnocchiUpgrade-error.log

sudo touch /etc/init.d/gnocchi-api
sudo chmod 755 /etc/init.d/gnocchi-api

sudo tee -a /etc/init.d/gnocchi-api 1>/dev/null <<_EOF_   
#!/bin/bash
#
# /etc/init.d/gnocchi-api

echo "Iniciando serviço gnocchi-api"
gnocchi-api --config-file /etc/gnocchi/gnocchi.conf >> gnocchiApi.log 2>> gnocchiApi-error.log
_EOF_

sudo ln -s /etc/init.d/gnocchi-api /etc/rc3.d/S99gnocchi-api

#O metricd ainda não está funcionando
sudo touch /etc/init.d/gnocchi-metricd
sudo chmod 755 /etc/init.d/gnocchi-metricd

sudo tee -a /etc/init.d/gnocchi-metricd 1>/dev/null <<_EOF_   
#!/bin/bash
#
# /etc/init.d/gnocchi-metricd

echo "Iniciando serviço gnocchi-metricd"
gnocchi-metricd --config-file /etc/gnocchi/gnocchi.conf >> gnocchiMetricd.log 2>> gnocchiMetricd-error.log
_EOF_

sudo ln -s /etc/init.d/gnocchi-api /etc/rc3.d/S99gnocchi-metricd

