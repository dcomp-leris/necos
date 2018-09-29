sudo apt -qy install apt-transport-https ca-certificates curl software-properties-common >> apt-depend-docker.log 2>>apt-depend-docker-error.log

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" >> add-apt-repos-docker.log 2>>add-apt-repos-docker-error.log

sudo apt -qy update >> apt-update-docker.log 2>>apt-update-docker-error.log

sudo apt -qy install docker-ce >>apt-docker.log 2>>apt-docker-error.log

