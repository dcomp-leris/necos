#source necos/vagrant/admin-openrc

openstack user create --domain default --password secret ceilometer >> ceilometer.log 2>> ceilometer-error.log
openstack role add --project service --user ceilometer admin >> ceilometer.log 2>> ceilometer-error.log
openstack user create --domain default --password secret gnocchi >> ceilometer.log 2>> ceilometer-error.log
openstack service create --name gnocchi --description "Metric Service" metric >> ceilometer.log 2>> ceilometer-error.log
openstack role add --project service --user gnocchi admin >> ceilometer.log 2>> ceilometer-error.log
openstack endpoint create --region RegionOne metric public http://controller:8041 >> ceilometer.log 2>> ceilometer-error.log
openstack endpoint create --region RegionOne metric internal http://controller:8041 >> ceilometer.log 2>> ceilometer-error.log
openstack endpoint create --region RegionOne metric admin http://controller:8041 >> ceilometer.log 2>> ceilometer-error.log

sudo apt -qy install gnocchi-api gnocchi-metricd python-gnocchiclient

