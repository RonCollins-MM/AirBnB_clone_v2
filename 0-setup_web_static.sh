#!/usr/bin/env bash
# sets up web server for deployment of web_static

echo -e "\e[1;32m START\e[0m"
#--Update packages
sudo apt-get -y update
sudo apt-get -y install nginx
echo -e "\e[1;32m Packages updated\e[0m"
echo

sudo ufw allow 'Nginx HTTP'
#sudo -e "\e[1;32m Allow incoming NGINX HTTP connections\e[0m"
echo

sudo mkdir -p /data/web_static/releases/test /data/web_static/shared
echo -e "\e[1;32m directories created"
echo "<h1>Welcome to www.daktari.tech</h1>" > /data/web_static/releases/test/index.html
echo -e "\e[1;32m Test content added\e[0m"

if [ -d "/data/web_static/current" ];then
	echo "path /data/web_static/current exists"
	sudo rm -rf /data/web_static/current;
fi;
echo -e "\e[1;32m prevent overwrite\e[0m"

sudo ln -sf /data/web_static/releases/test/ /data/web_static/current
sudo chown -hR ubuntu:ubuntu /data

new_config=\
"server {
        listen 80 default_server;
        listen [::]:80 default_server;

	root /var/www/html;
        index index.html index.htm index.nginx-debian.html;

	add_header X-Served-By \$hostname;
        location / {
                try_files \$uri \$uri/ =404;
        }

        location /hbnb_static {
            alias /data/web_static/current;
            index index.html index.htm;
        }

        error_page 404 /404.html;
        location  /404 {
	    root /var/www/html;
            internal;
        }
        
        location /redirect_me {
            return 301 https://www.youtube.com/user/Computerphile;
        }

}
"
echo "Ceci n'est pas une page" > /var/www/html/404.html
echo "$new_config" > /etc/nginx/sites-available/default

sudo ln -sf '/etc/nginx/sites-available/default' '/etc/nginx/sites-enabled/default'
echo -e "\e[1;32m Symbolic link created\e[0m"

if [ "$(pgrep -c nginx)" -le 0 ];
then
    service nginx start
    echo -e "\e[1;32m start NGINX\e[0m"
else
    service nginx restart
    echo -e "\e[1;32m restart NGINX\e[0m"
fi;
