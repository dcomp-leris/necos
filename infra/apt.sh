export DEBIAN_FRONTEND=noninteractive
export DEBIAN_PRIORITY=critical
sudo -E apt -qq update
sudo -E apt -qq -o "Dpkg::Options::=--force-confdef" -o "Dpkg::Options::=--force-confold" upgrade
sudo -E apt -qq autoclean
