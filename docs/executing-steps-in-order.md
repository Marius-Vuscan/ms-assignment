# Intro 
- This document describes the order in which the steps have to be executed.
  
# Steps
1. Execute the [dependency-configuration steps](dependency-configuration.md).
    - This will prepare everything that is required for the pipelines.
2. Run the [terraform pipeline](../.github/workflows/terraform.yml) by making a change in the /modules/resources-configuration/ folder. 
    - This will ensure that every Cloud resource required is created.
    - These docs contain the details of that configuration: [resources-configuration](resources-configuration.md)
3. Run the [docker publish pipeline](../.github/workflows/docker-publish.yml) by making a change in the proj folder.
    - This will build docker images for our apis.
    - These docs contain the details of that configuration: [docker-publish](docker-publish.md)
4. Run the [deploy to kubernetes pipeline](../.github/workflows/deploy-to-kubernetes.yml) by making a change in the helm folder.
    - This will deploy the components inside Kubernetes.
    - These docs contain the details of that configuration: [docker-publish](kubernetes-configuration.md)
   - In the previous step we generated new image versions and push them to the registry. If that was the first time the pipeline was executed, then it is likely that the kubernetes deployments use application versions that are not present in the acr. Because of this, the pods will not start. 
   To solve this we need to go to each chart file and update the configuration to use the new version (appVersion: ""). The new version was also logged in the pipeline execution, so it can be taken from there.
5. (Optional) Once we stop using this configuration, we should cleanup the resources (created at step 2) to save up cost by manually running the [terraform destroy pipeline](../.github/workflows/terraform-destory.yml)
    - More details about this: [terraform-destroy](terraform-destroy.md)
    - Also, we need to destroy the resources used as part of the dependency configuration (step 1). This is done by following the [dependency-configuration docs](dependency-configuration.md) in section (Cleanup steps).