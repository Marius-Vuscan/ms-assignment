# Intro
- This document describes how was the deployment inside Kubernetes done as well as what was deployed.

# How was the deployment done
- The deployment was automated using Helm and a [pipeline](../.github/workflows/deploy-to-kubernetes.yml) dedicated for that.
- In order for the action to be authorized to deploy inside Kubernetes, the kube-config was used. The kube-config was made available as a Github secrete that was created by a Terraform script.
- The configuration mainly consists of an umbrella chart, so the pipeline focuses just on installing that chart. This implementation must be adjusted if multiple charts would be involved.

# What was deployed
- We have one umbrella chart that is composed of:
  - a sub-chart for servicea
  - a sub-chart for serviceb
  - a dependency on nginx

## Nginx
- It was described as a dependency to the chart, so when the installation is done, the nginx will also be installed.
- Specific ingress configurations were defined for each service in the dedicated chart.

## Service a and service b
- The configuration is similar, so only one will be described.
- The configuration mainly consists of:
  - Deployment
  - Ingress
    - Each service is routed using its name as the prefix. To call service a you would use: **{host}/servicea/bitcoindata**
    - To verify: ```curl "http://apis-umbrella-release-ingress-nginx-controller.default.svc.cluster.local:80/servicea/bitcoindata" -v```.
    This will call the service a indirectly through the nginx controller, by specifying the /servicea prefix.
  - Network
    - The network policy that allows traffic from all pods except service b, respectively service a.
    - To verify: ```curl "http://apis-umbrella-release-servicea.default.svc.cluster.local:8080/bitcoindata"``` from service b pod.
    This request will fail as service b should not be able to call service a.
  - Service
    - Of type ClusterIP to not be exposed directly outside the cluster but through nginx.