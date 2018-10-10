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
grep ERR /var/log/plesk/panel.log || exit 0
echo "Found errors in the following log:"
cat /var/log/plesk/panel.log
exit 1
