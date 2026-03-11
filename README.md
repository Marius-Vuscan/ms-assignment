# Intro
This repository contains the implementation of the Microsoft assignment for the job interview. 

## Requirement
Create Kubernetes cluster in Azure, AWS or GCP, using Pulumi or Terraform:

1. Setup K8s cluster with the latest stable version, with RBAC enabled.
2. The Cluster should have 2 services deployed – Service A and Service B:
- Service A is a WebServer written in C# or Go that exposes the following:
    1. Current value of Bitcoin in USD (updated every 10 seconds taken from an API on the web).
    2. Average value over the last 10 minutes.
- Service B is a REST API service, which exposes a single controller that responds 200 status code on GET requests.
4. Cluster should have NGINX Ingress controller deployed, and corresponding ingress rules for Service A and Service B.
5. Service A should not be able to communicate with Service B.

## General Guidelines
- The following cluster buildout should be secure, repeatable and automated as much as possible.
- Share the source code and any other related artifacts to this task (YAMLs, templates, etc.) in a GitHub repo. The repo should contain a Readme file, with a detailed "How-To" guide.

# Contents
- The repository contains:
  1. Two APIs. The docs describing those apis are present in: [serviceA-implementation-details](/docs/serviceA-implementation-details.md) and [serviceB-implementation-details](/docs/serviceB-implementation-details.md).
  2. The infrastructure-as-code configuration. This configuration is split in two parts:
     - The dependency configuration.
       -  Represents the initial configurations that cannot be automated through the pipelines: [dependency configuration](/docs/dependency-configuration.md).
     - The resources configuration 
       -  Represents the resources configuration that is automated using the Github pipelines: [resources-configuration](/docs/resources-configuration.md).
  3. Pipelines
     - docker publish
       - Used to build images and publish them to the registry. More details about this: [docker-publish](/docs/docker-publish.md)
     - terraform
       - Used to automate the resource configuration. More details about this: [terraform-automatic](/docs/terraform-automatic.md)
     - terraform destroy
       - Used to destroy the resource configuration. More details about this: [terraform-destroy](/docs/terraform-destroy.md)
     - deploy to kubernetes
       - Used to deploy the services to Kubernetes using Helm. More details about this: [kubernetes-configuration](/docs/kubernetes-configuration.md)

# Usage
- To have a smooth setup, the steps have to be executed in a certain order. More details: [executing-steps-in-order](/docs/executing-steps-in-order.md)
