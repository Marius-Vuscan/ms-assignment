# Intro
- This repository contains the implementation of the ms-assignment.

# Guide
- The repository contains:
  -  Two APIs. The docs describing those apis are present in: [serviceA-implementation-details](/docs/serviceA-implementation-details.md) and [serviceB-implementation-details](/docs/serviceB-implementation-details.md).
  -  The infrastructure-as-code configuration. This configuration is split in two parts:
     -  The service principal configuration for authorizing the Github pipeline to execute Terraform commands: [service-principal-creation](/docs/service-principal-creation.md).
     -  The resources configuration that is automated using the Github pipelines: [resources-configuration](/docs/resources-configuration.md).

