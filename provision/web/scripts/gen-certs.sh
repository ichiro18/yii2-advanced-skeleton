#!/usr/bin/env bash

if [ -d /var/www/provision/proxy/certs/$1 ]; then
    rm -rf /var/www/provision/proxy/certs/$1
fi;

mkdir /var/www/provision/proxy/certs/$1 && cd /var/www/provision/proxy/certs/$1

echo "authorityKeyIdentifier = keyid,issuer
basicConstraints       = CA:FALSE
keyUsage               = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
subjectAltName         = DNS:$1,DNS:www.$1" > v3.ext;

openssl genrsa -out cert_rootCA.key 2048

openssl req -x509 -new -nodes \
	-key cert_rootCA.key -sha256 \
	-days 3650 \
	-out cert_rootCA.pem \
	-subj "/C=UK/O=Organization"

echo "[req]
default_bits       = 2048
prompt             = no
default_md         = sha256
distinguished_name = dn

[dn]
C            = UK
ST           = England
L            = London
O            = Organization
OU           = Organization dept.
emailAddress = admin@$1
CN           = $1" >> cert_rootCA.csr.cnf

openssl req -new -sha256 -nodes \
    -out cert.csr \
    -newkey rsa:2048 \
    -keyout cert.key \
    -config cert_rootCA.csr.cnf

openssl x509 -req \
    -in cert.csr \
    -CA cert_rootCA.pem \
    -CAkey cert_rootCA.key \
    -CAcreateserial \
    -out cert.crt -days 3650 -sha256 \
    -extfile v3.ext