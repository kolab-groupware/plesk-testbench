#!/usr/bin/env bash

LICENSE=$(cat /root/license)

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
        --install-component ruby \
        --install-component nodejs \
        --install-component wp-toolkit

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
