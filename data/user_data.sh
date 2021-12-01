#!/bin/bash

# Check how long it takes to setup
date > /tmp/time.txt

# Install AWS EFS Utilities
sudo yum update -y
sudo yum install -y amazon-efs-utils
# Mount EFS to wordpress dir
sudo mkdir /efs
sudo file_system_id="${file_system_id}"
sudo mount -t efs $file_system_id:/ /efs
# Edit fstab so EFS automatically loads on reboot
sudo echo $file_system_id:/ /efs efs defaults,_netdev 0 0 >> /etc/fstab

# Install docker and run Wordpress container
sudo yum install -y docker
sudo usermod -aG docker ec2-user
sudo service docker start
sudo service docker enable
sudo docker run --name wordpress -p 80:80 -e WORDPRESS_DB_HOST=${db_host}:3306 \
                -e WORDPRESS_DB_USER=${db_username} -v /efs:/var/www/html -e WORDPRESS_DB_PASSWORD=${db_password} \
                -e WORDPRESS_DB_NAME=${db_name} -d wordpress

# Check how long it takes to setup
date >> /tmp/time.txt