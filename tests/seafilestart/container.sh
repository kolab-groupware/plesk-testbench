#!/usr/bin/env bash
cp /root/data/panel.ini /usr/local/psa/admin/conf/

#Prepare plesk so we can run this from a Dockerfile
export PATH=/usr/lib/plesk-9.0:/usr/lib64/plesk-9.0:$PATH
psa_service execute_actions
plesk bin admin --set-password -passwd Welcome2KolabSystems
psa_service startall

#Actual setup script starts here
IP=$(hostname -i)

echo "Installing Seafile extension:"
#Install extensions
plesk bin extension -i /root/data/kolab.zip || exit 1
cp /root/data/LicenseFaker.php /usr/local/psa/admin/plib/modules/kolab/library/
chmod 644 /usr/local/psa/admin/plib/modules/kolab/library/LicenseFaker.php
plesk bin extension -i /root/data/seafile.zip || exit 1

echo "Looking for errors:"
#There shouldn't be any errors
grep ERR /var/log/plesk/panel.log && echo "Found errors in the following log:" && cat /var/log/plesk/panel.log && exit 1

echo "Found no errors"

plesk bin poweruser --on -ip $IP -domain centos7.dockertest.pxts.ch
plesk bin poweruser --off

#Ensure the domain home is existing
#/var/www/vhosts/bionic.whd.pxts.ch/

# Wait for hooks to execute that were listening on the domain being created
sleep 5

# Ensure seafile is running
# $(systemctl | grep sea | grep running | wc -l)

echo "Looking for errors after setting up domain:"
#There shouldn't be any errors
grep ERR /var/log/plesk/panel.log && echo "Found errors in the following log:" && cat /var/log/plesk/panel.log && exit 1

echo "Found no errors"
