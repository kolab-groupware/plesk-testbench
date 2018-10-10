#!/usr/bin/env bash
plesk bin extension -i /root/data/kolab.zip
cp /root/data/LicenseFaker.php /usr/local/psa/admin/plib/modules/kolab/library/
chmod 644 /usr/local/psa/admin/plib/modules/kolab/library/LicenseFaker.php
plesk bin extension -i /root/data/seafile.zip
