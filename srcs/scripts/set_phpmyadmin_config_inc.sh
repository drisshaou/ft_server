#!/bin/bash

mkdir /etc/phpmyadmin
mkdir -p /var/lib/phpmyadmin/tmp
chown -R www-data:www-data /var/lib/phpmyadmin
touch /etc/phpmyadmin/htpasswd.setup
cd /usr/share/phpmyadmin
randomBlowfishSecret=$(openssl rand -base64 32 | fold -w 32 | head -n 1)
sed -e "s|cfg\['blowfish_secret'\] = ''|cfg['blowfish_secret'] = '$randomBlowfishSecret'|" config.sample.inc.php > config.inc.php
echo "\n/**\n* The directory which PHPMyAdmin shall use to store temporary files\n*/\n\$cfg['TempDir'] = '/var/lib/phpmyadmin/tmp';" >> config.inc.php
