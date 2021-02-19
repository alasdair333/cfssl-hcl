#cfssl-hcl 
## Deploy

To deploy you will need to do the following: 

```bash

export TF_VAR_host=ssh://user@deploy_target.local
export TF_VAR_docker_image_name="container_name"

terraform init
terraform plan
terraform apply


```