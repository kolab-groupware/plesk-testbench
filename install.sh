#!/usr/bin/env bash

LICENSE=$(cat /license)

bash /root/ai \
        --all-versions \
        --select-product-id=plesk \
        --select-release-latest \
        --tier testing \
        --install-component panel \
        --install-component phpgroup \
        --install-component web-hosting \
        --install-component mod_fcgid \
        --install-component proftpd \
        --install-component webservers \
        --install-component nginx \
        --install-component mysqlgroup \
        --install-component php5.6 \
        --install-component php7.2 \
        --install-component l10n \
        --install-component heavy-metal-skin \
        --install-component git \
        --install-component passenger \
        --install-component postfix \
        --install-component dovecot

plesk bin init_conf --init \
        -email admin@pxts.ch \
        -passwd Welcome2KolabSystems \
        -hostname-not-required

plesk bin license -i $LICENSE
plesk bin settings --set admin_info_not_required=true
plesk bin poweruser --off
plesk bin cloning -u -prepare-public-image true -reset-license false -reset-init-conf false -skip-update true
plesk bin ipmanage --auto-remap-ip-addresses true
echo DOCKER > /usr/local/psa/var/cloud_id
rm -rf /root/ai /root/parallels

# Otherwise we'll end up stuckk with the maintenance view if we commit too early
while grep "maintenance on" /etc/sw-cp-server/conf.d/maintenance ; do
  echo "Waiting for maintenance to finish..."
  sleep 3
done

export PATH=/usr/lib/plesk-9.0:/usr/lib64/plesk-9.0:$PATH
psa_service stopall
systemctl stop mariadb.service
systemctl stop httpd.service
# This shouldn't be necessary...
echo "set maintenance off;" > /etc/sw-cp-server/conf.d/maintenance
