#!/bin/sh

if [ ! -f "/certs/ca-key.pem" ] || [ ! -f "/certs/ca.pem" ]; then 
    echo "Generating CA key and cert"
    cd /certs/
    cfssl gencert -initca ca-csr.json | cfssljson -bare ca
    cd /
fi

cfssl serve -address=0.0.0.0 -ca-key=/certs/ca-key.pem -ca=/certs/ca.pem -config=/certs/ca-config.json