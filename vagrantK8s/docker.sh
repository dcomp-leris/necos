sudo apt -qy install apt-transport-https ca-certificates curl software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

sudo apt -qy update

sudo apt -qy install docker-ce

sudo groupadd docker

sudo usermod -aG docker $USER

echo "Reinicie a máquina!!!"
