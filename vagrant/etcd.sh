sudo apt -qy install etcd >> apt-etcd.log 2>> apt-etcd-error.log

sudo tee -a /etc/default/etcd 1>/dev/null <<_EOF_

ETCD_NAME="controller"
ETCD_DATA_DIR="/var/lib/etcd"
ETCD_INITIAL_CLUSTER_STATE="new"
ETCD_INITIAL_CLUSTER_TOKEN="etcd-cluster-01"
ETCD_INITIAL_CLUSTER="controller=http://$1:2380"
ETCD_INITIAL_ADVERTISE_PEER_URLS="http://$1:2380"
ETCD_ADVERTISE_CLIENT_URLS="http://$1:2379"
ETCD_LISTEN_PEER_URLS="http://0.0.0.0:2380"
ETCD_LISTEN_CLIENT_URLS="http://$1:2379"
_EOF_

sudo systemctl enable etcd >> etcd.log 2>> etcd-error.log
if [ $? -ne 0 ]; then echo "NECOS: error"; fi
sudo systemctl start etcd
if [ $? -ne 0 ]; then echo "NECOS: error"; fi
