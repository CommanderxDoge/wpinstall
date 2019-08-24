# #!/bin/bash
sitename=$1
dbuser='root'
dbpass='witek'
dbhost='localhost'
wwwpath='/var/www/'
ip='127.0.0.1 '
wpuser=admin
wppass=wilk44
email=wit.paw4@gmail.com

sufixlocal='.local'
prefixhttp='http://'
url=$prefixhttp$sitename$sufixlocal

# add to hosts new local domain
echo '' | sudo tee -a /etc/hosts
echo $ip$sitename$sufixlocal | sudo tee -a /etc/hosts

# add to vhosts new virtual host
USAGE=$(cat <<-END
<VirtualHost *:80> \n
<FilesMatch \.php$> \n
#Apache 2.4.10+ can proxy to unix socket \n
SetHandler "proxy:unix:/var/run/php/php7.3-fpm.sock|fcgi://localhost/" \n
</FilesMatch> \n
ServerName $sitename.local \n
ServerAdmin wit.paw4@gmail.com \n
DocumentRoot /var/www/$sitename/ \n
</VirtualHost> \n
END
)

echo $USAGE | sudo tee -a /etc/apache2/sites-enabled/vhosts.conf

#go to www path
cd $wwwpath

#create new direcotry of site
mkdir $sitename

#go to the direcotry of new site
newsitepath=$wwwpath$sitename
cd $newsitepath

#install wordpress
wp core download
wp config create --dbname=$sitename --dbuser=$dbuser --dbpass=$dbpass --dbhost=$dbhost
wp db create
wp core install --url=$url --title=$sitename --admin_user=$wpuser --admin_password=$wppass --admin_email=$email

#restart apache
sudo service apache2 restart

google-chrome $url
