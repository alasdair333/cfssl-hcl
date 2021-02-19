#cfssl-hcl 
## Create

To build an image you will need to do the following: 

```bash

export COMMON_NAME=mydomain.local
export LOCALITY=locality
export STATE=state
export COUNTRY=GB

packer build -var 'repo=docker-repo-to-push.to:5000/image-name' cfssl.pkr.hcl

```