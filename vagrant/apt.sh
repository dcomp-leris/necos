sudo apt -qy update >> apt-update.log 2>> apt-update-error.log 

sudo apt -qy upgrade >> apt-upgrade.log 2>> apt-upgrade-error.log

sudo apt -qy install software-properties-common >> apt-common.log 2>> apt-common-error.log

sudo add-apt-repository cloud-archive:rocky -y >> apt-repository.log 2>> apt-repository-error.log

sudo apt -qy update >> apt-update.log 2>> apt-update-error.log

sudo apt -qy dist-upgrade >> apt-distupgrade.log 2>> apt-distupgrade-error.log

sudo apt -qy install python-openstackclient >> apt-openstackclient.log 2>> apt-openstackclient-error.log
