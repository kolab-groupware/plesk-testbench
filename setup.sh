#!/usr/bin/env bash

#Prepare plesk so we can run this from a Dockerfile
export PATH=/usr/lib/plesk-9.0:/usr/lib64/plesk-9.0:$PATH
psa_service execute_actions
plesk bin admin --set-password -passwd Welcome2KolabSystems
psa_service startall

#Actual setup script starts here
IP=$(hostname -i)

#Install extensions
cp /root/data/panel.ini /usr/local/psa/admin/conf/
plesk bin extension -i /root/data/kolab.zip
cp /root/data/LicenseFaker.php /usr/local/psa/admin/plib/modules/kolab/library/
chmod 644 /usr/local/psa/admin/plib/modules/kolab/library/LicenseFaker.php
plesk bin extension -i /root/data/seafile.zip

#Setup default domain
plesk bin poweruser --on -ip $IP -domain bionic.whd.pxts.ch
plesk bin poweruser --off

#Create Kolab Reseller with plan
plesk bin reseller_plan -c "Kolab Reseller Plan" -ext_permission_kolab_manage_kolab true
plesk bin reseller --create kolab-reseller -name "Kolab Reseller" -passwd Welcome2KolabSystems -country US -service-plan "Kolab Reseller Plan"

plesk bin service_plan -c "Kolab Domain" -owner kolab-reseller -ext_permission_kolab_manage_kolab true

# Seafile addon
plesk bin service_plan_addon -c "Seafile" -owner kolab-reseller -ext_permission_seafile_manage_seafile true

# Kolab Customer with domain
plesk bin customer --create kolab-customer -name "Kolab Customer" -passwd Welcome2KolabSystems -country US -notify false
plesk bin subscription --create kolab-customer.maipo.whd.pxts.ch -owner kolab-reseller -service-plan "Kolab Domain" -ip $IP -login kolab-customer -passwd "Welcome2KolabSystems"

exit 0
