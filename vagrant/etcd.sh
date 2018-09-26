sudo apt -qy install etcd >> apt-etcd.log 2>> apt-etcd-error.log

sudo mkdir /etc/etcd

sudo sh -c "echo 'name: controller' >> /etc/etcd/etcd.conf.yml"
sudo sh -c "echo 'data-dir: /var/lib/etcd' >> /etc/etcd/etcd.conf.yml"
sudo sh -c "echo 'initial-cluster-state: new' >> /etc/etcd/etcd.conf.yml"
sudo sh -c "echo 'initial-cluster-token: etcd-cluster-01' >> /etc/etcd/etcd.conf.yml"
sudo sh -c "echo 'initial-cluster: controller=http://$1:2380' >> /etc/etcd/etcd.conf.yml"
sudo sh -c "echo 'initial-advertise-peer-urls: http://$1:2380' >> /etc/etcd/etcd.conf.yml"
sudo sh -c "echo 'advertise-client-urls: http://$1:2379' >> /etc/etcd/etcd.conf.yml"
sudo sh -c "echo 'listen-peer-urls: http://0.0.0.0:2380' >> /etc/etcd/etcd.conf.yml"
sudo sh -c "echo 'listen-client-urls: http://$1:2379' >> /etc/etcd/etcd.conf.yml"

sudo sed -i "s/new/\'new\'/" /etc/etcd/etcd.conf.yml
sudo sed -i "s/etcd-cluster-01/\'etcd-cluster-01\'/" /etc/etcd/etcd.conf.yml

sudo sed -i 's/on-abnormal/on-failure/' /lib/systemd/system/etcd.service
sudo sed -i 's/ExecStart=\/usr\/bin\/etcd \$DAEMON_ARGS/ExecStart=\/usr\/bin\/etcd \-\-config\-file \/etc\/etcd\/etcd\.conf\.yml/' /lib/systemd/system/etcd.service

sudo systemctl enable etcd >> etcd.log 2>> etcd-error.log
sudo systemctl start etcd
if [ $? -ne 0 ]; then echo "NECOS: error"; fi
