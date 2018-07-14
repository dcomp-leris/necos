sudo mysql --user=root <<_EOF_
CREATE DATABASE keystone;
GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'localhost' IDENTIFIED BY 'secret';
GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'%' IDENTIFIED BY 'secret';
_EOF_

sudo apt -qy install keystone >> apt-keystone.log 2>> apt-keystone-error.log
#sudo apt -qy install apache2 >> apt-apache2.log 2>> apt-apache2-error.log
#sudo apt -qy install libapache2-mod-wsgi >> apt-libapache2.log 2>> apt-libapache2-error.log

sudo sed -i 's/sqlite:\/\/\/\/var\/lib\/keystone\/keystone.db/mysql+pymysql:\/\/keystone:secret@controller\/keystone/' /etc/keystone/keystone.conf
linhakeystone=`sudo awk '{if ($0 == "[token]") {print NR;}}' /etc/keystone/keystone.conf`
sudo sed -i "$[linhakeystone+1] i\provider = fernet" /etc/keystone/keystone.conf

sudo su -s /bin/sh -c "keystone-manage db_sync" keystone
sudo keystone-manage fernet_setup --keystone-user keystone --keystone-group keystone
sudo keystone-manage credential_setup --keystone-user keystone --keystone-group keystone

sudo keystone-manage bootstrap --bootstrap-password secret --bootstrap-admin-url http://controller:5000/v3/ --bootstrap-internal-url http://controller:5000/v3/ --bootstrap-public-url http://controller:5000/v3/ --bootstrap-region-id RegionOne

sudo sh -c "echo 'ServerName controller' >> /etc/apache2/apache2.conf"
sudo service apache2 restart
if [ $? -ne 0 ]; then echo "NECOS: error"; fi

#export OS_USERNAME=admin; export OS_PASSWORD=secret; export OS_PROJECT_NAME=admin; export OS_USER_DOMAIN_NAME=Default; export OS_PROJECT_DOMAIN_NAME=Default; export OS_AUTH_URL=http://controller:5000/v3; export OS_IDENTITY_API_VERSION=3
