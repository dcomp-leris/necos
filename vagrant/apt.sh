sudo apt -qy update >> apt-update.log 2>> apt-update-error.log && sudo apt -qy upgrade >> apt-upgrade.log 2>> apt-upgrade-error.log

sudo apt -qy install python-openstackclient >> apt-openstackclient.log 2>> apt-openstackclient-error.log
