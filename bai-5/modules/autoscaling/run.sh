#!/bin/bash
yum update -y
yum install -y httpd.x86_64
systemctl start httpd
systemctl enable http
echo "$(curl http://169.254.169.254/latest/meta-data/local-ipv4)" > /var/www/html/index.html