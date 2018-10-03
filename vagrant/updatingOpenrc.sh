{
        echo "export OS_PROJECT_DOMAIN_NAME=Default"
        echo "export OS_USER_DOMAIN_NAME=Default"
        echo "export OS_PROJECT_NAME=admin"
        echo "export OS_USERNAME=admin"
        echo "export OS_PASSWORD=$1"
        echo "export OS_AUTH_URL=http://controller:5000/v3"  
        echo "export OS_IDENTITY_API_VERSION=3"
        echo "export OS_IMAGE_API_VERSION=2"
        echo "export OS_AUTH_TYPE=password"
} > admin-openrc

{
        echo "export OS_PROJECT_DOMAIN_NAME=Default"
        echo "export OS_USER_DOMAIN_NAME=Default"
        echo "export OS_PROJECT_NAME=demo"
        echo "export OS_USERNAME=demo"
        echo "export OS_PASSWORD=$1"
        echo "export OS_AUTH_URL=http://controller:5000/v3"  
        echo "export OS_IDENTITY_API_VERSION=3"
        echo "export OS_IMAGE_API_VERSION=2"
        echo "export OS_AUTH_TYPE=password"
} > demo-openrc