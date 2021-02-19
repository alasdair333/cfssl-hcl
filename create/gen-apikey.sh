#!/bin/bash

API_KEY=$(hexdump -n 16 -e '4/4 "%08X" 1 "\n"' /dev/random)

echo "Your API key for CFSSL: $API_KEY"
sed "s/API_KEY/$API_KEY/" ca-config.json.tpl > ca-config.json

sed -e "s/COMMON_NAME/$COMMON_NAME/g"  \
    -e "s/COUNTRY/$COUNTRY/g"  \
    -e "s/LOCALITY/$LOCALITY/g" \
    -e "s/STATE/$STATE/g" \
    ca-csr.json.tpl > ca-csr.json
