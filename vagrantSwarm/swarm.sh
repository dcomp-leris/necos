git clone https://github.com/vegasbrianc/prometheus.git
HOSTNAME=$(hostname) docker stack deploy -c docker-stack.yml prom


docker volume create portainer_data
docker run -d -p 9000:9000 -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer
