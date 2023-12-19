# Intro
- In order to execute the Terraform operations described in the git repository from a Github pipeline, we first need to authorize Terraform to execute actions to our Azure cluster. The chosen authorization method was the service principal.
- The service principal configuration was done using a Terraform script that will be ran locally.
- The service principal was configured with minimal roles.

# Steps
- go inside the service-principal-creation folder: **infra\modules\service-principal-creation**
- run the init command: ```terraform init```
- replace the subscription-id placeholder and run the plan command: ```terraform plan -out sp.tfplan -var="subscription_id=<subscription-id>"```
- replace the subscription-id placeholder and run the apply command: ```terraform apply "sp.tfplan"```