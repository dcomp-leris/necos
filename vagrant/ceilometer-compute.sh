sudo apt -qy install ceilometer-agent-compute >> apt-ceilometer-compute.log 2>> apt-ceilometer-compute-error.log
#sudo apt -qy install ceilometer-agent-ipmi >> apt-ceilometer-ipmi.log 2>> apt-ceilometer-ipmi-error.log

linhadefaultceilometer=`sudo awk '{if ($0 == "[DEFAULT]") {print NR;}}' /etc/ceilometer/ceilometer.conf`
sudo sed -i "$[linhadefaultceilometer+1] i\transport_url = rabbit://openstack:$2@controller" /etc/ceilometer/ceilometer.conf

linhacredentialsceilometer=`sudo awk '{if ($0 == "[service_credentials]") {print NR;}}' /etc/ceilometer/ceilometer.conf`
sudo sed -i "$[linhacredentialsceilometer+1] i\auth_url = http://controller:5000" /etc/ceilometer/ceilometer.conf
sudo sed -i "$[linhacredentialsceilometer+2] i\project_domain_id = default" /etc/ceilometer/ceilometer.conf
sudo sed -i "$[linhacredentialsceilometer+3] i\user_domain_id = default" /etc/ceilometer/ceilometer.conf
sudo sed -i "$[linhacredentialsceilometer+4] i\auth_type = password" /etc/ceilometer/ceilometer.conf
sudo sed -i "$[linhacredentialsceilometer+5] i\username = ceilometer" /etc/ceilometer/ceilometer.conf
sudo sed -i "$[linhacredentialsceilometer+6] i\project_name = service" /etc/ceilometer/ceilometer.conf
sudo sed -i "$[linhacredentialsceilometer+7] i\password = $2" /etc/ceilometer/ceilometer.conf
sudo sed -i "$[linhacredentialsceilometer+8] i\interface = internalURL" /etc/ceilometer/ceilometer.conf
sudo sed -i "$[linhacredentialsceilometer+9] i\region_name = RegionOne" /etc/ceilometer/ceilometer.conf

linhadefaultnova=`sudo awk '{if ($0 == "[DEFAULT]") {print NR;}}' /etc/nova/nova.conf`
sudo sed -i "$[linhadefaultnova+8] i\instance_usage_audit = True" /etc/nova/nova.conf
sudo sed -i "$[linhadefaultnova+9] i\instance_usage_audit_period = hour" /etc/nova/nova.conf
sudo sed -i "$[linhadefaultnova+10] i\notify_on_state_change = vm_and_task_state" /etc/nova/nova.conf

linhanotificationsnova=`sudo awk '{if ($0 == "[oslo_messaging_notifications]") {print NR;}}' /etc/nova/nova.conf`
sudo sed -i "$[linhanotificationsnova+1] i\driver = messagingv2" /etc/nova/nova.conf

# UNFINISHED: DID NOT WORKED!!! IT'S NOT POSSIBLE EDIT /etc/sudors OR polling.yaml
#sudo echo "" >> /etc/sudoers
#sudo echo ".. code-block:: ini" >> /etc/sudoers
#sudo echo "ceilometer ALL = (root) NOPASSWD: /usr/bin/ceilometer-rootwrap /etc/ceilometer/rootwrap.conf *" >> /etc/sudoers
#sudo echo "    - name: ipmi" >> ./polling.yaml
#sudo echo "      interval: 300" >> ./polling.yaml
#sudo echo "      meters:" >> ./polling.yaml
#sudo echo "        - hardware.ipmi.temperature" >> ./polling.yaml

sudo service ceilometer-agent-compute restart
if [ $? -ne 0 ]; then echo "NECOS: error"; fi
#sudo service ceilometer-agent-ipmi restart
#if [ $? -ne 0 ]; then echo "NECOS: error"; fi
sudo service nova-compute restart
if [ $? -ne 0 ]; then echo "NECOS: error"; fi
