sudo apt -qy install chrony >> apt-chrony.log 2>> apt-chrony-error.log

sudo sed -i 's/^pool/#pool/' /etc/chrony/chrony.conf
sudo sed -i '1 i\pool controller iburst maxsources 4' /etc/chrony/chrony.conf
sudo sed -i '1 i\# NECOS' /etc/chrony/chrony.conf

sudo service chrony restart
if [ $? -ne 0 ]; then echo "NECOS: error"; fi
