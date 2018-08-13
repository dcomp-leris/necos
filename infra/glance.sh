sudo mysql -uroot -psecret <<_EOF_
CREATE DATABASE glance;
GRANT ALL PRIVILEGES ON glance.* TO 'glance'@'localhost' IDENTIFIED BY 'secret';
GRANT ALL PRIVILEGES ON glance.* TO 'glance'@'%' IDENTIFIED BY 'secret';
_EOF_

#echo "passou aqui"
#openstack user create --domain default --password secret glance >> glance.log 2>> glance-error.log
#openstack role add --project service --user glance admin >> glance.log 2>> glance-error.log
#openstack service create --name glance --description "OpenStack Image" image >> glance.log 2>> glance-error.log
#openstack endpoint create --region RegionOne image public http://controller:9292 >> glance.log 2>> glance-error.log
#openstack endpoint create --region RegionOne image internal http://controller:9292 >> glance.log 2>> glance-error.log
#openstack endpoint create --region RegionOne image admin http://controller:9292 >> glance.log 2>> glance-error.log
#echo "saiu aqui"
echo "passou aqui"
openstack user create --domain default --password secret glance
openstack role add --project service --user glance admin
openstack service create --name glance --description "OpenStack Image" image
openstack endpoint create --region RegionOne image public http://controller:9292
openstack endpoint create --region RegionOne image internal http://controller:9292
openstack endpoint create --region RegionOne image admin http://controller:9292
echo "saiu aqui"

sudo apt -qy install glance >> apt-glance.log 2>> apt-glance-error.log

sudo sed -i 's/sqlite:\/\/\/\/var\/lib\/glance\/glance.sqlite/mysql+pymysql:\/\/glance:secret@controller\/glance/' /etc/glance/glance-api.conf

linhaauthtoken=`sudo awk '{if ($0 == "[keystone_authtoken]") {print NR;}}' /etc/glance/glance-api.conf`
sudo sed -i "$[linhaauthtoken+1] i\auth_uri = http://controller:5000" /etc/glance/glance-api.conf
sudo sed -i "$[linhaauthtoken+2] i\auth_url = http://controller:5000" /etc/glance/glance-api.conf
sudo sed -i "$[linhaauthtoken+3] i\memcached_servers = controller:11211" /etc/glance/glance-api.conf
sudo sed -i "$[linhaauthtoken+4] i\auth_type = password" /etc/glance/glance-api.conf
sudo sed -i "$[linhaauthtoken+5] i\project_domain_name = Default" /etc/glance/glance-api.conf
sudo sed -i "$[linhaauthtoken+6] i\user_domain_name = Default" /etc/glance/glance-api.conf
sudo sed -i "$[linhaauthtoken+7] i\project_name = service" /etc/glance/glance-api.conf
sudo sed -i "$[linhaauthtoken+8] i\username = glance" /etc/glance/glance-api.conf
sudo sed -i "$[linhaauthtoken+9] i\password = secret" /etc/glance/glance-api.conf

linhadeploy=`sudo awk '{if ($0 == "[paste_deploy]") {print NR;}}' /etc/glance/glance-api.conf`
sudo sed -i "$[linhadeploy+1] i\flavor = keystone" /etc/glance/glance-api.conf

linhastore=`sudo awk '{if ($0 == "[glance_store]") {print NR;}}' /etc/glance/glance-api.conf`
sudo sed -i "$[linhastore+1] i\stores = file,http" /etc/glance/glance-api.conf
sudo sed -i "$[linhastore+2] i\default_stores = file" /etc/glance/glance-api.conf
sudo sed -i "$[linhastore+3] i\filesystem_store_datadir = /var/lib/glance/images/" /etc/glance/glance-api.conf

sudo sed -i 's/sqlite:\/\/\/\/var\/lib\/glance\/glance.sqlite/mysql+pymysql:\/\/glance:secret@controller\/glance/' /etc/glance/glance-registry.conf

linhaauthtoken2=`sudo awk '{if ($0 == "[keystone_authtoken]") {print NR;}}' /etc/glance/glance-registry.conf`
sudo sed -i "$[linhaauthtoken2+1] i\auth_uri = http://controller:5000" /etc/glance/glance-registry.conf
sudo sed -i "$[linhaauthtoken2+2] i\auth_url = http://controller:5000" /etc/glance/glance-registry.conf
sudo sed -i "$[linhaauthtoken2+3] i\memcached_servers = controller:11211" /etc/glance/glance-registry.conf
sudo sed -i "$[linhaauthtoken2+4] i\auth_type = password" /etc/glance/glance-registry.conf
sudo sed -i "$[linhaauthtoken2+5] i\project_domain_name = Default" /etc/glance/glance-registry.conf
sudo sed -i "$[linhaauthtoken2+6] i\user_domain_name = Default" /etc/glance/glance-registry.conf
sudo sed -i "$[linhaauthtoken2+7] i\project_name = service" /etc/glance/glance-registry.conf
sudo sed -i "$[linhaauthtoken2+8] i\username = glance" /etc/glance/glance-registry.conf
sudo sed -i "$[linhaauthtoken2+9] i\password = secret" /etc/glance/glance-registry.conf

linhadeploy2=`sudo awk '{if ($0 == "[paste_deploy]") {print NR;}}' /etc/glance/glance-registry.conf`
sudo sed -i "$[linhadeploy2+1] i\flavor = keystone" /etc/glance/glance-registry.conf

sudo su -s /bin/sh -c "glance-manage db_sync" glance >> glance.log 2>> glance-error.log

sudo service glance-registry restart
if [ $? -ne 0 ]; then echo "NECOS: error"; fi
sudo service glance-api restart
if [ $? -ne 0 ]; then echo "NECOS: error"; fi

wget -q http://download.cirros-cloud.net/0.4.0/cirros-0.4.0-x86_64-disk.img >> wgetcirros.log 2>> wgetcirros-error.log

openstack image create "cirros" --file cirros-0.4.0-x86_64-disk.img --disk-format qcow2 --container-format bare --public >> cirros.log 2>> cirros-error.log
