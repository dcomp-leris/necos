sudo apt -qy install chrony >> apt-chrony.log 2>> apt-chrony-error.log

sudo sh -c "echo '' >> /etc/chrony/chrony.conf"
sudo sh -c "echo '# NECOS' >> /etc/chrony/chrony.conf"
sudo sh -c "echo 'allow $1/24' >> /etc/chrony/chrony.conf"

sudo service chrony restart
if [ $? -ne 0 ]; then echo "NECOS: error"; fi
