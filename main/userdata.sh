#!/bin/bash
sudo apt update -y
sudo apt install nginx -y 
sudo systemctl enable nginx
sudo systemctl start nginx
sudo cat > /var/www/html/index.html << EOF
this is server avinash is learning $(hostname)
EOF
sudo cd
sudo mkdir avinash