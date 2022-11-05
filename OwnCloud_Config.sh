SRC : https://doc.owncloud.com/server/10.11/admin_manual/installation/quick_guides/ubuntu_20_04.html

#! /bin/bash
#
#Source de ce Script : Owncloud 
#https://doc.owncloud.com/server/next/admin_manual/installation/quick_guides/ubuntu_20_04.html
#

my_domain="SRV-LIN1-02.local"

sec_admin_pwd="owncloud_admin"

sec_db_pwd="owncloud_db_admin"


FILE="/usr/local/bin/occ"
cat <<EOM >$FILE
#! /bin/bash
cd /var/www/owncloud
sudo -E -u www-data /usr/bin/php /var/www/owncloud/occ "\$@"
EOM


chmod +x $FILE


apt install -y \
  apache2 libapache2-mod-php \
  mariadb-server openssl redis-server wget php-imagick \
  php-common php-curl php-gd php-gmp php-bcmath php-imap \
  php-intl php-json php-mbstring php-mysql php-ssh2 php-xml \
  php-zip php-apcu php-redis php-ldap php-phpseclib


apt-get install -y libsmbclient-dev php-dev php-pear



pecl channel-update pecl.php.net
mkdir -p /tmp/pear/cache
pecl install smbclient-stable
echo "extension=smbclient.so" > /etc/php/7.4/mods-available/smbclient.ini
phpenmod smbclient
systemctl restart apache2


php -m | grep smbclient


apt install -y \
  unzip bzip2 rsync curl jq \
  inetutils-ping  ldap-utils\
  smbclient


FILE="/etc/apache2/sites-available/owncloud.conf"
cat <<EOM >$FILE

<VirtualHost *:80>
ServerName $my_domain
DirectoryIndex index.php index.html
DocumentRoot /var/www/owncloud
<Directory /var/www/owncloud>
  Options +FollowSymlinks -Indexes
  AllowOverride All
  Require all granted

 <IfModule mod_dav.c>
  Dav off
 </IfModule>

 SetEnv HOME /var/www/owncloud
 SetEnv HTTP_HOME /var/www/owncloud
</Directory>

</VirtualHost>

EOM


a2dissite 000-default
a2ensite owncloud.conf


sed -i "/\[mysqld\]/atransaction-isolation = READ-COMMITTED\nperformance_schema = on" /etc/mysql/mariadb.conf.d/50-server.cnf
systemctl start mariadb
mysql -u root -e "CREATE DATABASE IF NOT EXISTS owncloud; \
GRANT ALL PRIVILEGES ON owncloud.* \
  TO owncloud@localhost \
  IDENTIFIED BY '${sec_db_pwd}'";


systemctl restart apache2

a2enmod dir env headers mime rewrite setenvif
systemctl restart apache2


cd /var/www/
wget https://download.owncloud.com/server/stable/owncloud-complete-latest.tar.bz2 && \
tar -xjf owncloud-complete-latest.tar.bz2 && \

chown -R www-data. owncloud
chown -R www-data. /mnt/nfs_omv/owncloud


occ maintenance:install \
    --database "mysql" \
    --database-name "owncloud" \
    --database-user "owncloud" \
    --database-pass ${sec_db_pwd} \
    --data-dir "/var/www/owncloud/data" \
    --admin-user "admin" \
    --admin-pass ${sec_admin_pwd}

my_ip=$(hostname -I|cut -f1 -d ' ')
occ config:system:set trusted_domains 1 --value="$my_ip"
occ config:system:set trusted_domains 2 --value="$my_domain"
occ config:system:set trusted_domains 3 --value="www.lin1.local"

rm -r /var/www/owncloud/core/skeleton/*
mkdir /var/www/owncloud/core/skeleton/Perso