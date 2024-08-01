#!/bin/bash
sudo apt update
sudo apt install apache2
sudo su -
echo "<h1>Hello World from WebServer01 $(hostname -f)</h1>" > /var/www/html/index.html