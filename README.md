# Intro
- This repository contains the implementation of the ms-assignment.

# Guide
- The repository contains:
  -  Two APIs. The docs describing those apis are present in: [serviceA-implementation-details](/docs/serviceA-implementation-details.md) and [serviceB-implementation-details](/docs/serviceB-implementation-details.md).
  -  The infrastructure-as-code configuration. This configuration is split in two parts:
     -  The dependency configuration.
        -  Represents the initial configurations that cannot be automated through the pipelines: [dependency configuration](/docs/dependency-configuration.md).
     -  The resources configuration 
        -  Represents the resources configuration that is automated using the Github pipelines: [resources-configuration](/docs/resources-configuration.md).
  - Pipelines
    - docker publish
      - Used to build images and publish them to the registry. More details about this: [docker-publish](/docs/docker-publish.md)
    - terraform
      - Used to automate the resource configuration. More details about this: [terraform-automatic](/docs/terraform-automatic.md)
    - terraform destroy
      - Used to destroy the resource configuration. More details about this: [terraform-destroy](/docs/terraform-destroy.md)
    - deploy to kubernetes
      - Used to deploy the services to Kubernetes using Helm. More details about this: [kubernetes-configuration](/docs/kubernetes-configuration.md)