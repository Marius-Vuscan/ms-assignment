# Intro
- This document describes the terraform destroy pipeline.

# Going into details
- This pipeline is meant to cleanup resources. This was done to save cost when this configuration is not used.
- The configuration is similar to the [terraform-automatic](terraform-automatic.md), the main difference being that we call terraform destroy instead of terraform apply. Another difference is that the format and plan commands are not required.

# When is the pipeline executed?
- The pipeline is triggered manually from the Github portal.