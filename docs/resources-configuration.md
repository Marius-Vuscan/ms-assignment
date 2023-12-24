# Intro
- This document describes the resources configuration.

# Going into details
## Resource group
- All the resources that we created (from the resource configuration category), will be placed in this group.

## Acr
- Used to store docker images.
- The credentials are placed in Github secrets using the Github provider.

### Aks
- Represents the Azure Kubernetes services.
- It uses v1.28.3 (latest at the time of creation).
- A role was assigned to aks to be able to pull images from acr.
- A Github secret resource is also used to create a secret for the kube-config.
