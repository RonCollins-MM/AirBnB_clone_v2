#!/usr/bin/env bash
# installs and configures a server to serve aribnb clone
sudo apt-get -y update
sudo apt-get -y upgrade
sudo apt-get -y install nginx
sudo ufw allow 'Nginx HTTP'
sudo mkdir -p /data/web_static/
sudo mkdir -p /data/web_static/releases/
sudo mkdir -p /data/web_static/shared/
sudo mkdir -p /data/web_static/releases/test/

if [ -d "/data/web_static/current" ];then
    echo "path /data/web_static/current exists"
    sudo rm -rf /data/web_static/current;
fi;

sudo ln -sf /data/web_static/releases/test/ /data/web_static/current
sudo chown -hR ubuntu:ubuntu /data/
echo -e "<html>\n\
     <head>\n\
     </head>\n\
     <body>\n\
	This is Machiestay's domanin, you are welcome\n\
     </body>\n\
</html>" | sudo tee /data/web_static/releases/test/index.html > /dev/null
sudo chmod g+w /data/web_static/releases/test/index.html
echo -e "server {\n\
    listen 80 default_server;\n\
    listen [::]:80 default_server;\n\
    add_header X-Served-By $HOSTNAME;\n\
    root /var/www/html;\n\n\
    index index.html;\n\n\
    location /hbnb_static/ {\n\
    	     alias /data/web_static/current/;\n\
	     index index.html index.htm;\n\
    }\n\
    location /redirect_me {\n\
        return 301 http://cuberule.com/;\n\
    }\n\
    error_page 404 /404.html;\n\
    location /404 {\n\
      root /var/www/html;\n\
      internal;\n\
    }\n\
}" | sudo tee /etc/nginx/sites-available/default > /dev/null
sudo ln -sf '/etc/nginx/sites-available/default' '/etc/nginx/sites-enabled/default'
sudo service nginx restart
