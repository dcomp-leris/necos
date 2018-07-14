sudo touch /var/lib/cloud/instance/locale-check.skip
if [ $? -ne 0 ]; then echo "NECOS: error"; fi
