#!/bin/bash

#Mount the EFS file system to the wordpress dir
wordpress_dir=/var/www/html
mkdir $wordpress_dir
mount -t efs ${file_system_id}:/ $wordpress_dir

yum update -y
yum install -y httpd

echo "hello world" > /var/www/html/index.html

systemctl start httpd
systemctl start mysqld

usermod -a -G apache ec2-user
chown -R ec2-user:apache /var/www
find /var/www -type d -exec chmod 2775 {} \;
find /var/www -type f -exec chmod 0664 {} \;