# Intro
This document describes the dependency configurations setup. We call dependency configuration any configuration that is required and cannot be automated.

# Service principal
- In order to execute the Terraform operations described in the git repository from a Github pipeline, we first need to authorize Terraform to execute actions to our Azure cluster. The chosen authorization method was the service principal.
- The service principal configuration was done using a Terraform script that will be ran locally.
- The service principal was configured with the contributor role.

## Steps
- go inside the service-principal-creation folder: **infra\modules\dependency-configuration**
- run the init command: ```terraform init```
- replace the subscription-id placeholder and run the plan command: ```terraform plan -out sp.tfplan -var="subscription_id=<subscription-id>"```
- replace the subscription-id placeholder and run the apply command: ```terraform apply "sp.tfplan"```
- once the service principal is created, it will return some data like client_id, client_secret and tenant_id for which we will have to create github secrets: 
  - ARM_CLIENT_ID : client_id
  - ARM_CLIENT_SECRET: client_secret
  - ARM_SUBSCRIPTION_ID: subscription-id
  - ARM_TENANT_ID: tenant_id

### Cleanup steps
- To remove the resources after we are done using them, we run: ```terraform destroy```

# Storage account
- The state of terraform has to be stored remotely as every pipeline run will start fresh with no knowledge of the previous state. For this purpose, the storage account was chosen.
- Again, the storage account creation as well as the sas token were created using Terraform script that was executed locally. The state of the local script run was kept locally.

## Steps
- we assume that the terraform commands were already executed as part of the previous dependency's configuration.
- what is left is to create github secrets using the results:
  - SA_NAME: storage_account_name
  - SA_TOKEN: sas_token

# Github PAT
- To manage secrets in a secure way, and to avoid displaying any secret in the pipeline, it was decided that a Terraform script will have the possibility to create Github secrets so they can be used in other scripts. E.g., After we create a container registry, we generate Github secretes for the: registry name, username and password.
- For this, we used the [Github provider](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/actions_secret) that requires a PAT token.

## Steps
- Generate new PAT allowing access to the repo scopes.
- We create a secret TF_GITHUB_TOKEN with the path name as the value.