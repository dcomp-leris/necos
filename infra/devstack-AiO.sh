useradd -s /bin/bash -d /opt/stack -m stack
echo "stack ALL=(ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/stack
su - stack
git clone https://git.openstack.org/openstack-dev/devstack
cd devstack
echo -e "[[local|localrc]]\nADMIN_PASSWORD=secret\nDATABASE_PASSWORD=secret\nRABBIT_PASSWORD=secret\nSERVICE_PASSWORD=secret" >> local.conf
echo "HOST_IP=`hostname -I | cut -d " " -f 2`" >> local.conf
./stack.sh
