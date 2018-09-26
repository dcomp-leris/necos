ipController=$1
ipCompute1=$2


sudo tee /etc/hosts 1>/dev/null <<_EOF_
127.0.0.1	localhost
# controller
$ipController       controller
# compute1 and compute2
$ipCompute1       compute1
_EOF_