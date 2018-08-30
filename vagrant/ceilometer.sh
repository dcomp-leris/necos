#source necos/vagrant/admin-openrc

openstack user create --domain default --password secret ceilometer >> ceilometer.log 2>> ceilometer-error.log
openstack role add --project service --user ceilometer admin >> ceilometer.log 2>> ceilometer-error.log
openstack user create --domain default --password secret gnocchi >> ceilometer.log 2>> ceilometer-error.log
openstack service create --name gnocchi --description "Metric Service" metric >> ceilometer.log 2>> ceilometer-error.log
openstack role add --project service --user gnocchi admin >> ceilometer.log 2>> ceilometer-error.log
openstack endpoint create --region RegionOne metric public http://controller:8041 >> ceilometer.log 2>> ceilometer-error.log
openstack endpoint create --region RegionOne metric internal http://controller:8041 >> ceilometer.log 2>> ceilometer-error.log
openstack endpoint create --region RegionOne metric admin http://controller:8041 >> ceilometer.log 2>> ceilometer-error.log

sudo apt -qy install gnocchi-api gnocchi-metricd python-gnocchiclient

sudo mysql -uroot -psecret <<_EOF_
CREATE DATABASE gnocchi;
GRANT ALL PRIVILEGES ON gnocchi.* TO 'gnocchi'@'localhost' IDENTIFIED BY 'secret';
GRANT ALL PRIVILEGES ON gnocchi.* TO 'gnocchi'@'%' IDENTIFIED BY 'secret';
_EOF_

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

sudo sed -i 's/sqlite:\/\/\/\/var\/lib\/gnocchi\/gnocchidb/mysql+pymysql:\/\/gnocchi:secret@controller\/gnocchi/' /etc/gnocchi/gnocchi.conf

linhastoragegnocchi=`sudo awk '{if ($0 == "[storage]") {print NR;}}' /etc/gnocchi/gnocchi.conf`
sudo sed -i "$[linhastoragegnocchi+1] i\coordination_url = redis://controller:6379" /etc/gnocchi/gnocchi.conf
sudo sed -i "$[linhastoragegnocchi+2] i\file_basepath = /var/lib/gnocchi" /etc/gnocchi/gnocchi.conf
sudo sed -i "$[linhastoragegnocchi+3] i\driver = file" /etc/gnocchi/gnocchi.conf

sudo gnocchi-upgrade >> gnocchi.log 2>> gnocchi-error.log
sudo service gnocchi-api restart
if [ $? -ne 0 ]; then echo "NECOS: error"; fi
sudo service gnocchi-metricd restart
if [ $? -ne 0 ]; then echo "NECOS: error"; fi
