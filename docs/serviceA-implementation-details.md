# Intro
- This document describes the service A implementation details.

# Details
- This service calls an external public Api for retrieving the current Bitcoin value.
- Exposes one endpoint: GET /bitcoindata that return a response like:
  ```
  {
    currentValue = x,
    averageValue = y
  }
  ```
- Calls are made periodically to the external service through a background service (every 10s).
- The results are stored in an in-memory custom data provider.
- The external service does not require any form of auth.