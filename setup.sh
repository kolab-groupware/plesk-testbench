#!/usr/bin/env bash

export PATH=/usr/lib/plesk-9.0:/usr/lib64/plesk-9.0:$PATH
# This will run reconfiguration for a change of ip etc
psa_service execute_actions
# Set the admin password
plesk bin admin --set-password -passwd Welcome2KolabSystems
# Start all plesk services
psa_service startall

# Actual setup script starts here
IP=$(hostname -i)
DOMAIN=centos7.docker.pxts.ch

# Install extensions
cp /root/data/panel.ini /usr/local/psa/admin/conf/
plesk bin extension -i /root/data/kolab.zip
cp /root/data/LicenseFaker.php /usr/local/psa/admin/plib/modules/kolab/library/
chmod 644 /usr/local/psa/admin/plib/modules/kolab/library/LicenseFaker.php
plesk bin extension -i /root/data/seafile.zip

# Setup default domain
plesk bin poweruser --on -ip $IP -domain $DOMAIN
plesk bin poweruser --off

# Create Kolab Reseller with plan
plesk bin reseller_plan -c "Kolab Reseller Plan" -ext_permission_kolab_manage_kolab true -ext_permission_seafile_manage_seafile true -create_domains true -manage_phosting true -ip_pool add:$IP
plesk bin reseller --create kolab-reseller -name "Kolab Reseller" -passwd Welcome2KolabSystems -service-plan "Kolab Reseller Plan" -email "kolab-reseller@$DOMAIN"

plesk bin service_plan -c "Kolab Domain" -owner kolab-reseller -ext_permission_kolab_manage_kolab true -ext_permission_seafile_manage_seafile false

# Seafile addon
plesk bin service_plan_addon -c "Seafile" -owner kolab-reseller -ext_permission_seafile_manage_seafile true

# Kolab Customer with domain
plesk bin customer --create kolab-customer -name "Kolab Customer" -passwd Welcome2KolabSystems -notify false -email "kolab-customer@$DOMAIN"
plesk bin subscription --create kolab-customer.$DOMAIN -owner kolab-reseller -service-plan "Kolab Domain" -ip $IP -login kolab-customer -passwd "Welcome2KolabSystems"


function waitForServiceState() {
    while true; do
        STATE=$(systemctl is-active $1)
        if [ $STATE == $2 ]; then
            break
        fi
        if [ $STATE == "failed" ]; then
            echo "The service $1 we're waiting on failed."
            break
        fi
        echo "Waiting for $1 to go to state $2, but it's in $STATE"
        sleep 3
    done
}

# For lack of a better method we wait until the service is started, and assume the setup is complete with that.
waitForServiceState seafile@8000.service "active"
waitForServiceState seahub@8001.service "active"

# Teardown so we can safely commit the container (otherwise we may still have tasks in progress)
psa_service stopall
systemctl stop seafile@8000.service
systemctl stop seahub@8001.service
systemctl stop mariadb.service
systemctl stop httpd.service

exit 0
