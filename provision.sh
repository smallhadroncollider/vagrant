# Variables
db=""
password=""

# Create databases
echo "
    CREATE DATABASE ${db} CHARACTER SET utf8 COLLATE utf8_general_ci;

    CREATE USER '${db}'@'localhost' IDENTIFIED BY '${password}';

    GRANT ALL PRIVILEGES ON ${db}.* TO '${db}'@'localhost';

    GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY 'root';

    FLUSH PRIVILEGES;
" | mysql -u root

# Update Composer & Migrate Database
cd /var/www && sudo composer self-update && sudo composer install && php artisan migrate

# Add rewrite rules to Nginx
echo "echo 'server {
    listen 80 default_server;

    root /var/www/public;
    index index.php;

    server_name localhost;

    location / {
         try_files \$uri \$uri/ /index.php\$is_args\$args;
    }

    location ~ \.php\$ {
        fastcgi_split_path_info ^(.+\.php)(/.+)\$;
        fastcgi_pass unix:/var/run/php5-fpm.sock;
        fastcgi_index index.php;
        include fastcgi_params;
    }
}' > /etc/nginx/sites-available/default" | sudo sh
sudo nginx -s reload

# Remove bind address - allows remote MySQL
sudo sed -r -i "s/bind\-address/#bind\-address/" /etc/mysql/my.cnf
sudo service mysql restart
