sudo apt -qy install rabbitmq-server >> apt-rabbitmq.log 2>> apt-rabbitmq-error.log

sudo rabbitmqctl add_user openstack secret >> rabbitmq.log
if [ $? -ne 0 ]; then echo "NECOS: error"; fi
sudo rabbitmqctl set_permissions openstack ".*" ".*" ".*" >> rabbitmq.log
if [ $? -ne 0 ]; then echo "NECOS: error"; fi
