# Intro
- This document describes the known issues.

# Issues
- Let's say that the container registry does not exist yet, because the terraform script was not executed yet. In that case, if we try to run the docker publish pipeline, it will fail, simply because the registry does not exists yet.
  - This is not a blocking issue and was left open.