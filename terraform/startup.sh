#!/bin/bash

sudo apt update -y
sudo apt install -y nginx

cat <<EOF | sudo tee /var/www/html/index.html
<html><body><h1>It works!</h1><p>$(hostname)</p></body></html>
EOF

sudo systemctl restart nginx
