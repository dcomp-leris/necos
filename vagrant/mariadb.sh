sudo apt -qy install mariadb-server >> apt-mariadb.log 2>> apt-mariadb-error.log
sudo apt -qy install python-pymysql >> apt-pymysql.log 2>> apt-pymysql-error.log

touch /etc/mysql/mariadb.conf.d/99-openstack.cnf

sudo tee -a /etc/mysql/mariadb.conf.d/99-openstack.cnf 1>/dev/null <<_EOF_
[mysqld]
bind-address = 10.0.0.11

default-storage-engine = innodb
innodb_file_per_table = on
max_connections = 4096
collation-server = utf8_general_ci
character-set-server = utf8
_EOF_

#sudo sed -i "s/127.0.0.1/$1/" /etc/mysql/mariadb.conf.d/50-server.cnf
#sudo sed -i 's/^#max_connections/max_connections/' /etc/mysql/mariadb.conf.d/50-server.cnf
#sudo sed -i 's/= 100$/= 4096/' /etc/mysql/mariadb.conf.d/50-server.cnf
#sudo sed -i 's/utf8mb4/utf8/' /etc/mysql/mariadb.conf.d/50-server.cnf
#linha=`awk '{if ($0 == "[mysqld]") {print NR;}}' /etc/mysql/mariadb.conf.d/50-server.cnf`
#sudo sed -i "$[linha+1] i\innodb_file_per_table = on" /etc/mysql/mariadb.conf.d/50-server.cnf
sudo service mysql restart
if [ $? -ne 0 ]; then echo "NECOS: error"; fi

sudo mysql --user=root <<_EOF_
UPDATE mysql.user SET plugin='', Password=PASSWORD('$2') WHERE User='root';
GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' IDENTIFIED BY '$2';
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '$2';
DELETE FROM mysql.user WHERE User='';
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
DROP DATABASE IF EXISTS test;
DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';
FLUSH PRIVILEGES;
_EOF_

#sudo mysql_secure_installation >> mariadb.log 2>> mariadb-error.log <<_EOF_
#
#Y
#$2
#$2
#Y
#Y
#Y
#Y
#_EOF_
