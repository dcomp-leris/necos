sudo apt -qy install mysql-server python-pymysql >> apt-mysql.log 2>> apt-mysql-error.log

sudo sed -i 's/127.0.0.1/$1/' /etc/mysql/mysql.conf.d/mysqld.cnf
sudo sed -i 's/^#max_connections/max_connections/' /etc/mysql/mysql.conf.d/mysqld.cnf
sudo sed -i 's/= 100$/= 4096/' /etc/mysql/mysql.conf.d/mysqld.cnf
#linha=`awk '{if ($0 == "[mysqld]") {print NR;}}' /etc/mysql/mysql.conf.d/mysqld.cnf`
#sudo sed -i "$[linha+1] i\innodb_file_per_table = on" /etc/mysql/mysql.conf.d/mysqld.cnf
sudo service mysql restart
if [ $? -ne 0 ]; then echo "NECOS: error"; fi

sudo mysql --user=root <<_EOF_
UPDATE mysql.user SET Password=PASSWORD('$2') WHERE User='root';
DELETE FROM mysql.user WHERE User='';
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
DROP DATABASE IF EXISTS test;
DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';
FLUSH PRIVILEGES;
_EOF_

#sudo mysql_secure_installation >> mysql.log 2>> mysql-error.log <<_EOF_
#
#Y
#$2
#$2
#Y
#Y
#Y
#Y
#_EOF_
