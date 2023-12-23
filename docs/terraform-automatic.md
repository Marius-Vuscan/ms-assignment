# Intro
- This document describes the terraform pipeline.

# Going into details
- It mainly executes the standard commands: init, fmt, plan, apply
  - As part of init, the storage account configuration was linked for storing the state.
- The pipeline requires
  - the secrets with prefix ARM_.
  - the PAT token secret.
  - the storage account secrets.

# When is the pipeline executed?
- When changes to the './infra/modules/resources-configuration' folder are done.
- The apply is not executed if we are talking about a PR.