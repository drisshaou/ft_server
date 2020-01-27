#!/bin/sh

cd /etc
mkdir mkcert
cd mkcert
curl -L https://github.com/FiloSottile/mkcert/releases/download/v1.1.2/mkcert-v1.1.2-linux-amd64 > mkcert
chmod +x mkcert
./mkcert -install
./mkcert localhost
mv localhost.pem /etc/ssl/certs/localhost.pem
mv localhost-key.pem /etc/ssl/certs/localhost-key.pem
