#!/bin/bash

# Enable debugging mode
set -x

# Update all packages
sudo yum update -y

# Install PHP 8 and required extensions
sudo dnf install -y httpd php php-cli php-fpm php-mysqlnd php-bcmath php-ctype php-fileinfo php-json php-mbstring php-openssl php-pdo php-gd php-tokenizer php-xml php-curl

# Update PHP settings for memory and execution time
sudo sed -i '/^memory_limit =/ s/=.*$/= 256M/' /etc/php.ini
sudo sed -i '/^max_execution_time =/ s/=.*$/= 300/' /etc/php.ini

# Enable mod_rewrite in Apache for .htaccess support
sudo sed -i '/<Directory "\/var\/www\/html">/,/<\/Directory>/ s/AllowOverride None/AllowOverride All/' /etc/httpd/conf/httpd.conf

#
## Application setup
#

# Download the app zip file from S3
sudo aws s3 cps 3://dg-project-web-files/shopwise.zip /var/www/html

# Navigate to web directory
cd /var/www/html

# Unzip the app code
sudo unzip shopwise.zip

# Copy all files from 'shopwise' to web root
sudo cp -R shopwise/. /var/www/html/

# Remove the 'shopwise' directory and zip file
sudo rm -rf shopwise shopwise.zip

# Set permissions for web and storage directories
sudo chmod -R 777 /var/www/html
sudo chmod -R 777 /var/www/html/bootstrap/cache/
sudo chmod -R 777 /var/www/html/storage/

# Update .env variables
sudo sed -i "/^APP_NAME=/ s/=.*$/=${PROJECT_NAME}-${ENVIRONMENT}/" .env
sudo sed -i "/^APP_URL=/ s/=.*$/=https:\/\/${RECORD_NAME}.${DOMAIN_NAME}\//" .env
sudo sed -i "/^DB_HOST=/ s/=.*$/=${RDS_ENDPOINT}/" .env
sudo sed -i "/^DB_DATABASE=/ s/=.*$/=${RDS_DB_NAME}/" .env
sudo sed -i "/^DB_USERNAME=/ s/=.*$/=${USERNAME}/" .env
sudo sed -i "/^DB_PASSWORD=/ s/=.*$/=${PASSWORD}/" .env

# Replace AppServiceProvider.php
sudo aws s3 cp s3://dillon1-app-service-provider-files/shopwise-AppServiceProvider.php /var/www/html/app/Providers/AppServiceProvider.php

# Restart Apache
sudo service httpd restart