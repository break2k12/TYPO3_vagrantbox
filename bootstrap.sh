#!/usr/bin/env bash

apt-get update
apt-get install -y apache2 -f
if ! [ -L /var/www ]; then
  rm -rf /var/www
  ln -fs /vagrant /var/www
fi
sudo -s
sudo apt-get -y update
sudo apt-get -y upgrade

sudo apt-get -y install apache2 apache2-doc
sudo apt-get -y install php5
sudo apt-get -y install git

echo mysql-server mysql-server/root_password password root | sudo debconf-set-selections
echo mysql-server mysql-server/root_password_again password root | sudo debconf-set-selections
sudo apt-get -y install mysql-server

sudo apt-get -y install php-mysql
sudo apt-get -y install php-apc
sudo apt-get -y install php-curl
sudo apt-get -y install libapache2-mod-php
sudo apt-get -y install php-gd
sudo apt-get -y install php-gmp
sudo apt-get -y install php-imagick
sudo apt-get -y install imagemagick
sudo apt-get -y install graphicsmagick
sudo apt-get -y install vim

sudo a2enmod rewrite
sudo service apache2 restart

sudo chown -R www-data:www-data /var/www/html

cd  /var/www
if [ ! -e /var/www/typo3_src-7.6.22.tar.gz ]; then
    sudo wget http://prdownloads.sourceforge.net/typo3/typo3_src-7.6.22.tar.gz
fi
if [ ! -d /var/www/typo3_src-7.6.22 ]; then
    sudo tar xzf typo3_src-7.6.2.tar.gz
fi
if [ -e /var/www/typo3_src-7.6.2.tar.gz ]; then
    sudo rm -rf typo3_src-7.6.22.tar.gz
fi
cd /var/www/html
sudo ln -s ../typo3_src-7.6.22 typo3_src
sudo ln -s typo3_src/index.php index.php
sudo ln -s typo3_src/typo3 typo3
sudo cp typo3_src/_.htaccess .htaccess

cd /var/www/html/typo3conf
sudo mkdir -p /var/www/html/typo3conf/ext

echo -e "\n--- Add environment variables to Apache ---\n"
cat > /etc/apache2/sites-enabled/000-default.conf <<EOF
<VirtualHost *:80>
        ServerAdmin webmaster@localhost
        DocumentRoot /var/www/html
        ErrorLog ${APACHE_LOG_DIR}/error.log
        CustomLog ${APACHE_LOG_DIR}/access.log combined

</VirtualHost>
<Directory "/var/www/html">
    AllowOverride All
</Directory>

EOF

mysql --verbose --user=root --password=root --execute="create database dev"
mysql -u root -proot -h localhost dev < /var/www/html/source.sql
echo "Installation complete"
echo "Frontend: 127.0.0.1 - Backend: 127.0.0.1/typo3"
echo "Login User: admin Password: admin"
