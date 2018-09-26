sudo apt -qy install memcached python-memcache >> apt-memcached.log 2>> apt-memcached-error.log

sudo sed -i 's/127.0.0.1/$1/' /etc/memcached.conf
if [ $? -ne 0 ]; then echo "NECOS: error"; fi
sudo service memcached restart
if [ $? -ne 0 ]; then echo "NECOS: error"; fi
