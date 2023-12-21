# Intro
- This document describes the procedure of building images and publishing them to the container registry,

# Going into details
- The container registry is created through Terraform as part of the resource configuration.
- Before, doing anything related to Docker, we need to deal with versioning. 
  - For that we used a versioning file [GitVersion.yml](../GitVersion.yml) that describes the versioning strategy. In short, semantic versioning was used.
  - We also had steps in the pipeline that used this file.
  - More details about the steps in the [official documentation](https://gitversion.net/docs/usage/ci).
  - The version will be used as the tag of the image.
- Once we had the version, the pipeline was split into two jobs (one for each service).
  - It had jobs for:
    - login into the registry using username and password
    - building the image
    - pushing the image

# When is the pipeline executed?
- When changes to the 'proj folder are done.
- The service jobs are skipped if we are talking about a PR.