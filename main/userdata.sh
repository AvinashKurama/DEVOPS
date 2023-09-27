#!/bin/bash
sudo apt update
sudo apt install openjdk-11-jdk
wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add -
echo "deb https://pkg.jenkins.io/debian binary/" | sudo tee -a /etc/apt/sources.list
sudo apt update
sudo apt install jenkins
sudo systemctl status jenkins
sudo systemctl start jenkins
#sudo cat /var/lib/jenkins/secrets/initialAdminPassword
sudo apt update
sudo apt install nginx 

