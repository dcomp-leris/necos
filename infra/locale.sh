#sudo touch /var/lib/cloud/instance/locale-check.skip
#if [ $? -ne 0 ]; then echo "NECOS: error"; fi

sudo locale-gen en_US en_US.UTF-8 pt_BR.UTF-8 >> locale-gen.log 2>> locale-gen-error.log
if [ $? -ne 0 ]; then echo "NECOS: error"; fi

sudo dpkg-reconfigure locales --default-priority >> dpkg-reconfigure.log 2>> dpkg-reconfigure-error.log
if [ $? -ne 0 ]; then echo "NECOS: error"; fi
