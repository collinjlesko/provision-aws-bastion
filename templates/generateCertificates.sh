touch ~/.rnd

echo "generating self-signed ssl certificate..."
openssl req \
    -new \
    -newkey rsa:4096 \
    -days 365 \
    -nodes \
    -x509 \
    -subj "/C=US/ST=Denial/L=Springfield/O=Dis/CN=www.example.com" \
    -keyout /etc/ssl/private/bastion-selfsigned.key \
    -out /etc/ssl/certs/bastion-selfsigned.cert

echo "generating strong Diffie-Hellman group (this might take a couple of minutes)..."
openssl dhparam -out /etc/ssl/certs/dhparam.pem 2048